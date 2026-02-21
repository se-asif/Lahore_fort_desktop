import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import '../db_helper/DataBaseHelper.dart';

class LocalApiServer {
  static HttpServer? _server;
  static const int port = 8088;
  static const String desiredStaticIP = "192.168.1.112";
  static Future<String?> _getCurrentSystemIP() async {
    try {
      final interfaces = await NetworkInterface.list();
      for (var interface in interfaces) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            return addr.address;
          }
        }
      }
      return null;
    } catch (e) {
      print('Error detecting network interfaces: $e');
      return null;
    }
  }
  static Future<bool> startServer() async {
    if (_server != null) return true;

    final currentIP = await _getCurrentSystemIP();

    if (currentIP == null) {
      print('ERROR: No IPv4 network connection detected.');
      return false;
    }
    print('Detected system IP: $currentIP');
    if (currentIP != desiredStaticIP) {
      print('ERROR: Current IP ($currentIP) does not match required static IP ($desiredStaticIP)');
      print('Please set your network adapter to static IP: $desiredStaticIP');
      return false;
    }
    final handler = const Pipeline()
        .addMiddleware(corsHeaders())
        .addHandler(_handleRequest);

    try {
      _server = await shelf_io.serve(handler, desiredStaticIP, port);
      print('✓ Local Validation API Running → http://$desiredStaticIP:$port');
      print('   POST /validate → {"transactionUniqueId": "IP_123456789"}');
      return true;
    } catch (e) {
      print('Failed to bind server to $desiredStaticIP:$port');
      print('Error: $e');
      if (e is SocketException) {
        if (e.message.contains('in use') || e.osError?.errorCode == 48) {
          print('→ Port $port is already in use by another process.');
        }
      }
      return false;
    }
  }

  static Future<Response> _handleRequest(Request request) async {
    if (request.method != 'POST' || request.url.path != 'validate') {
      return Response.notFound('Invalid request');
    }

    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);
      final String? scannedData = data['transactionUniqueId']?.toString().trim();

      print("GATE SCAN → $scannedData at ${DateTime.now()}");

      if (scannedData == null || scannedData.isEmpty) {
        return Response.ok(jsonEncode({"valid": false, "message": "Missing ID"}));
      }

      String scannedId = scannedData;
      if (scannedData.contains('_')) {
        final parts = scannedData.split('_');
        if (parts.length >= 2) {
          scannedId = parts.sublist(1).join('_');
          print("Extracted Transaction ID: $scannedId (from $scannedData)");
        }
      }

      final db = await DatabaseHelper.instance.database;
      final result = await db.rawQuery('''
        SELECT * FROM visiting_data 
        WHERE person_ids LIKE ?
        LIMIT 1
      ''', ['%$scannedId%']);

      if (result.isEmpty) {
        print("REJECTED: Person ID $scannedId not found");
        return Response.ok(jsonEncode({"valid": false, "message": "Ticket not found"}));
      }

      final ticket = result.first;
      final mainId = ticket['transactionUniqueId'] as String;
      final String usedPersonIdsStr = (ticket['used_person_ids'] as String?) ?? '';
      final List<String> usedPersonIds = usedPersonIdsStr.isEmpty
          ? []
          : usedPersonIdsStr.split(',');

      if (usedPersonIds.contains(scannedId)) {
        print("REJECTED: Person $scannedId already used this ticket");
        return Response.ok(jsonEncode({
          "valid": false,
          "used": true,
          "message": "This person already entered",
          "used_at": ticket['used_at']
        }));
      }

      final newUsedIds = [...usedPersonIds, scannedId];
      await db.update(
        'visiting_data',
        {
          'used_person_ids': newUsedIds.join(','),
          'used_at': DateTime.now().toIso8601String(),
        },
        where: 'transactionUniqueId = ?',
        whereArgs: [mainId],
      );

      final remaining = (ticket['totalPersons'] as String?)?.isNotEmpty == true
          ? int.tryParse(ticket['totalPersons'] as String) ?? 0
          : 0;
      final entered = newUsedIds.length;

      print("GATE OPENED! Person $scannedId entered");
      print("Progress: $entered/$remaining people used this ticket");

      return Response.ok(jsonEncode({
        "valid": true,
        "message": "Gate Open - Welcome!",
        "scannedPersonId": scannedId,
        "entered": entered,
      }));
    } catch (e, stack) {
      print("API ERROR: $e\n$stack");
      return Response(500, body: jsonEncode({"error": "Server error"}));
    }
  }

  static Future<void> stopServer() async {
    await _server?.close();
    _server = null;
    print('Server stopped.');
  }
}
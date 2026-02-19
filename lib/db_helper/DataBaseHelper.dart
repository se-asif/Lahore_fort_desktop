import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../data_models/visiting_data_list/visiting_data_list.dart';
import '../utils/SharedPrefHelper.dart';
import '../utils/log.dart';

class DatabaseHelper {
  static Database? _database;
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  final ValueNotifier<int> visitCountNotifier = ValueNotifier<int>(0);

  Future<void> _fetchVisitCount() async {
    final data = await getVisitingData();
    visitCountNotifier.value = data.length;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    PrintLog.printLog("_initDatabase ..... ");
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI for desktop
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      final Directory appSupportDir = await getApplicationSupportDirectory();
      final Directory dbDir = Directory(path.join(appSupportDir.path, 'databases'));
      if (!await dbDir.exists()) {
        await dbDir.create(recursive: true);
      }

      final String dbPath = path.join(dbDir.path, "lahore_fort_live.db");

      PrintLog.printLog("Database path: $dbPath");

      final Database winLinuxDB = await databaseFactoryFfi.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
          version: 5,
          onCreate: _onCreate,
          onUpgrade: _onUpgrade,
        ),
      );
      return winLinuxDB;
    }

    throw Exception("Unsupported platform");
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE visiting_data (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          typeWiseData TEXT,
          paymentId TEXT,
          totalPersons TEXT,
          totalAmount TEXT,
          gateId TEXT,
          parkingLotId TEXT,
          userId TEXT,
          date TEXT,
          userName TEXT,
          gateName TEXT,
          ticketingPoint TEXT,
          transactionUniqueId TEXT UNIQUE,
          userMacId TEXT,
          isUploaded INTEGER DEFAULT 0,
          billNo TEXT,
          used_status INTEGER DEFAULT 0,
          used_at TEXT,
          person_ids TEXT,
          used_person_ids TEXT DEFAULT ''
      )      
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute("ALTER TABLE visiting_data ADD COLUMN used_status INTEGER DEFAULT 0");
      await db.execute("ALTER TABLE visiting_data ADD COLUMN used_at TEXT");
    }
    if (oldVersion < 4) {
      await db.execute("ALTER TABLE visiting_data ADD COLUMN person_ids TEXT");
      print("Added person_ids column");
    }
    if (oldVersion < 5) {
      await db.execute("ALTER TABLE visiting_data ADD COLUMN used_person_ids TEXT DEFAULT ''");
      print("Added used_person_ids column for per-person tracking");
    }
  }

  Future<int> insertVisitingData(VisitingDataList data) async {
    final db = await database;
    final dataMap = data.toJson();
    dataMap['typeWiseData'] = jsonEncode(data.typeWiseData);

    List<String> allPersonIds = [];
    for (var category in data.typeWiseData ?? []) {
      final ids = category['transection_unique_ids'];
      if (ids is List) {
        allPersonIds.addAll(ids.map((e) => e.toString()));
      }
    }
    dataMap['person_ids'] = allPersonIds.join(',');
    dataMap['used_person_ids'] = '';

    int result = await db.insert("visiting_data", dataMap);
    _fetchVisitCount();
    return result;
  }

  Future<bool> isTicketUsed(String transactionUniqueId) async {
    final db = await database;
    final result = await db.query(
      'visiting_data',
      columns: ['used_status'],
      where: 'transactionUniqueId = ?',
      whereArgs: [transactionUniqueId],
    );
    if (result.isEmpty) return false;
    return (result.first['used_status'] as int?) == 1;
  }

  Future<bool> markTicketAsUsed(String transactionUniqueId) async {
    final db = await database;
    final alreadyUsed = await isTicketUsed(transactionUniqueId);
    if (alreadyUsed) return false;
    final rowsAffected = await db.update(
      'visiting_data',
      {
        'used_status': 1,
        'used_at': DateTime.now().toIso8601String(),
      },
      where: 'transactionUniqueId = ?',
      whereArgs: [transactionUniqueId],
    );
    if (rowsAffected > 0) _fetchVisitCount();
    return rowsAffected > 0;
  }

  Future<VisitingDataList?> getTicketByUniqueId(String transactionUniqueId) async {
    final db = await database;
    final maps = await db.query(
      'visiting_data',
      where: 'transactionUniqueId = ?',
      whereArgs: [transactionUniqueId],
    );
    if (maps.isEmpty) return null;
    return VisitingDataList.fromJson({
      ...maps.first,
      "typeWiseData": jsonDecode(maps.first["typeWiseData"] as String),
    });
  }

  Future<int> updateIsUploaded(String id) async {
    final db = await database;
    int result = await db.update(
      "visiting_data",
      {"isUploaded": 1},
      where: "transactionUniqueId = ?",
      whereArgs: [id],
    );
    _fetchVisitCount();
    return result;
  }

  Future<List<VisitingDataList>> getVisitingData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("visiting_data");
    return maps.map((data) {
      return VisitingDataList.fromJson({
        ...data,
        "typeWiseData": jsonDecode(data["typeWiseData"]),
      });
    }).toList();
  }

  Future<List<VisitingDataList>> getPendingData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      "visiting_data",
      where: "isUploaded = ?",
      whereArgs: [0],
    );
    return maps.map((data) {
      return VisitingDataList.fromJson({
        ...data,
        "typeWiseData": jsonDecode(data["typeWiseData"]),
      });
    }).toList();
  }

  Future<void> resetDatabase() async {
    final db = await database;
    await db.execute("DROP TABLE IF EXISTS visiting_data");
    _fetchVisitCount();
    await _onCreate(db, 5);
  }

  Future<void> checkAndClearIfNeeded() async {
    if (SharedPrefHelper.shouldClearDatabase()) {
      final pendingData = await getPendingData();
      if (pendingData.isEmpty) {
        await resetDatabase();
        await SharedPrefHelper.saveLastClearTimestamp(DateTime.now());
      } else {
        print("Pending data exists (${pendingData.length} records). Skipping clear.");
        print("Database will be cleared after all data is uploaded");
      }
    } else {
      print("24 hours not passed yet. Time until next clear: ${SharedPrefHelper.getTimeUntilNextClear()}");
    }
  }

  Future<Map<String, dynamic>> getDatabaseStats() async {
    final allData = await getVisitingData();
    final pendingData = await getPendingData();
    final uploadedData = allData.length - pendingData.length;

    return {
      'total_records': allData.length,
      'pending_records': pendingData.length,
      'uploaded_records': uploadedData,
      'last_clear': SharedPrefHelper.getLastClearTimestamp()?.toIso8601String() ?? 'Never',
      'hours_until_clear': SharedPrefHelper.getHoursUntilNextClear(),
    };
  }

  Future<bool> canSafelyLogout() async {
    final pendingData = await getPendingData();
    return pendingData.isEmpty;
  }
}
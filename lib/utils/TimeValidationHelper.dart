import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'SharedPrefHelper.dart';

class TimeValidationHelper {
  static const String expectedTimezone = 'Asia/Karachi';
  static const int expectedUtcOffset = 5;

  static Future<TimeValidationResult> validateSystemTime() async {
    try {
      final serverTime = await _getServerTime();
      final systemTime = DateTime.now();

      await SharedPrefHelper.saveTrustedTime(serverTime);

      final diff = systemTime.difference(serverTime).abs();

      if (diff.inMinutes > 2) {
        return _invalid(
          'System date/time is incorrect.\nPlease correct it.',
          systemTime,
          serverTime,
          diff,
        );
      }

      return _valid(systemTime, serverTime, diff);
    } catch (_) {
      return _offlineValidation();
    }
  }
  static TimeValidationResult _offlineValidation() {
    final now = DateTime.now();
    if (now.year < 2026) {
      return _invalid('Invalid system date.', now, null, null);
    }
    if (now.timeZoneOffset.inHours != expectedUtcOffset) {
      return _invalid('Incorrect timezone.', now, null, null);
    }

    final lastServer = SharedPrefHelper.getLastServerTime();
    final lastLocal = SharedPrefHelper.getLastLocalTime();

    if (lastServer != null && lastLocal != null) {
      final elapsed = now.difference(lastLocal);
      final expected = lastServer.add(elapsed);

      if (now.isBefore(expected.subtract(Duration(minutes: 2)))) {
        return _invalid(
          'System time moved backwards.\nPlease correct date/time.',
          now,
          null,
          null,
        );
      }
    }

    return _valid(now, null, null);
  }
  static Future<DateTime> _getServerTime() async {
    final res = await http
        .get(Uri.parse(
        'https://worldtimeapi.org/api/timezone/$expectedTimezone'))
        .timeout(Duration(seconds: 10));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return DateTime.parse(data['datetime']);
    }

    throw Exception('Server time failed');
  }

  static TimeValidationResult _invalid(
      String msg,
      DateTime system,
      DateTime? server,
      Duration? diff,
      ) =>
      TimeValidationResult(
        isValid: false,
        message: msg,
        systemTime: system,
        serverTime: server,
        difference: diff,
      );

  static TimeValidationResult _valid(
      DateTime system,
      DateTime? server,
      Duration? diff,
      ) =>
      TimeValidationResult(
        isValid: true,
        message: 'Time validated',
        systemTime: system,
        serverTime: server,
        difference: diff,
      );

  static String format(DateTime d) =>
      DateFormat('yyyy-MM-dd HH:mm:ss').format(d);
}
class TimeValidationResult {
  final bool isValid;
  final String message;
  final DateTime systemTime;
  final DateTime? serverTime;
  final Duration? difference;

  TimeValidationResult({
    required this.isValid,
    required this.message,
    required this.systemTime,
    this.serverTime,
    this.difference,
  });
}



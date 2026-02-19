import 'dart:io';

class SystemIPHelper {
  static Future<String> getSystemIP() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            print('System IP: ${addr.address}');
            return addr.address;
          }
        }
      }
      return 'unknown';
    } catch (e) {
      print('Error getting IP: $e');
      return 'unknown';
    }
  }
  static Future<String> createQRCodeData(String transactionId) async {
    final ip = await getSystemIP();
    return '${ip}_$transactionId';
  }
}
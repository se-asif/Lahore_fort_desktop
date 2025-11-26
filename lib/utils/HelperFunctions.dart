import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HelperFunction {
  static Future<bool> hasInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    // Ensure it's a list and check if any connection is available
    return connectivityResult.isNotEmpty && connectivityResult.contains(ConnectivityResult.none) == false;
  }
}

import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/TimeValidationHelper.dart';
import 'TimeValidationDialog.dart';
import '../utils/navigation_service.dart';
import '../db_helper/DataBaseHelper.dart';

class TimeValidationWrapper extends StatefulWidget {
  final Widget child;
  const TimeValidationWrapper({Key? key, required this.child}) : super(key: key);
  @override
  _TimeValidationWrapperState createState() => _TimeValidationWrapperState();
}

class _TimeValidationWrapperState extends State<TimeValidationWrapper> {
  bool _isValidating = true;
  Timer? _timer;
  Timer? _dbClearTimer;
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _validateTimeBlocking();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
        await _backgroundValidate();
      });
      _dbClearTimer = Timer.periodic(const Duration(hours: 1), (_) async {
        print("Hourly check: Checking if database needs clearing...");
        await DatabaseHelper.instance.checkAndClearIfNeeded();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _dbClearTimer?.cancel();
    super.dispose();
  }
  Future<void> _validateTimeBlocking() async {
    while (true) {
      final result = await TimeValidationHelper.validateSystemTime();
      if (!mounted) return;

      if (result.isValid) {
        setState(() => _isValidating = false);
        return;
      } else {
        await _showTimeErrorDialog(result);
      }
    }
  }

  Future<void> _backgroundValidate() async {
    if (_isDialogShowing) return;
    final result = await TimeValidationHelper.validateSystemTime();
    if (!mounted) return;
    if (!result.isValid) {
      await _showTimeErrorDialog(result);
    }
  }

  Future<void> _showTimeErrorDialog(TimeValidationResult result) async {
    if (!mounted || _isDialogShowing) return;

    final dialogContext = rootNavigatorKey.currentContext;
    if (dialogContext == null) {
      await Future.delayed(const Duration(milliseconds: 300));
      return _showTimeErrorDialog(result);
    }

    _isDialogShowing = true;

    await showDialog(
      context: dialogContext,
      barrierDismissible: false,
      builder: (context) => TimeValidationDialog(result: result),
    );

    _isDialogShowing = false;
  }
  @override
  Widget build(BuildContext context) {
    if (_isValidating) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                'Validating system time...',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 10),
              Text(
                'Please wait',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      );
    }
    return widget.child;
  }
}
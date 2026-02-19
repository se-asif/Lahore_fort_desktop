import 'package:flutter/material.dart';
import 'dart:io';
import '../utils/TimeValidationHelper.dart';

class TimeValidationDialog extends StatelessWidget {
  final TimeValidationResult result;

  const TimeValidationDialog({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 30),
            SizedBox(width: 10),
            Text('Time Sync Required'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'System time must be accurate to use this application.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 20),
              _buildInfoRow('System Time', _formatDateTime(result.systemTime)),
              if (result.serverTime != null)
                _buildInfoRow('Actual Time', _formatDateTime(result.serverTime!)),
              if (result.difference != null)
                _buildInfoRow(
                  'Difference',
                  '${result.difference!.inMinutes} minutes',
                  isError: true,
                ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📋 How to Fix:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._getInstructions(),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => exit(0),
            icon: const Icon(Icons.close, color: Colors.red),
            label: const Text('Exit App', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isError ? Colors.red : Colors.black87,
                fontWeight: isError ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${_formatTime(dateTime)}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

  List<Widget> _getInstructions() {
    if (Platform.isWindows) {
      return [
        _instructionStep('1. Right-click on time in taskbar'),
        _instructionStep('2. Select "Adjust date/time"'),
        _instructionStep('3. Enable "Set time automatically"'),
        _instructionStep('4. Set timezone to "(UTC+05:00) Islamabad, Karachi"'),
        _instructionStep('5. Click "Sync now" button'),
      ];
    } else if (Platform.isLinux) {
      return [
        _instructionStep('1. Open System Settings'),
        _instructionStep('2. Go to Date & Time'),
        _instructionStep('3. Enable "Automatic Date & Time"'),
        _instructionStep('4. Set timezone to "Asia/Karachi"'),
        _instructionStep('5. Apply changes and restart app'),
      ];
    }
    return [
      _instructionStep('Please sync your system time with internet time'),
    ];
  }

  Widget _instructionStep(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, height: 1.4),
      ),
    );
  }
}

/// Loading dialog for time validation
class TimeValidationLoadingDialog extends StatelessWidget {
  const TimeValidationLoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: const Dialog(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Validating system time...'),
            ],
          ),
        ),
      ),
    );
  }
}
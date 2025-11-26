import 'package:flutter/material.dart';
import 'package:flutter_sliding_toast/flutter_sliding_toast.dart';

class ToastUtils {
  static void showSuccessToast(BuildContext context, String message) {
    InteractiveToast.slideSuccess(
      context,
      title: Text(message),
      toastSetting: const SlidingToastSetting(
        toastStartPosition: ToastPosition.right,
        toastAlignment: Alignment.topRight,
          maxWidth: 50.0
      ),
    );
  }

  static void showErrorToast(BuildContext context, String message) {
    InteractiveToast.slideError(
      context,
      title: Text(message),
      toastSetting: const SlidingToastSetting(
          toastStartPosition: ToastPosition.right,
          toastAlignment: Alignment.topRight,
        maxWidth: 200,
        animationDuration: Duration(seconds: 3)
      ),
    );
  }

  static void  showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3), // Like a toast duration

      ),
    );
  }

}

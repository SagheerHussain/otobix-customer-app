import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

enum ToastType { success, error, warning, info }

class ToastWidget {
  static void show({
    required BuildContext context,
    required String title,
    required ToastType type,
    String? subtitle,
    int toastDuration = 3,
  }) {
    Color color;
    IconData icon;

    switch (type) {
      case ToastType.success:
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case ToastType.error:
        color = Colors.red;
        icon = Icons.error;
        break;
      case ToastType.warning:
        color = Colors.orange;
        icon = Icons.warning;
        break;
      case ToastType.info:
        color = Colors.blue;
        icon = Icons.info;
        break;
    }

    DelightToastBar(
      position: DelightSnackbarPosition.top,
      snackbarDuration: Duration(seconds: toastDuration),
      autoDismiss: true,
      builder:
          (context) => Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ToastCard(
              color: color,
              leading: Icon(icon, size: 28, color: Colors.white),
              title: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              subtitle:
                  subtitle != null
                      ? Text(
                        subtitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      )
                      : null,
            ),
          ),
    ).show(context);
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';

class LoginRequiredDialogWidget extends StatelessWidget {
  final String title;
  final String message;
  final String cancelText;
  final String loginText;
  final VoidCallback? onLogin;
  final VoidCallback? onCancel;
  final IconData icon;

  const LoginRequiredDialogWidget({
    super.key,
    this.title = "Login required",
    this.message = "Login to perform this action.",
    this.cancelText = "Not now",
    this.loginText = "Login",
    this.onLogin,
    this.onCancel,
    this.icon = Icons.lock_rounded,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    String title = "Login required",
    String message = "Login to perform this action.",
    String cancelText = "Not now",
    String loginText = "Login",
    IconData icon = Icons.lock_rounded,
    VoidCallback? onLogin,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => LoginRequiredDialogWidget(
        title: title,
        message: message,
        cancelText: cancelText,
        loginText: loginText,
        icon: icon,
        onLogin: onLogin,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top icon bubble
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withOpacity(0.12),
              ),
              child: Icon(icon, size: 28, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 14),

            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.75),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 18),

            // Actions
            Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    text: cancelText,
                    isLoading: false.obs,
                    backgroundColor: AppColors.grey,
                    height: 35,

                    onTap: () {
                      Navigator.pop(context);
                      onCancel?.call();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ButtonWidget(
                    text: loginText,
                    isLoading: false.obs,
                    height: 35,
                    onTap: () {
                      Navigator.pop(context);
                      onLogin?.call();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

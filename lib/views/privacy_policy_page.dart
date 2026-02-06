import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/controllers/privacy_policy_controller.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';
import 'package:otobix_customer_app/widgets/empty_page_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final privacyPolicyController = Get.put(PrivacyPolicyController());

    return Scaffold(
      appBar: AppBarWidget(title: 'Privacy Policy'),
      body: Obx(() {
        if (privacyPolicyController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.green),
          );
        }
        if (privacyPolicyController.error.value != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EmptyPageWidget(
                    icon: Icons.lock,
                    iconColor: AppColors.red,
                    title: 'Privacy Policy',
                    description: 'Error loading privacy policy.',
                  ),
                  // Text(
                  //   privacyPolicyController.error.value!,
                  //   textAlign: TextAlign.center,
                  // ),
                  // const SizedBox(height: 12),
                  // ElevatedButton(
                  //   onPressed: privacyPolicyController.reload,
                  //   child: const Text('Retry'),
                  // ),
                ],
              ),
            ),
          );
        }
        return WebViewWidget(controller: privacyPolicyController.webController);
      }),
    );
  }
}

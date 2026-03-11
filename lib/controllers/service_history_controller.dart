import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/views/service_history_checkout_page.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';

class ServiceHistoryController extends GetxController {
  final TextEditingController registrationController = TextEditingController();

  final RxList<Map<String, dynamic>> reports = <Map<String, dynamic>>[
    {
      'carName': 'Jeep Compass 4x4 Limited',
      'status': 'GENERATED',
      'registrationNumber': 'WB10AHIERNF',
      'transmission': 'Manual',
      'fuelType': 'Diesel',
      'year': '2019',
      'ownership': '2nd',
      'transactionId': 'ABCD-1234567890',
      'date': '5th March, 2026',
    },
  ].obs;

  void onGetServiceHistory() {
    final registrationNumber = registrationController.text.trim();

    if (registrationNumber.isEmpty) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Required',
        subtitle: 'Please enter car registration number.',
        type: ToastType.error,
      );
      return;
    }

    Get.to(() => ServiceHistoryCheckoutPage());
  }

  void onViewSampleReport() {
    Get.snackbar(
      'Sample Report',
      'Open sample report here.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onViewReport(Map<String, dynamic> report) {
    Get.snackbar(
      'View Report',
      'Open report details screen here.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onDownloadReport(Map<String, dynamic> report) {
    Get.snackbar(
      'Download Report',
      'Download report functionality will be added here.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    registrationController.dispose();
    super.onClose();
  }
}

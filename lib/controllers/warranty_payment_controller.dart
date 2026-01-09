import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';

enum PaymentSection { none, upi, cards, netBanking }

class WarrantyPaymentController extends GetxController {
  // Loading
  RxBool isWarrantyPaymentLoading = false.obs;

  // Dummy UI data
  final String warrantyLabel = '(A) Warranty & RSA';
  final String priceSeparator = '-';
  final String warrantyPrice = '₹ 9,999';

  final String upiTitle = 'UPI';
  final String upiHintTitle = 'Scan QR code using any UPI or enter your UPI ID';
  final String upiFieldLabel = 'Enter UPI ID:';
  final String upiHintText = 'example@okaxisbank';
  final String submitText = 'Submit';
  final String qrButtonText = 'Show QR Code';

  final String cardsTitle = 'Cards';
  final List<String> cardsBadges = const ['V', 'M', 'U'];

  final String netBankingTitle = 'Net Banking';
  final List<String> netBankingBadges = const ['S', 'i', 'C'];

  // State
  final Rx<PaymentSection> expandedSection = PaymentSection.upi.obs;
  final RxBool isUpiValid = false.obs;

  // Cards Section State
  final RxBool rememberCard = false.obs;

  // Net Banking Section State
  final RxString selectedBank = ''.obs;
  final List<BankItem> bankList = [
    BankItem(name: 'State Bank of India', shortName: 'SBI'),
    BankItem(name: 'HDFC Bank', shortName: 'HDFC'),
    BankItem(name: 'ICICI Bank', shortName: 'ICICI'),
    BankItem(name: 'Axis Bank', shortName: 'Axis'),
    BankItem(name: 'Kotak Mahindra Bank', shortName: 'Kotak'),
    BankItem(name: 'Punjab National Bank', shortName: 'PNB'),
    BankItem(name: 'Bank of Baroda', shortName: 'BOB'),
    BankItem(name: 'Canara Bank', shortName: 'Canara'),
    BankItem(name: 'Union Bank of India', shortName: 'Union'),
    BankItem(name: 'IndusInd Bank', shortName: 'IndusInd'),
  ];

  final List<BankItem> popularBanks = [
    BankItem(name: 'State Bank of India', shortName: 'SBI'),
    BankItem(name: 'HDFC Bank', shortName: 'HDFC'),
    BankItem(name: 'ICICI Bank', shortName: 'ICICI'),
    BankItem(name: 'Axis Bank', shortName: 'Axis'),
    BankItem(name: 'Kotak Mahindra Bank', shortName: 'Kotak'),
    BankItem(name: 'Punjab National Bank', shortName: 'PNB'),
  ];

  // Input
  final TextEditingController upiIdController = TextEditingController(
    text: 'example@okaxisbank',
  );

  // Dummy apps row
  late final List<UpiAppItem> upiApps;

  // Simple palette
  final _Colors colors = _Colors();

  @override
  void onInit() {
    super.onInit();

    upiApps = [
      UpiAppItem(
        label: 'GPay',
        bg: const Color(0xFFE8F0FE),
        fg: const Color(0xFF1A73E8),
      ),
      UpiAppItem(
        label: 'Paytm',
        bg: const Color(0xFFEAF5FF),
        fg: const Color(0xFF00AEEF),
      ),
      UpiAppItem(
        label: 'PhonePe',
        bg: const Color(0xFFF3E8FF),
        fg: const Color(0xFF6A1B9A),
      ),
      UpiAppItem(
        label: 'Mobikwik',
        bg: const Color(0xFFE6FFFB),
        fg: const Color(0xFF00BFA5),
      ),
      UpiAppItem(
        label: 'Airtel',
        bg: const Color(0xFFFFEBEE),
        fg: const Color(0xFFD32F2F),
      ),
      UpiAppItem(
        label: 'Amazon',
        bg: const Color(0xFFFFF8E1),
        fg: const Color(0xFFFF8F00),
      ),
    ];

    // Validate initial value
    _validateUpi(upiIdController.text);
  }

  void toggleSection(PaymentSection section) {
    if (expandedSection.value == section) {
      expandedSection.value = PaymentSection.none;
    } else {
      expandedSection.value = section;
    }
  }

  void toggleQrVisibility() {
    Get.snackbar(
      'QR',
      'Dummy: Show QR Code tapped',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
    );
  }

  void onUpiChanged(String v) {
    _validateUpi(v);
  }

  void _validateUpi(String v) {
    final value = v.trim();
    final at = value.indexOf('@');
    final valid = at > 2 && at < value.length - 3;
    isUpiValid.value = valid;
  }

  void submitUpi(BuildContext context) {
    isWarrantyPaymentLoading.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      if (!isUpiValid.value) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Please enter a valid UPI ID',
          type: ToastType.error,
        );
        isWarrantyPaymentLoading.value = false;
        return;
      }

      isWarrantyPaymentLoading.value = false;
      Get.back();
      _showSuccessDialog();
    });
  }

  void submitCardPayment(BuildContext context) {
    isWarrantyPaymentLoading.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      isWarrantyPaymentLoading.value = false;
      Get.back();
      _showSuccessDialog();
    });
  }

  void submitNetBankingPayment(BuildContext context) {
    if (selectedBank.value.isEmpty) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Please select a bank',
        type: ToastType.error,
      );
      return;
    }

    isWarrantyPaymentLoading.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      isWarrantyPaymentLoading.value = false;
      Get.back();
      _showSuccessDialog();
    });
  }

  void _showSuccessDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Congratulations!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.green,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                "Your EWI has been\nissued and a notification will\nshortly be received on your\nregistered email.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.35,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "Email: amit.parekh@otobix.in",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 22),

              GestureDetector(
                onTap: () {
                  // TODO: open PDF link
                },
                child: const Text(
                  "Click here to view policy (PDF)",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.blue),
                ),
              ),

              const SizedBox(height: 28),
              ButtonWidget(
                text: 'Close',
                isLoading: false.obs,
                elevation: 5,
                backgroundColor: AppColors.red,
                onTap: () {
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    upiIdController.dispose();
    super.onClose();
  }
}

class UpiAppItem {
  final String label;
  final Color bg;
  final Color fg;

  UpiAppItem({required this.label, required this.bg, required this.fg});
}

class BankItem {
  final String name;
  final String shortName;

  BankItem({required this.name, required this.shortName});
}

class _Colors {
  final Color pageBg = const Color(0xFFFFFFFF);
  final Color cardBg = const Color(0xFFF2F4F7);
  final Color navy = const Color(0xFF0B2C5A);
  final Color primaryText = const Color(0xFF0E1B2A);
  final Color border = const Color(0xFFD6DCE5);
}

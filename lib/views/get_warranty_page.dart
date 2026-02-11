import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/controllers/razorpay_payment_controller.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/controllers/get_warranty_controller.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';

class GetWarrantyPage extends StatelessWidget {
  GetWarrantyPage({super.key, required this.appointmentId, required this.carImageUrl});

  final String appointmentId;
  final String carImageUrl;

  final GetWarrantyController getWarrantyController = Get.put(
    GetWarrantyController(),
  );

  Future<void> submitRsa() async {
    if (getWarrantyController.isGetWarrantyLoading.value) return;

    getWarrantyController.isGetWarrantyLoading.value = true;

    await Future.delayed(const Duration(seconds: 2));

    getWarrantyController.isGetWarrantyLoading.value = false;

    // Pop current page
    if (Get.key.currentState?.canPop() ?? false) {
      Get.back();
    }

    // Show congratulations dialog
    await Future.delayed(
      const Duration(milliseconds: 150),
    ); // small delay after pop
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
                "Your EWI Warranty has been\nissued and a notification will\nshortly be received on your\nregistered email.",
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
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue,
                    // decoration: TextDecoration.underline,
                  ),
                ),
              ),

              const SizedBox(height: 28),
              ButtonWidget(
                text: 'Close',
                isLoading: false.obs,
                elevation: 5,
                // width: double.infinity,
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Get Warranty'),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Vehicle selection card
              _buildCarImageAndID(
                appointmentId: "26-100043",
                imageUrl:
                    "https://images.unsplash.com/photo-1619767886558-efdc259cde1a?auto=format&fit=crop&w=1200&q=80",
              ),
              const SizedBox(height: 14),
              // Warranty Choices
              _buildWarrantyChoices(
                choices: const [
                  "6 Months Engine & Transmission",
                  "6 Months Comprehensive",
                  "12 Months Engine & Transmission",
                  "12 Months Comprehensive",
                ],
              ),

              const SizedBox(height: 20),

              ButtonWidget(
                text: 'Proceed To Buy',
                isLoading: false.obs,
                height: 35,
                width: 200,
                fontSize: 12,
                elevation: 5,
                onTap: () {
                  if (getWarrantyController.selectedWarrantyIndex.value == -1) {
                    ToastWidget.show(
                      context: context,
                      title: 'Select Warranty',
                      subtitle: 'Please select a warranty plan to proceed.',
                      type: ToastType.error,
                    );
                    return;
                  }
                  // If selected a warranty option then navigate to warranty payment page
                  // Get.to(WarrantyPaymentPage());

                  final RazorpayPaymentController razorpayPaymentController =
                      Get.put(RazorpayPaymentController());

                  razorpayPaymentController.onResultMessage = (msg) {
                    debugPrint(msg);
                    ToastWidget.show(
                      context: context,
                      title: "Payment Result",
                      subtitle: msg,
                      type: msg.startsWith("✅")
                          ? ToastType.success
                          : ToastType.error,
                    );
                  };

                  razorpayPaymentController.pay(
                    amountRupees: 1,
                    name:
                        "Get Warranty", // Display name shown on Razorpay checkout sheet.
                    description: "Warranty Purchase",
                    email: "amit.parekh@otobix.in",
                    phone: "9999999999",
                    notes: {
                      'User ID': '12345',
                      "appointmentId": "26-100043",
                      "warrantyIndex":
                          getWarrantyController.selectedWarrantyIndex.value,
                    },
                    receipt:
                        "warranty_${DateTime.now().millisecondsSinceEpoch}",
                  );
                },
              ),

              const SizedBox(height: 20),

              ButtonWidget(
                text: 'Add a Car',
                isLoading: false.obs,
                elevation: 5,
                height: 35,
                width: 200,
                fontSize: 12,
                onTap: () {},
              ),

              const SizedBox(height: 40),
              Text(
                "Click here to view policy (PDF)",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blue,
                  // decoration: TextDecoration.underline,
                ),
              ),

              const SizedBox(height: 18),
            ],
          ),
        ),
      ),

      // Bottom buttons
      // bottomNavigationBar: Container(
      //   color: const Color(0xFFF6F7FB),
      //   padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      //   child: Row(
      //     children: [
      //       Expanded(
      //         child: ButtonWidget(
      //           text: 'Back',
      //           isLoading: false.obs,
      //           elevation: 5,
      //           width: double.infinity,
      //           backgroundColor: AppColors.grey,
      //           onTap: () {
      //             Navigator.maybePop(context);
      //           },
      //         ),
      //       ),
      //       const SizedBox(width: 14),
      //       Expanded(
      //         child: ButtonWidget(
      //           text: 'Add a Car',
      //           isLoading: false.obs,
      //           elevation: 5,
      //           width: double.infinity,
      //           onTap: () {},
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Widget _buildCarImageAndID({
    required String appointmentId,
    required String imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: const Color(0xFFF3F4F6),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(
                      Icons.directions_car,
                      size: 42,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          Text(
            "Appointment ID: $appointmentId",
            style: const TextStyle(
              color: Color(0xFF111827),
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarrantyChoices({required List<String> choices}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select a Warranty Option",
            style: TextStyle(
              color: Color(0xFF111827),
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),

          Obx(
            () => Column(
              children: List.generate(choices.length, (index) {
                final isSelected =
                    getWarrantyController.selectedWarrantyIndex.value == index;

                return InkWell(
                  onTap: () => getWarrantyController.selectWarranty(index),
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        // Radio circle (matches screenshot style)
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF111827),
                              width: 1.3,
                            ),
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.green,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            choices[index],
                            style: const TextStyle(
                              color: Color(0xFF111827),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

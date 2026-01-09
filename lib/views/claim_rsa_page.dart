import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/controllers/claim_rsa_controller.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';

class ClaimRsaPage extends StatelessWidget {
  ClaimRsaPage({super.key});

  final ClaimRsaController claimRsaController = Get.put(ClaimRsaController());

  Future<void> submitRsa() async {
    if (claimRsaController.isClaimRsaLoading.value) return;

    claimRsaController.isClaimRsaLoading.value = true;

    await Future.delayed(const Duration(seconds: 2));

    claimRsaController.isClaimRsaLoading.value = false;

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
                "Your EWI RSA has been\nissued and a notification will\nshortly be received on your\nregistered email.",
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
      appBar: AppBarWidget(title: 'Claim RSA'),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Vehicle selection card
              _buildCarImageAndID(
                appointmentId: "26-100043",
                imageUrl:
                    "https://images.unsplash.com/photo-1619767886558-efdc259cde1a?auto=format&fit=crop&w=1200&q=80",
              ),
              const SizedBox(height: 14),

              // Policy start/end
              Row(
                children: [
                  Expanded(
                    child: _buildPolicyInfo(
                      label: "Policy Start",
                      value: "22/12/2025",
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildPolicyInfo(
                      label: "Policy End",
                      value: "22/12/2026",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),
              _buildCheckboxRow(),
              const SizedBox(height: 18),

              // Policyholder Name
              const Text(
                "Policy Holder Name",
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              _buildInputField(
                hint: "Enter full name",
                icon: Icons.person_outline,
                maxLines: 1,
              ),

              const SizedBox(height: 16),

              // Full Address
              const Text(
                "Full Billing Address",
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              _buildInputField(
                hint: "Enter complete address details",
                icon: Icons.location_on_outlined,
                maxLines: 4,
              ),

              const SizedBox(height: 18),
            ],
          ),
        ),
      ),

      // Bottom buttons
      bottomNavigationBar: Container(
        color: const Color(0xFFF6F7FB),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
        child: Row(
          children: [
            Expanded(
              child: ButtonWidget(
                text: 'Cancel',
                isLoading: false.obs,
                elevation: 5,
                width: double.infinity,
                backgroundColor: AppColors.red,
                onTap: () {
                  Navigator.maybePop(context);
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: ButtonWidget(
                text: 'Submit',
                isLoading: claimRsaController.isClaimRsaLoading,
                elevation: 5,
                width: double.infinity,
                onTap: () {
                  submitRsa();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxRow() {
    return Obx(() {
      final isConsumer = claimRsaController.selectedType.value == "consumer";
      final isBusiness = claimRsaController.selectedType.value == "business";

      Widget item({
        required String title,
        required bool selected,
        required VoidCallback onTap,
      }) {
        return Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFEAF2FF)
                    : const Color(0xFFF5F6F8),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF2F6FED)
                      : const Color(0xFFDDDEE3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: selected,
                    onChanged: (_) => onTap(),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: const VisualDensity(
                      horizontal: -2,
                      vertical: -2,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? const Color(0xFF2F6FED)
                          : const Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return Row(
        children: [
          item(
            title: "Consumer",
            selected: isConsumer,
            onTap: () {
              // select consumer -> business automatically unselect
              claimRsaController.selectedType.value = isConsumer
                  ? ""
                  : "consumer";
            },
          ),
          const SizedBox(width: 12),
          item(
            title: "Business",
            selected: isBusiness,
            onTap: () {
              // select business -> consumer automatically unselect
              claimRsaController.selectedType.value = isBusiness
                  ? ""
                  : "business";
            },
          ),
        ],
      );
    });
  }
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

Widget _buildPolicyInfo({required String label, required String value}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE5E7EB)),
    ),
    child: Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}

Widget _buildInputField({
  required String hint,
  required IconData icon,
  required int maxLines,
}) {
  return TextField(
    maxLines: maxLines,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF9CA3AF),
        fontWeight: FontWeight.w600,
      ),
      prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF20B15A), width: 1.4),
      ),
    ),
  );
}

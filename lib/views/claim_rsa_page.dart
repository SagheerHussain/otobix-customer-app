import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/Models/cars_list_model.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/controllers/claim_rsa_controller.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';

class ClaimRsaPage extends StatelessWidget {
  ClaimRsaPage({super.key, required this.car});

  final CarsListModel car;

  final ClaimRsaController claimRsaController = Get.put(ClaimRsaController());

  @override
  Widget build(BuildContext context) {
    claimRsaController.policyHolderNameCtrl.text = car.registeredOwner;
    return Scaffold(
      appBar: AppBarWidget(title: 'Claim RSA'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCarImageAndID(
                appointmentId: car.appointmentId,
                imageUrl: car.imageUrl,
              ),
              const SizedBox(height: 14),

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
                controller: claimRsaController.policyHolderNameCtrl,
                enabled: false,
              ),

              const SizedBox(height: 16),

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
                controller: claimRsaController.billingAddressCtrl,
                enabled: true,
              ),

              const SizedBox(height: 18),
            ],
          ),
        ),
      ),

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
                  claimRsaController.submitRsa(car: car);
                },
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildInputField({
    required String hint,
    required IconData icon,
    required int maxLines,
    required TextEditingController controller,
    required bool enabled,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        enabled: enabled,
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF9CA3AF),
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
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
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/controllers/warranty_controller.dart';
import 'package:otobix_customer_app/views/claim_rsa_page.dart';
import 'package:otobix_customer_app/views/get_warranty_page.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';

class WarrantyPage extends StatelessWidget {
  WarrantyPage({super.key});

  final WarrantyController warrantyController = Get.put(WarrantyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Warranty'),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Benefits Section
              _buildBenefitsSection(),
              // Inclusions Button
              _buildInclusionsButton(),
              const SizedBox(height: 20),
              // Action Buttons
              _buildActionButtons(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Benefits Section
  Widget _buildBenefitsSection() {
    return Expanded(
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: const Text(
              'Benefits of Extended Warranty',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.green,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 15),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Benefits List
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: warrantyController.benefits.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final benefit = warrantyController.benefits[index];
                      return _buildBenefitItem(benefit);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Single Benefit Item
  Widget _buildBenefitItem(Map<String, dynamic> benefit) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(benefit['icon'] ?? '✓', style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              benefit['title'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Inclusions Button
  Widget _buildInclusionsButton() {
    return ButtonWidget(
      text: 'Click to Check Inclusions',
      isLoading: false.obs,
      elevation: 5,
      width: double.infinity,
      onTap: () {
        showModalBottomSheet(
          context: Get.context!,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => _buildInclusionsSheet(),
        );
      },
    );
  }

  // Action Buttons
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: ButtonWidget(
              text: 'Claim Your\nFree RSA',
              isLoading: false.obs,
              height: 50,
              elevation: 5,
              borderRadius: 5,
              fontSize: 13,
              backgroundColor: AppColors.blue,
              onTap: () {
                Get.to(() => ClaimRsaPage());
              },
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: ButtonWidget(
              text: 'Get Your\nWarranty Now',
              isLoading: false.obs,
              height: 50,
              elevation: 5,
              borderRadius: 5,
              fontSize: 13,
              backgroundColor: AppColors.blue,
              onTap: () {
                Get.to(() => GetWarrantyPage());
              },
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Sheet
  Widget _buildInclusionsSheet() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: MediaQuery.of(Get.context!).size.height * 0.7,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: _buildInclutionsContent(warrantyController),
    );
  }

  // Inclusions Content
  Widget _buildInclutionsContent(WarrantyController controller) {
    return Column(
      children: [
        // Drag Handle
        Container(
          margin: const EdgeInsets.only(top: 10),
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        // Header
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Warranty & RSA Inclusions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: Size(0, 0),
                onPressed: () {
                  Get.back();
                },
                child: const Icon(
                  CupertinoIcons.xmark_circle_fill,
                  color: Colors.grey,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Inclusions List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: controller.inclusions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final inclusion = controller.inclusions[index];
              return _buildInclusionItem(inclusion, index + 1);
            },
          ),
        ),

        // Close Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ButtonWidget(
            text: 'Close',
            isLoading: false.obs,
            width: double.infinity,
            elevation: 5,
            fontSize: 13,
            backgroundColor: AppColors.red,
            onTap: () {
              Get.back();
            },
          ),
        ),
      ],
    );
  }

  // Inclusion Item
  Widget _buildInclusionItem(Map<String, dynamic> inclusion, int number) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              inclusion['title'],
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

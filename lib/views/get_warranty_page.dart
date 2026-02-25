import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/Models/cars_list_model.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/controllers/get_warranty_controller.dart';
import 'package:otobix_customer_app/views/sell_my_car_page.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';

class GetWarrantyPage extends StatelessWidget {
  GetWarrantyPage({super.key, required this.car});

  final CarsListModel car;

  final GetWarrantyController getWarrantyController = Get.put(
    GetWarrantyController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Get Warranty'),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              // Vehicle selection card
              _buildCarImageAndID(
                appointmentId: car.appointmentId,
                imageUrl: car.imageUrl,
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
                isLoading: getWarrantyController.isGetWarrantyLoading,
                height: 35,
                width: 200,
                fontSize: 12,
                elevation: 5,
                onTap: () {
                  getWarrantyController.submitGetWarranty(car: car);
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
                backgroundColor: AppColors.blue,
                onTap: () => Get.to(
                  () => SellMyCarPage(inspectionRequestedThrough: "Warranty"),
                ),
              ),

              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  // Show car image and appointment id
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

  // Show warranty choices
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

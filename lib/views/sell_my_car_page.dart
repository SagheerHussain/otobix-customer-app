import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/controllers/sell_my_car_controller.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/utils/app_images.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';
import 'package:otobix_customer_app/widgets/dropdown_textfield_widget.dart';
import 'package:otobix_customer_app/widgets/images_scroll_widget.dart';

class SellMyCarPage extends StatelessWidget {
  SellMyCarPage({super.key});

  final SellMyCarController getxController = Get.put(SellMyCarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Sell My Car'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              ImagesScrollWidget(
                imageUrls: [AppImages.topBanner1, AppImages.carNotFound],
                width: 200,
                height: 100,
                onTaps: [() {}, () {}],
              ),
              const SizedBox(height: 20),

              // Car details form
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(color: AppColors.white),
                child: Form(
                  key: getxController.formKey,
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Car Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fill in your car details to get the best offer',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // 1. Car Number
                            _buildCustomTextField(
                              label: 'Car Registration Number',
                              icon: Icons.directions_car,
                              controller: getxController.carNumberController,
                              hintText: 'e.g. MH 12 AB 1234',
                              keyboardType: TextInputType.text,
                              isRequired: true,
                            ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: ButtonWidget(
                                text: 'Fetch Details',
                                height: 35,
                                isLoading:
                                    getxController.isFetchCarDetailsLoading,
                                onTap: () {
                                  getxController.fetchCarDetails();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 2. Name
                      _buildCustomTextField(
                        label: 'Owner Name',
                        icon: Icons.person,
                        controller: getxController.ownerNameController,
                        hintText: 'Enter your full name',
                        keyboardType: TextInputType.name,
                        isRequired: true,
                      ),

                      // 3. Model
                      DropdownTextfieldWidget<String>(
                        label: 'Car Make-Model-Variant',
                        controller: getxController.modelController,
                        hintText: 'Select Make Model Variant...',
                        icon: Icons.business,
                        isRequired: true,
                        allowCustomEntries: false,
                        customEntryValidationMessage:
                            'Please select a valid Car Make Model Variant from the list',
                        items: getxController.carModels.map((model) {
                          return DropdownMenuItem(
                            value: model,
                            child: Text(model),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == 'invalid') {
                            return 'This Car Model is not available';
                          }
                          return null;
                        },
                        controllerTag: 'car_model',
                      ),

                      // _buildCustomTextField(
                      //   label: 'Car Model',
                      //   icon: Icons.directions_car_filled,
                      //   controller: getxController.modelController,
                      //   hintText: 'e.g. Swift VXI',
                      //   keyboardType: TextInputType.text,
                      //   isRequired: true,
                      // ),

                      // // 4. Variant
                      // _buildCustomTextField(
                      //   label: 'Variant',
                      //   icon: Icons.tune,
                      //   controller: getxController.variantController,
                      //   hintText: 'e.g. Petrol, AMT',
                      //   keyboardType: TextInputType.text,
                      //   isRequired: true,
                      // ),

                      // 5. Year Of Registration
                      _buildCustomTextField(
                        label: 'Year Of Registration',
                        icon: Icons.calendar_today,
                        controller: getxController.yearOfMfgController,
                        hintText: 'e.g. 2019',
                        keyboardType: TextInputType.number,
                        isRequired: true,
                      ),

                      // 6. Ownership Serial No
                      DropdownTextfieldWidget<String>(
                        label: 'Ownership Serial Number',
                        controller: getxController.ownershipSerialNoController,
                        hintText: 'Select Ownership Serial No...',
                        icon: Icons.business,
                        isRequired: true,
                        allowCustomEntries: false,
                        customEntryValidationMessage:
                            'Please select a valid Ownership Serial No from the list',
                        items: getxController.ownershipSerialNos.map((
                          serialNo,
                        ) {
                          return DropdownMenuItem(
                            value: serialNo,
                            child: Text(serialNo),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == 'invalid') {
                            return 'This Ownership Serial No is not available';
                          }
                          return null;
                        },
                        controllerTag: 'ownership_serial',
                      ),
                      // _buildCustomTextField(
                      //   label: 'Ownership Serial Number',
                      //   icon: Icons.confirmation_number_outlined,
                      //   controller: getxController.ownershipSerialNoController,
                      //   hintText: 'e.g. 1st / 2nd owner',
                      //   keyboardType: TextInputType.text,
                      //   isRequired: true,
                      // ),

                      // // 7. Color
                      // _buildCustomTextField(
                      //   label: 'Car Color',
                      //   icon: Icons.color_lens_outlined,
                      //   controller: getxController.colorController,
                      //   hintText: 'e.g. White, Black, Red',
                      //   keyboardType: TextInputType.text,
                      //   isRequired: true,
                      // ),

                      // 8. Odometer Reading
                      _buildCustomTextField(
                        label: 'Odometer Reading (Km)',
                        icon: Icons.speed,
                        controller: getxController.odometerController,
                        hintText: 'e.g. 45,000',
                        keyboardType: TextInputType.number,
                      ),

                      // 9. Notes (multi-line)
                      _buildNotesField(),

                      const SizedBox(height: 16),

                      // Upload Images button
                      _buildImageUploadSection(),
                      const SizedBox(height: 20),

                      // Bottom two green buttons
                      Row(
                        children: [
                          Expanded(
                            child: ButtonWidget(
                              text: 'Request a Callback',
                              isLoading: false.obs,
                              fontSize: 11,
                              elevation: 5,
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ButtonWidget(
                              text: 'Schedule Inspection',
                              isLoading: false.obs,
                              fontSize: 11,
                              elevation: 5,
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ImagesScrollWidget(
                imageUrls: [AppImages.appLogo, AppImages.carNotFound],
                onTaps: [() {}, () {}],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // TextField
  Widget _buildCustomTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    required IconData icon,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
            children: isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: AppColors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey.withValues(alpha: 0.3)),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            decoration: InputDecoration(
              prefixIcon: Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(8),
                child: Icon(icon, color: AppColors.green, size: 20),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
              hintText: hintText,
              border: InputBorder.none,
              errorBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
            ),
            validator: (value) {
              if (isRequired && (value == null || value.trim().isEmpty)) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Notes field
  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Notes',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey.withValues(alpha: 0.3)),
          ),
          child: TextFormField(
            controller: getxController.notesController,
            maxLines: 4,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            decoration: InputDecoration(
              alignLabelWithHint: true,
              contentPadding: const EdgeInsets.all(16),
              hintText: 'Any additional details about your car (optional)',
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Image upload section
  Widget _buildImageUploadSection() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: 'Car Images',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
              children: [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: AppColors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                TextSpan(
                  text:
                      ' (${getxController.selectedImages.length}/${getxController.maxImageCount})',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload clear images of your car (max 5)',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),

          // Selected images grid
          if (getxController.selectedImages.isNotEmpty) ...[
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: getxController.selectedImages.length,
              itemBuilder: (context, index) {
                return _buildImageItem(index);
              },
            ),
            const SizedBox(height: 12),
          ],

          // Upload button
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color:
                  getxController.selectedImages.length >=
                      getxController.maxImageCount
                  ? AppColors.grey.withValues(alpha: 0.1)
                  : AppColors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    getxController.selectedImages.length >=
                        getxController.maxImageCount
                    ? AppColors.grey.withValues(alpha: 0.3)
                    : AppColors.green.withValues(alpha: 0.5),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap:
                    getxController.selectedImages.length >=
                        getxController.maxImageCount
                    ? null
                    : getxController.pickImages,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      color:
                          getxController.selectedImages.length >=
                              getxController.maxImageCount
                          ? AppColors.grey.withValues(alpha: 0.5)
                          : AppColors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      getxController.selectedImages.isEmpty
                          ? 'Upload Car Images'
                          : 'Add More Images (${getxController.remainingImageCount} remaining)',
                      style: TextStyle(
                        color:
                            getxController.selectedImages.length >=
                                getxController.maxImageCount
                            ? AppColors.grey.withValues(alpha: 0.5)
                            : AppColors.green,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Clear all button
          if (getxController.selectedImages.isNotEmpty) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: getxController.clearAllImages,
                child: Text(
                  'Clear All',
                  style: TextStyle(
                    color: AppColors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageItem(int index) {
    return Obx(() {
      if (index >= getxController.selectedImages.length) {
        return const SizedBox();
      }

      final imageFile = getxController.selectedImages[index];
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.grey.withValues(alpha: 0.3)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(imageFile.path),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.grey.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.error_outline,
                      color: AppColors.grey,
                      size: 24,
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                getxController.removeImage(index);
              },
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: AppColors.red.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: AppColors.white, size: 14),
              ),
            ),
          ),
        ],
      );
    });
  }
}

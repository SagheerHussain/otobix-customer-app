import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/controllers/sell_my_car_controller.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/utils/app_constants.dart';
import 'package:otobix_customer_app/views/buy_a_car_page.dart';
import 'package:otobix_customer_app/views/finance_page.dart';
import 'package:otobix_customer_app/views/insurance_page.dart';
import 'package:otobix_customer_app/views/warranty_page.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';
import 'package:otobix_customer_app/widgets/dropdown_textfield_widget.dart';
import 'package:otobix_customer_app/widgets/home_banners_widgets.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';

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
              // const SizedBox(height: 20),
              // TOP header banners (replace your first ImagesScrollWidget with this)
              Obx(() {
                final banners = getxController.headerBannersList;

                if (banners.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.width * 0.563,
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.green),
                    ),
                  );
                }

                final imageUrls = banners.map((b) => b.imageUrl).toList();

                return HomeBannersWidget(
                  imageUrls: imageUrls,
                  height:
                      MediaQuery.of(context).size.width *
                      0.563, // whatever height you like
                  displayDuration: const Duration(seconds: 4),
                  onTap: (index) {
                    final banner = banners[index];
                    debugPrint('Banner tapped: ${banner.screenName}');
                    // here you can navigate based on banner.screenName, etc.
                  },
                );
              }),

              // Obx(() {
              //   final banners = getxController.headerBannersList;

              //   // If list is empty => don't show banners at all
              //   if (banners.isEmpty) {
              //     return const SizedBox.shrink();
              //   }

              //   final imageUrls = banners.map((b) => b.imageUrl).toList();

              //   // Each tap prints (or shows) its screenName
              //   final onTaps = banners.map<VoidCallback>((b) {
              //     return () {
              //       debugPrint('Banner tapped: ${b.screenName}');
              //       // or show a toast/snackbar / navigate etc.
              //       // Get.snackbar('Banner', b.screenName);
              //     };
              //   }).toList();

              //   return ImagesScrollWidget(
              //     width: 200,
              //     height: 100,
              //     imageUrls: imageUrls,
              //     onTaps: onTaps,
              //   );
              // }),
              // const SizedBox(height: 20),

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
                              controller: getxController
                                  .carRegistrationNumberController,
                              hintText: 'e.g. MH12AB1234',
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

                      // 3. Make Model Variant Description
                      Obx(() => _buildMakeModelVariantDescription()),

                      // 4. Make
                      DropdownTextfieldWidget<String>(
                        label: 'Make',
                        controller: getxController.makeController,
                        hintText: 'Select make...',
                        icon: Icons.business,
                        isRequired: true,
                        allowCustomEntries: true,
                        customEntryValidationMessage:
                            'Please select a valid Car Make from the list',
                        // We won't use this items list reactively; internal controller will be updated manually
                        items: const [], // or null, both are fine
                        validator: (value) {
                          if (value == 'invalid') {
                            return 'This Car Make is not available';
                          }
                          return null;
                        },
                        controllerTag: 'car_make',
                      ),

                      // 5. Model
                      Obx(() {
                        final enabled = getxController.isModelEnabled.value;

                        return IgnorePointer(
                          ignoring: !enabled,
                          child: Opacity(
                            opacity: enabled ? 1 : 0.45,
                            child: DropdownTextfieldWidget<String>(
                              label: 'Model',
                              controller: getxController.modelController,
                              hintText: enabled
                                  ? 'Select model...'
                                  : 'Select make first',
                              icon: Icons.business,
                              isRequired: enabled, // ✅ IMPORTANT
                              allowCustomEntries: true,
                              customEntryValidationMessage:
                                  'Please select a valid Car Model from the list',
                              items: const [],
                              validator: (value) {
                                if (!enabled)
                                  return null; // ✅ don’t block form when disabled
                                if (value == 'invalid')
                                  return 'This Car Model is not available';
                                return null;
                              },
                              controllerTag: 'car_model',
                            ),
                          ),
                        );
                      }),

                      // 6. Variant
                      Obx(() {
                        final enabled = getxController.isVariantEnabled.value;

                        return IgnorePointer(
                          ignoring: !enabled,
                          child: Opacity(
                            opacity: enabled ? 1 : 0.45,
                            child: DropdownTextfieldWidget<String>(
                              label: 'Variant',
                              controller: getxController.variantController,
                              hintText: enabled
                                  ? 'Select variant...'
                                  : 'Select make & model first',
                              icon: Icons.business,
                              isRequired: enabled, // ✅ IMPORTANT
                              allowCustomEntries: true,
                              customEntryValidationMessage:
                                  'Please select a valid Car Variant from the list',
                              items: const [],
                              validator: (value) {
                                if (!enabled)
                                  return null; // ✅ don’t block form when disabled
                                if (value == 'invalid')
                                  return 'This Car Variant is not available';
                                return null;
                              },
                              controllerTag: 'car_variant',
                            ),
                          ),
                        );
                      }),

                      // 7. Year Of Registration
                      _buildCustomTextField(
                        label: 'Year Of Registration',
                        icon: Icons.calendar_today,
                        controller: getxController.yearOfRegController,
                        hintText: 'e.g. 2019',
                        keyboardType: TextInputType.number,
                        isRequired: true,
                      ),

                      // 8. Ownership Serial No
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

                      // 9. Odometer Reading
                      _buildCustomTextField(
                        label: 'Odometer Reading (Km)',
                        icon: Icons.speed,
                        controller:
                            getxController.odometerReadingInKmsController,
                        hintText: 'e.g. 45,000',
                        keyboardType: TextInputType.number,
                      ),

                      // 10. Notes (multi-line)
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
                              isLoading:
                                  getxController.isRequestCallbackLoading,
                              fontSize: 11,
                              elevation: 5,

                              onTap: () async {
                                // validate main form if you want to require car details
                                if (!(getxController.formKey.currentState
                                        ?.validate() ??
                                    false)) {
                                  ToastWidget.show(
                                    context: Get.context!,
                                    title: 'Error',
                                    subtitle:
                                        'Please fill all required car details',
                                    type: ToastType.error,
                                  );
                                  return;
                                }

                                // optional: clear inspection date/address so it's just a callback
                                getxController.inspectionDateTimeUtcForApi =
                                    null;
                                getxController.inspectionDateTimeController
                                    .clear();
                                getxController.inspectionAddressController
                                    .clear();

                                final ok = await getxController
                                    .submitInspectionRequest(isSchedule: false);
                                if (ok) {
                                  SellMyCarPage.showCallbackConfirmationDialog(
                                    isClickedCallback: true,
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ButtonWidget(
                              text: 'Schedule Inspection',
                              isLoading: false.obs,
                              fontSize: 11,
                              elevation: 5,
                              onTap: () {
                                showScheduleInspectionDialog();
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              // const SizedBox(height: 20),
              // // TOP footer banners (replace your first ImagesScrollWidget with this)
              // Obx(() {
              //   final banners = getxController.footerBannersList;

              //   // If list is empty => don't show banners at all
              //   if (banners.isEmpty) {
              //     return const SizedBox.shrink();
              //   }

              //   final imageUrls = banners
              //       .map((banner) => banner.imageUrl)
              //       .toList();

              //   // Each tap prints (or shows) its screenName
              //   final onTaps = banners.map<VoidCallback>((banner) {
              //     return () {
              //       debugPrint('Banner tapped: ${banner.screenName}');
              //       // or show a toast/snackbar / navigate etc.
              //       // Get.snackbar('Banner', b.screenName);
              //       _navigateToScreenOnBannerTap(banner.screenName);
              //     };
              //   }).toList();

              //   return ImagesScrollWidget(
              //     width: 200,
              //     height: 100,
              //     imageUrls: imageUrls,
              //     onTaps: onTaps,
              //   );
              // }),
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
            controller: getxController.additionalNotesController,
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
              text: 'Car Images ',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
              children: [
                // TextSpan(
                //   text: ' *',
                //   style: TextStyle(
                //     color: AppColors.red,
                //     fontWeight: FontWeight.bold,
                //     fontSize: 14,
                //   ),
                // ),
                TextSpan(
                  text:
                      '(${getxController.selectedImages.length}/${getxController.maxImageCount}) ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
                // TextSpan(
                //   text: '(Optional)',
                //   style: TextStyle(color: AppColors.grey, fontSize: 14),
                // ),
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

  // Show Request Callback Confirmation Dialog
  static showCallbackConfirmationDialog({required bool isClickedCallback}) {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: Row(
          children: [
            Icon(Icons.phone_callback, color: AppColors.green),
            const SizedBox(width: 10),
            Text(
              'Thank You!',
              style: TextStyle(
                color: AppColors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          isClickedCallback
              ? 'Thank you for your interest, our team will contact you shortly.'
              : 'Inspection request received, Inspection will be scheduled soon.',
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
        actions: [
          ButtonWidget(
            text: 'Close',
            isLoading: false.obs,
            fontSize: 11,
            height: 35,
            width: 100,
            elevation: 5,
            onTap: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  // Show Schedule Inspection Dialog
  void showScheduleInspectionDialog() {
    // Clear previous values
    getxController.inspectionDateTimeController.clear();
    getxController.inspectionAddressController.clear();

    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: Row(
          children: [
            Icon(Icons.calendar_today, color: AppColors.green, size: 25),
            const SizedBox(width: 10),
            Text(
              'Schedule Inspection',
              style: TextStyle(
                color: AppColors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // DateTime Field
            TextFormField(
              controller: getxController.inspectionDateTimeController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Inspection Date & Time',
                hintText: 'Select date and time',
                prefixIcon: Icon(
                  Icons.calendar_today,
                  color: AppColors.green,
                  size: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                labelStyle: TextStyle(fontSize: 14),
                hintStyle: TextStyle(fontSize: 14),
              ),
              style: TextStyle(fontSize: 14),
              onTap: () async {
                // First pick date
                final DateTime? pickedDate = await showDatePicker(
                  context: Get.context!,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now().add(const Duration(days: 1)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );

                if (pickedDate != null) {
                  // Then pick time
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: Get.context!,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedTime != null) {
                    // Combine date and time
                    final DateTime finalDateTime = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );

                    // Convert to UTC for API
                    final utcDateTime = finalDateTime.toUtc();

                    // store ISO for API
                    getxController.inspectionDateTimeUtcForApi = utcDateTime
                        .toIso8601String();

                    // show formatted local time to user
                    final String displayText =
                        "${finalDateTime.day.toString().padLeft(2, '0')}/${finalDateTime.month.toString().padLeft(2, '0')}/${finalDateTime.year} at ${pickedTime.format(Get.context!)}";

                    getxController.inspectionDateTimeController.text =
                        displayText;

                    // If you need to keep UTC for API, store it separately
                    // getxController.utcDateTimeForApi = utcDateTime;
                  }
                }
              },
            ),
            const SizedBox(height: 15),

            // Address Field
            TextFormField(
              controller: getxController.inspectionAddressController,
              maxLines: 3,
              textAlignVertical:
                  TextAlignVertical.top, // This makes text start from top

              decoration: InputDecoration(
                labelText: 'Address',
                hintText: 'Enter inspection address',

                prefixIcon: Icon(
                  Icons.location_on,
                  color: AppColors.green,
                  size: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                labelStyle: TextStyle(fontSize: 14),
                hintStyle: TextStyle(fontSize: 14),
                alignLabelWithHint: true, // This helps with multi-line fields
                contentPadding: EdgeInsets.fromLTRB(
                  12,
                  16,
                  12,
                  12,
                ), // Adjust padding for top alignment
              ),
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 15),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ButtonWidget(
                    text: 'Cancel',
                    isLoading: false.obs,
                    fontSize: 12,
                    height: 35,
                    elevation: 5,
                    backgroundColor: AppColors.red,
                    onTap: () {
                      Get.back();
                    },
                  ),
                ),
                Expanded(
                  child: ButtonWidget(
                    text: 'Submit',
                    isLoading: getxController.isScheduleInspectionLoading,
                    fontSize: 12,
                    height: 35,
                    elevation: 5,
                    onTap: () async {
                      if (getxController.inspectionDateTimeUtcForApi == null ||
                          getxController.inspectionDateTimeUtcForApi!.isEmpty ||
                          getxController.inspectionAddressController.text
                              .trim()
                              .isEmpty) {
                        ToastWidget.show(
                          context: Get.context!,
                          title: 'Error',
                          subtitle:
                              'Please select inspection date & time and enter address',
                          type: ToastType.error,
                        );
                        return;
                      }

                      // validate main form if you want to require car details
                      if (!(getxController.formKey.currentState?.validate() ??
                          false)) {
                        ToastWidget.show(
                          context: Get.context!,
                          title: 'Error',
                          subtitle: 'Please fill all required car details',
                          type: ToastType.error,
                        );
                        return;
                      }

                      final ok = await getxController.submitInspectionRequest(
                        isSchedule: true,
                      );
                      if (ok) {
                        Get.back(); // close schedule dialog
                        SellMyCarPage.showCallbackConfirmationDialog(
                          isClickedCallback: false,
                        );
                      }
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

  // Show make model variant description if fetched
  Widget _buildMakeModelVariantDescription() {
    final makerDesc = getxController.fetchedMakerDescStringToShow.value;
    final makerModel = getxController.fetchedMakerModelStringToShow.value;
    return Column(
      children: [
        if (makerDesc.isNotEmpty)
          _buildFetchedData(title: 'Maker Description', value: makerDesc),
        if (makerModel.isNotEmpty)
          _buildFetchedData(title: 'Maker Model', value: makerModel),
        if (makerDesc.isNotEmpty || makerModel.isNotEmpty)
          const SizedBox(height: 15),
      ],
    );
  }

  // Show fetched data
  Widget _buildFetchedData({required String title, required String value}) {
    return Row(
      spacing: 10,
      children: [
        Text(
          '$title:',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),

        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: AppColors.green),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Navigate to screen on banner tap
  void _navigateToScreenOnBannerTap(String? screenName) {
    final name = (screenName ?? '').trim().toLowerCase();

    final routes = <String, Widget Function()>{
      AppConstants.bannerScreenNames.buyACar.toLowerCase(): () => BuyACarPage(),
      AppConstants.bannerScreenNames.sellYourCar.toLowerCase(): () =>
          SellMyCarPage(),
      AppConstants.bannerScreenNames.warranty.toLowerCase(): () =>
          WarrantyPage(),
      AppConstants.bannerScreenNames.finance.toLowerCase(): () => FinancePage(),
      AppConstants.bannerScreenNames.insurance.toLowerCase(): () =>
          InsurancePage(),
    };

    final builder = routes[name];

    if (builder != null) {
      Get.to(builder);
      return;
    }

    // Default fallback
    // Get.to(
    //   () => UnderDevelopmentPage(
    //     screenName: screenName ?? 'Coming Soon',
    //     icon: CupertinoIcons.square_grid_2x2,
    //     color: AppColors.grey,
    //   ),
    // );
  }
}

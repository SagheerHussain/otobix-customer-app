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
                imageUrls: [AppImages.appLogo, AppImages.carNotFound],
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
                              label: 'Car Number',
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
                        label: 'Car Model',
                        controller: getxController.modelController,
                        hintText: 'Select Car Model',
                        icon: Icons.business,
                        isRequired: true,
                        allowCustomEntries: false,
                        customEntryValidationMessage:
                            'Please select a valid Car Model from the list',
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
                      ),
                      // _buildCustomTextField(
                      //   label: 'Car Model',
                      //   icon: Icons.directions_car_filled,
                      //   controller: getxController.modelController,
                      //   hintText: 'e.g. Swift VXI',
                      //   keyboardType: TextInputType.text,
                      //   isRequired: true,
                      // ),

                      // 4. Variant
                      _buildCustomTextField(
                        label: 'Variant',
                        icon: Icons.tune,
                        controller: getxController.variantController,
                        hintText: 'e.g. Petrol, AMT',
                        keyboardType: TextInputType.text,
                        isRequired: true,
                      ),

                      // 5. Year Of Mfg
                      _buildCustomTextField(
                        label: 'Year Of Manufacturing',
                        icon: Icons.calendar_today,
                        controller: getxController.yearOfMfgController,
                        hintText: 'e.g. 2019',
                        keyboardType: TextInputType.number,
                        isRequired: true,
                      ),

                      // 6. Ownership Serial No
                      _buildCustomTextField(
                        label: 'Ownership Serial Number',
                        icon: Icons.confirmation_number_outlined,
                        controller: getxController.ownershipSerialNoController,
                        hintText: 'e.g. 1st / 2nd owner',
                        keyboardType: TextInputType.text,
                        isRequired: true,
                      ),

                      // 7. Color
                      _buildCustomTextField(
                        label: 'Car Color',
                        icon: Icons.color_lens_outlined,
                        controller: getxController.colorController,
                        hintText: 'e.g. White, Black, Red',
                        keyboardType: TextInputType.text,
                        isRequired: true,
                      ),

                      // 8. Odometer Reading
                      _buildCustomTextField(
                        label: 'Odometer Reading (Km)',
                        icon: Icons.speed,
                        controller: getxController.odometerController,
                        hintText: 'e.g. 45,000',
                        keyboardType: TextInputType.number,
                        isRequired: true,
                      ),

                      // 9. Notes (multi-line)
                      _buildNotesField(),

                      const SizedBox(height: 16),

                      // Upload Images button
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.grey.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              //  open image picker
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  color: AppColors.grey.withValues(alpha: 0.7),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Upload Car Images',
                                  style: TextStyle(
                                    color: AppColors.grey.withValues(
                                      alpha: 0.8,
                                    ),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

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
}



              /// TOP – “Why Us?”
              // Container(
              //   width: double.infinity,
              //   margin: const EdgeInsets.symmetric(horizontal: 15),

              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Expanded(
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             const Text(
              //               'Why Choose Us?',
              //               style: TextStyle(
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.black87,
              //               ),
              //             ),

              //             // Benefits in a beautiful list
              //             _buildBenefitItem(
              //               Icons.attach_money,
              //               'Best Price Guaranteed',
              //             ),
              //             _buildBenefitItem(
              //               Icons.local_offer,
              //               'Transparent Deals',
              //             ),
              //             _buildBenefitItem(Icons.bolt, 'Instant Payments'),
              //             _buildBenefitItem(Icons.visibility, 'Secure Process'),
              //           ],
              //         ),
              //       ),

              //       // Info Icon
              //       Container(
              //         width: 40,
              //         height: 40,
              //         decoration: BoxDecoration(
              //           color: AppColors.green,
              //           shape: BoxShape.circle,
              //           boxShadow: [
              //             BoxShadow(
              //               color: AppColors.green.withOpacity(0.3),
              //               blurRadius: 8,
              //               offset: const Offset(0, 4),
              //             ),
              //           ],
              //         ),
              //         child: const Icon(
              //           Icons.info_outline_rounded,
              //           size: 22,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

  // // Helper method for benefit items
  // Widget _buildBenefitItem(IconData icon, String text) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 2),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: 32,
  //           height: 32,
  //           decoration: BoxDecoration(
  //             color: AppColors.green.withOpacity(0.1),
  //             shape: BoxShape.circle,
  //           ),
  //           child: Icon(icon, size: 18, color: AppColors.green),
  //         ),
  //         const SizedBox(width: 12),
  //         Expanded(
  //           child: Text(
  //             text,
  //             style: const TextStyle(
  //               fontSize: 14,
  //               fontWeight: FontWeight.w500,
  //               color: Colors.black87,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
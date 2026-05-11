import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/controllers/guest_user_register_choice_dialog_controller.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';

class GuestUserRegisterChoiceDialogWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String registerUserButtonText;
  final String guestUserButtonText;
  final IconData icon;
  final VoidCallback? onRegisterSuccess;
  final Function(String phoneNumber)? onTappedBrowseAsGuestButton;
  final bool showBrowseAsGuestButton;

  const GuestUserRegisterChoiceDialogWidget({
    super.key,
    this.title = "Phone Number Required",
    this.subtitle = "Please enter your phone number to use this feature",
    this.registerUserButtonText = "Register & Continue",
    this.guestUserButtonText = "Browse as Guest",
    this.icon = Icons.phone_android_rounded,
    this.onRegisterSuccess,
    this.onTappedBrowseAsGuestButton,
    this.showBrowseAsGuestButton = true,
  });

  static Future<void> show({
    required BuildContext context,
    String title = "Phone Number Required",
    String subtitle = "Please enter your phone number to use this feature",
    String registerUserButtonText = "Register & Continue",
    String guestUserButtonText = "Browse as Guest",
    IconData icon = Icons.phone_android_rounded,
    VoidCallback? onRegisterSuccess,
    Function(String phoneNumber)? onTappedBrowseAsGuestButton,
    bool showBrowseAsGuestButton = true,
    bool barrierDismissible = true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => GuestUserRegisterChoiceDialogWidget(
        title: title,
        subtitle: subtitle,
        registerUserButtonText: registerUserButtonText,
        guestUserButtonText: guestUserButtonText,
        icon: icon,
        onRegisterSuccess: onRegisterSuccess,
        onTappedBrowseAsGuestButton: onTappedBrowseAsGuestButton,
        showBrowseAsGuestButton: showBrowseAsGuestButton,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final GuestUserRegisterChoiceDialogController getxController = Get.put(
      GuestUserRegisterChoiceDialogController(),
    );
    getxController.phoneNumberController
        .clear(); // Clear textfield on opening dialog

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top icon bubble
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withValues(alpha: .12),
              ),
              child: Icon(icon, size: 28, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 14),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.grey,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 18),

            // Phone Input Field
            _buildPhoneTextField(getxController, theme),

            const SizedBox(height: 18),

            // Actions
            Column(
              children: [
                // Register Button
                ButtonWidget(
                  text: registerUserButtonText,
                  isLoading: getxController.isSendOtpLoading,
                  backgroundColor: AppColors.green,
                  height: 38,
                  width: 200,
                  fontSize: 13,
                  onTap: () async {
                    // Validate phone number
                    final isValid = await getxController.validatePhoneNumber();

                    if (isValid) {
                      // Send OTP
                      await getxController.sendOTP();
                    }
                  },
                ),

                if (showBrowseAsGuestButton) ...[
                  const SizedBox(height: 12),
                  ButtonWidget(
                    text: guestUserButtonText,
                    isLoading: false.obs,
                    textColor: AppColors.black,
                    backgroundColor: AppColors.grey.withValues(alpha: 0.5),
                    height: 38,
                    width: 200,
                    fontSize: 13,
                    onTap: () async {
                      // Validate phone number before skipping
                      final isValid = await getxController
                          .validatePhoneNumber();

                      final phoneNumber = getxController
                          .phoneNumberController
                          .text
                          .trim();

                      if (isValid) {
                        // First, get the phone number
                        final phoneToPass = phoneNumber;

                        // Then close the dialog
                        Get.back();

                        // Delete the controller
                        Get.delete<GuestUserRegisterChoiceDialogController>();

                        // Finally call the callback with the phone number
                        if (onTappedBrowseAsGuestButton != null) {
                          onTappedBrowseAsGuestButton!(phoneToPass);
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneTextField(
    GuestUserRegisterChoiceDialogController controller,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller.phoneNumberController,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          decoration: InputDecoration(
            counterText: "",
            hintText: "9876543210",
            hintStyle: TextStyle(color: AppColors.grey.withValues(alpha: .5)),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            prefixIcon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '+91',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(width: 1, height: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.green, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 10,
            ),
          ),
        ),
      ],
    );
  }
}

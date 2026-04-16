import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/controllers/login_pin_code_controller.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/utils/app_images.dart';

class LoginPinCodePage extends StatelessWidget {
  final String requestId;
  final String phoneNumber;
  final bool? whatsappConsent;

  LoginPinCodePage({
    super.key,
    required this.requestId,
    required this.phoneNumber,
    this.whatsappConsent,
  });

  final LoginPinCodeController pinCodeFieldsController = Get.put(
    LoginPinCodeController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: 'Verify Phone', showBackButton: false),
      body: Obx(() {
        final isLoading = pinCodeFieldsController.isLoading.value;
        return isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.green),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      _buildAppLogo(),
                      SizedBox(height: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildOtpMessageText(),
                          SizedBox(height: 30),
                          _buildPinCodeTextField(context),
                          SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }

  // App Logo
  Widget _buildAppLogo() =>
      Image.asset(AppImages.appLogo, height: 150, width: 150);

  Widget _buildOtpMessageText() => Column(
    children: [
      Text(
        "Enter the OTP sent to",
        style: TextStyle(fontSize: 16, color: AppColors.black),
      ),

      SizedBox(height: 8),
      Text(
        '(+91) - $phoneNumber',
        style: TextStyle(
          fontSize: 18,
          color: AppColors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );

  Widget _buildPinCodeTextField(BuildContext parentContext) => Column(
    children: [
      // 🔹 The actual OTP input field
      PinCodeTextField(
        appContext: parentContext,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6),
        ],
        keyboardType: TextInputType.number,
        length: 6,
        obscureText: false,
        animationType: AnimationType.fade,
        cursorColor: AppColors.green,
        textStyle: TextStyle(fontSize: 20, color: Colors.black),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(8),
          fieldHeight: 50,
          fieldWidth: 40,
          activeFillColor: AppColors.green.withValues(alpha: 0.2),
          inactiveFillColor: AppColors.white,
          selectedFillColor: AppColors.green.withValues(alpha: 0.1),
          activeColor: AppColors.green,
          inactiveColor: AppColors.grey,
          selectedColor: AppColors.green,
        ),
        animationDuration: Duration(milliseconds: 300),
        enableActiveFill: true,
        onCompleted: (value) {
          pinCodeFieldsController.verifyOtp(
            requestId: requestId,
            otp: value,
            phoneNumber: phoneNumber,
            whatsappConsent: whatsappConsent,
          );
        },
        onChanged: (value) {},
      ),
    ],
  );
}

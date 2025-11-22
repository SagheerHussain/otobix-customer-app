import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/services/api_service.dart';
import 'package:otobix_customer_app/services/shared_prefs_helper.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';

class SellMyCarController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();

  // Text controllers (fields on the screen)
  late TextEditingController carNumberController;
  late TextEditingController ownerNameController;
  late TextEditingController modelController;
  late TextEditingController variantController;
  late TextEditingController yearOfMfgController;
  late TextEditingController ownershipSerialNoController;
  late TextEditingController colorController;
  late TextEditingController odometerController;
  late TextEditingController notesController;

  // Button loading states (use in ButtonWidget if you want)
  final isFetchCarDetailsLoading = false.obs;
  final isUploadImagesLoading = false.obs;
  final isRequestCallbackLoading = false.obs;
  final isScheduleInspectionLoading = false.obs;

  List<String> carModels = [
    'Toyota Camry',
    'Honda Civic',
    'Ford Mustang',
    'BMW X5',
    'Mercedes-Benz C-Class',
    'Audi A4',
    'Hyundai Elantra',
    'Tesla Model 3',
    'Nissan Altima',
    'Chevrolet Malibu',
    'Volkswagen Golf',
    'Subaru Outback',
    'Mazda CX-5',
    'Kia Sportage',
    'Lexus RX',
  ];

  @override
  void onInit() {
    super.onInit();
    carNumberController = TextEditingController();
    ownerNameController = TextEditingController();
    modelController = TextEditingController();
    variantController = TextEditingController();
    yearOfMfgController = TextEditingController();
    ownershipSerialNoController = TextEditingController();
    colorController = TextEditingController();
    odometerController = TextEditingController();
    notesController = TextEditingController();
  }

  // Fetch car details
  Future<void> fetchCarDetails() async {
    // Basic validation: car number required
    if (carNumberController.text.trim().isEmpty) {
      ToastWidget.show(
        context: Get.context!,
        title: "Car number required",
        subtitle: "Please enter a car registration number.",
        type: ToastType.error,
      );
      return;
    }

    isFetchCarDetailsLoading.value = true;

    final userId =
        await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ?? '';

    try {
      final response = await ApiService.post(
        endpoint: AppUrls.fetchVehicleRegistrationDetails,
        body: {
          'vehicleRegistrationNumber': carNumberController.text.trim(),
          'userId': userId,
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        final bool success = body['success'] == true;
        final String message = body['message']?.toString() ?? '';
        final data = body['data'] ?? {};
        final result = data['result'] ?? {};
        final String internalStatusCode =
            data['internalStatusCode']?.toString() ?? '';

        if (!success) {
          ToastWidget.show(
            context: Get.context!,
            title: "Failed",
            subtitle: message.isNotEmpty ? message : "Unable to fetch details.",
            type: ToastType.error,
          );
          return;
        }

        if (internalStatusCode == "101") {
          // ✅ Map API result → your form fields
          final String regNo = result['rc_regn_no']?.toString() ?? '';
          final String ownerName = result['rc_owner_name']?.toString() ?? '';
          final String makerModel = result['rc_maker_model']?.toString() ?? '';
          final String manuMonthYear =
              result['rc_manu_month_yr']?.toString() ?? ''; // e.g. "12-2006"
          final String ownerSr = result['rc_owner_sr']?.toString() ?? '';
          final String color = result['rc_color']?.toString() ?? '';

          // Optionally extract year from "mm-yyyy"
          String yearOnly = '';
          if (manuMonthYear.isNotEmpty && manuMonthYear.contains('-')) {
            final parts = manuMonthYear.split('-');
            if (parts.length == 2) {
              yearOnly = parts[1]; // "2006"
            }
          }

          // Fill controllers
          carNumberController.text = regNo.isNotEmpty
              ? regNo
              : carNumberController.text.trim();
          ownerNameController.text = ownerName;
          modelController.text = makerModel;
          yearOfMfgController.text = yearOnly;
          ownershipSerialNoController.text = ownerSr;
          colorController.text = color;

          // If you later add odometer & notes from API, set them here too.

          // For dropdown: ensure model appears in list
          if (makerModel.isNotEmpty && !carModels.contains(makerModel)) {
            carModels.insert(0, makerModel);
          }

          // ToastWidget.show(
          //   context: Get.context!,
          //   title: "Success",
          //   subtitle: "Car details fetched.",
          //   type: ToastType.success,
          // );
        } else if (internalStatusCode == "102") {
          // ❌ Invalid details (based on your backend contract)
          ToastWidget.show(
            context: Get.context!,
            title: "Invalid details",
            subtitle: "Invalid registration number or no data found.",
            type: ToastType.error,
          );
        } else {
          // ❌ Unknown / unhandled status code
          ToastWidget.show(
            context: Get.context!,
            title: "Failed to fetch car details",
            subtitle: "Unexpected response code: $internalStatusCode",
            type: ToastType.error,
          );
        }
      } else {
        debugPrint(
          "Failed to fetch car details: status code ${response.statusCode}",
        );
        ToastWidget.show(
          context: Get.context!,
          title: "Failed to fetch car details",
          subtitle: "Server error: ${response.statusCode}",
          type: ToastType.error,
        );
      }
    } catch (error) {
      debugPrint(error.toString());
      ToastWidget.show(
        context: Get.context!,
        title: 'Error fetching car details',
        subtitle: error.toString(),
        type: ToastType.error,
      );
    } finally {
      isFetchCarDetailsLoading.value = false;
    }
  }

  @override
  void onClose() {
    carNumberController.dispose();
    ownerNameController.dispose();
    modelController.dispose();
    variantController.dispose();
    yearOfMfgController.dispose();
    ownershipSerialNoController.dispose();
    colorController.dispose();
    odometerController.dispose();
    notesController.dispose();
    super.onClose();
  }

  void uploadImages() async {
    // isUploadImagesLoading.value = true;
    // pick images & upload
    // isUploadImagesLoading.value = false;
  }

  void requestCallback() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    // isRequestCallbackLoading.value = true;
    // call API
    // isRequestCallbackLoading.value = false;
  }

  void scheduleInspection() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    // isScheduleInspectionLoading.value = true;
    // call API
    // isScheduleInspectionLoading.value = false;
  }
}

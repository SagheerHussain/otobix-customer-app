import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  final isUploadImagesLoading = false.obs;
  final isRequestCallbackLoading = false.obs;
  final isScheduleInspectionLoading = false.obs;

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

  // TODO: hook your APIs here

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

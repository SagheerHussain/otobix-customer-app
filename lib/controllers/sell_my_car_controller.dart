import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otobix_customer_app/Models/sell_my_car_banners_model.dart';
import 'package:otobix_customer_app/controllers/dropdown_textfield_widget_controller.dart';
import 'package:otobix_customer_app/services/api_service.dart';
import 'package:otobix_customer_app/services/shared_prefs_helper.dart';
import 'package:otobix_customer_app/utils/app_constants.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';
import 'package:otobix_customer_app/views/sell_my_car_page.dart';
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
  final TextEditingController inspectionDateTimeController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Button loading states (use in ButtonWidget if you want)
  final isBannersLoading = false.obs;
  final isFetchCarDetailsLoading = false.obs;
  final isUploadImagesLoading = false.obs;
  final isRequestCallbackLoading = false.obs;
  final isScheduleInspectionLoading = false.obs;

  // Banners
  final headerBannersList = <SellMyCarBannersModel>[].obs;
  final footerBannersList = <SellMyCarBannersModel>[].obs;

  // Car models list (for dropdown suggestions)
  final RxList<String> carModels = <String>[].obs;
  Timer? _modelSearchDebounce;

  List<String> ownershipSerialNos = [
    '1st',
    '2nd',
    '3rd',
    '4th',
    '5th',
    'above',
  ];

  // Image related properties
  final selectedImages = <XFile>[].obs;
  final maxImageCount = 5;

  // Image picker
  final ImagePicker _imagePicker = ImagePicker();

  String? inspectionDateTimeUtcForApi;

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

    _fetchBannersList();

    _setupModelSearchListener();

    // Optional: load initial popular list (no search term)
    _fetchCarModelSuggestions('');
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
              result['rc_regn_dt']?.toString() ?? ''; // e.g. "12-2006"
          // final String ownerSr = result['rc_owner_sr']?.toString() ?? '';
          // final String color = result['rc_color']?.toString() ?? '';

          // Optionally extract year from formats like "12-2006" or "15-04-2015"
          String yearOnly = '';
          if (manuMonthYear.isNotEmpty) {
            final match = RegExp(r'(\d{4})$').firstMatch(manuMonthYear.trim());
            if (match != null) {
              yearOnly = match.group(1)!; // e.g. "2015"
            }
          }

          // Fill controllers
          carNumberController.text = regNo.isNotEmpty
              ? regNo
              : carNumberController.text.trim();
          ownerNameController.text = ownerName;
          modelController.text = makerModel;
          yearOfMfgController.text = yearOnly;
          // ownershipSerialNoController.text = ownerSr;
          // colorController.text = color;

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

  // Pick images from gallery
  Future<void> pickImages() async {
    try {
      final List<XFile>? pickedFiles = await _imagePicker.pickMultiImage(
        imageQuality: 80,
      );

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        final int remainingSlots = maxImageCount - selectedImages.length;
        final List<XFile> filesToAdd = pickedFiles
            .take(remainingSlots)
            .toList();

        if (filesToAdd.isNotEmpty) {
          selectedImages.addAll(filesToAdd);
        }

        // Show warning if user selected more than available slots
        if (pickedFiles.length > remainingSlots) {
          ToastWidget.show(
            context: Get.context!,
            title: "Limit Exceeded",
            subtitle:
                "Only $remainingSlots images were added. Maximum $maxImageCount images allowed.",
            type: ToastType.warning,
          );
        }
      }
    } catch (e) {
      ToastWidget.show(
        context: Get.context!,
        title: "Error",
        subtitle: "Failed to pick images: ${e.toString()}",
        type: ToastType.error,
      );
    }
  }

  // Remove image
  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  // Clear all images
  void clearAllImages() {
    selectedImages.clear();
  }

  // Get remaining image count
  int get remainingImageCount => maxImageCount - selectedImages.length;

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

  void _setupModelSearchListener() {
    modelController.addListener(() {
      final text = modelController.text.trim();

      // Cancel previous debounce
      _modelSearchDebounce?.cancel();

      // If field is empty → fetch first 20 from API
      if (text.isEmpty) {
        _fetchCarModelSuggestions('');
        return;
      }

      // Debounce – so we don't hit the API on every keystroke
      _modelSearchDebounce = Timer(const Duration(milliseconds: 400), () {
        _fetchCarModelSuggestions(text);
      });
    });
  }

  Future<void> _fetchCarModelSuggestions(String query) async {
    try {
      final response = await ApiService.post(
        endpoint: AppUrls.searchCarMakeModelVariant,
        body: {
          'q': query, // no manual encoding here
          'limit': 20,
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final bool success = body['success'] == true;
        if (!success) {
          debugPrint('Search car models failed: ${body['message']}');
          return;
        }

        final List<dynamic> data = body['data'] ?? [];
        final List<String> models = data.map((e) => e.toString()).toList();

        // Keep your list if you need it elsewhere
        carModels.assignAll(models);

        // 🔥 Update the dropdown's internal controller, if it exists
        if (Get.isRegistered<DropdownController<String>>(tag: 'car_model')) {
          final dropdownCtrl = Get.find<DropdownController<String>>(
            tag: 'car_model',
          );

          final dropdownItems = models
              .map((m) => DropdownMenuItem<String>(value: m, child: Text(m)))
              .toList();

          dropdownCtrl.updateItems(dropdownItems);
        }
      } else {
        debugPrint('Search car models failed: status ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Search car models error: $e');
    }
  }

  // Load Banners list
  Future<void> _fetchBannersList() async {
    isBannersLoading.value = true;
    try {
      final response = await ApiService.post(
        endpoint: AppUrls.fetchCarBannersList,
        body: {'view': AppConstants.bannerViews.sellMyCar},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final List<dynamic> dataList = decoded['data'] as List<dynamic>;

        // If the backend sends { type: 'Header' | 'Footer' }
        final headerBannerMaps = dataList
            .where(
              (banner) => banner['type'] == AppConstants.bannerTypes.header,
            )
            .cast<Map<String, dynamic>>()
            .toList();

        final footerBannerMaps = dataList
            .where(
              (banner) => banner['type'] == AppConstants.bannerTypes.footer,
            )
            .cast<Map<String, dynamic>>()
            .toList();

        // Map to your model and assign to RxLists
        headerBannersList.assignAll(
          headerBannerMaps
              .map(
                (banner) => SellMyCarBannersModel.fromJson(
                  documentId: banner['_id'],
                  json: banner,
                ),
              )
              .toList(),
        );

        footerBannersList.assignAll(
          footerBannerMaps
              .map(
                (banner) => SellMyCarBannersModel.fromJson(
                  documentId: banner['_id'],
                  json: banner,
                ),
              )
              .toList(),
        );
      } else {
        debugPrint('Failed to load banners: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error loading banners: $error');
    } finally {
      isBannersLoading.value = false;
    }
  }

  // Submit inspection request
  Future<bool> submitInspectionRequest() async {
    if (!(formKey.currentState?.validate() ?? false)) return false;
    isScheduleInspectionLoading.value = true;

    try {
      final uri = Uri.parse(AppUrls.addInspetionRequest);
      final request = http.MultipartRequest('POST', uri);

      final token =
          await SharedPrefsHelper.getString(SharedPrefsHelper.tokenKey) ?? '';

      if (token.isNotEmpty) {
        request.headers.addAll({
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        });
      }

      // required fields
      request.fields['carRegistrationNumber'] = carNumberController.text.trim();
      request.fields['ownerName'] = ownerNameController.text.trim();
      request.fields['carMakeModelVariant'] = modelController.text.trim();
      request.fields['yearOfRegistration'] = yearOfMfgController.text.trim();
      request.fields['ownershipSerialNumber'] = ownershipSerialNoController.text
          .trim();

      // optional fields
      if (odometerController.text.trim().isNotEmpty) {
        request.fields['odometerReadingInKms'] = odometerController.text.trim();
      }
      if (notesController.text.trim().isNotEmpty) {
        request.fields['additionalNotes'] = notesController.text.trim();
      }
      if (inspectionDateTimeUtcForApi != null &&
          inspectionDateTimeUtcForApi!.isNotEmpty) {
        request.fields['inspectionDateTime'] = inspectionDateTimeUtcForApi!;
      }
      if (addressController.text.trim().isNotEmpty) {
        request.fields['inspectionAddress'] = addressController.text.trim();
      }

      // images
      for (final image in selectedImages) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'carImages',
            image.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('Inspection API status: ${response.statusCode}');
      debugPrint('Inspection API body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Failed to submit request: ${response.statusCode}',
          type: ToastType.error,
        );
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error submitting request',
        type: ToastType.error,
      );
      return false;
    } finally {
      isScheduleInspectionLoading.value = false;
    }
  }

  Future<void> submitInspectionRequest1() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    isScheduleInspectionLoading.value = true;
    try {
      final uri = Uri.parse(AppUrls.addInspetionRequest);

      final request = http.MultipartRequest('POST', uri);

      // 🔹 Add headers here
      final token =
          await SharedPrefsHelper.getString(SharedPrefsHelper.tokenKey) ?? '';

      if (token.isNotEmpty) {
        request.headers.addAll({
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          // DON'T set Content-Type here, http.MultipartRequest will handle boundary
        });
      }

      // required fields
      request.fields['carRegistrationNumber'] = carNumberController.text.trim();
      request.fields['ownerName'] = ownerNameController.text.trim();
      request.fields['carMakeModelVariant'] = modelController.text.trim();
      request.fields['yearOfRegistration'] = yearOfMfgController.text.trim();
      request.fields['ownershipSerialNumber'] = ownershipSerialNoController.text
          .trim();

      // optional fields
      if (odometerController.text.trim().isNotEmpty) {
        request.fields['odometerReadingInKms'] = odometerController.text.trim();
      }
      if (notesController.text.trim().isNotEmpty) {
        request.fields['additionalNotes'] = notesController.text.trim();
      }
      if (inspectionDateTimeUtcForApi != null &&
          inspectionDateTimeUtcForApi!.isNotEmpty) {
        request.fields['inspectionDateTime'] = inspectionDateTimeUtcForApi!;
      }
      if (addressController.text.trim().isNotEmpty) {
        request.fields['inspectionAddress'] = addressController.text.trim();
      }

      // images: key must match upload.array("carImages", 5) on backend
      for (final image in selectedImages) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'carImages',
            image.path,
            contentType: MediaType('image', 'jpeg'), // or detect type
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        SellMyCarPage.showCallbackConfirmationDialog();
      } else {
        ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Failed to submit request: ${response.statusCode}',
          type: ToastType.error,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error submiting request',
        type: ToastType.error,
      );
    } finally {
      isScheduleInspectionLoading.value = false;
    }
  }
}

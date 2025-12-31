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
import 'package:otobix_customer_app/widgets/toast_widget.dart';

class SellMyCarController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();

  late TextEditingController carRegistrationNumberController;
  late TextEditingController ownerNameController;
  late TextEditingController makeController;
  late TextEditingController modelController;
  late TextEditingController variantController;
  late TextEditingController yearOfRegController;
  late TextEditingController ownershipSerialNoController;
  late TextEditingController odometerReadingInKmsController;
  late TextEditingController additionalNotesController;
  late TextEditingController inspectionDateTimeController =
      TextEditingController();
  late TextEditingController inspectionAddressController =
      TextEditingController();

  // API fetched data
  RxString fetchedMakerDescStringToShow = ''.obs;
  RxString fetchedMakerModelStringToShow = ''.obs;

  // Button loading states (use in ButtonWidget if you want)
  final isBannersLoading = false.obs;
  final isFetchCarDetailsLoading = false.obs;
  final isUploadImagesLoading = false.obs;
  final isRequestCallbackLoading = false.obs;
  final isScheduleInspectionLoading = false.obs;

  static const String _loadingValueForDropdown = '__loading__';

  // Banners
  final headerBannersList = <SellMyCarBannersModel>[].obs;
  final footerBannersList = <SellMyCarBannersModel>[].obs;

  // Car models list (for dropdown suggestions)
  final RxList<String> carModels = <String>[].obs;
  // Timer? _modelSearchDebounce;

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

  // Enable/disable fields
  final isModelEnabled = false.obs;
  final isVariantEnabled = false.obs;

  // Debounces
  Timer? _makeSearchDebounce;
  Timer? _modelSearchDebounce;
  Timer? _variantSearchDebounce;

  // Keep last values to detect parent changes
  String _lastMake = '';
  String _lastModel = '';

  @override
  void onInit() {
    super.onInit();
    carRegistrationNumberController = TextEditingController();
    ownerNameController = TextEditingController();
    makeController = TextEditingController();
    modelController = TextEditingController();
    variantController = TextEditingController();
    yearOfRegController = TextEditingController();
    ownershipSerialNoController = TextEditingController();
    odometerReadingInKmsController = TextEditingController();
    additionalNotesController = TextEditingController();
    inspectionDateTimeController = TextEditingController();
    inspectionAddressController = TextEditingController();

    _fetchBannersList();

    _setupMakeSearchListener();
    _setupModelSearchListener();
    _setupVariantSearchListener();

    // Start state
    isModelEnabled.value = false;
    isVariantEnabled.value = false;

    // Optional: preload makes
    _fetchMakeSuggestions('');
  }

  // Fetch car details
  Future<void> fetchCarDetails() async {
    // Basic validation: car number required
    if (carRegistrationNumberController.text.trim().isEmpty) {
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
          'vehicleRegistrationNumber': carRegistrationNumberController.text
              .trim(),
          'userId': userId,
        },
      );

      if (response.statusCode != 200) {
        ToastWidget.show(
          context: Get.context!,
          title: "Failed to fetch car details",
          subtitle: "Server error: ${response.statusCode}",
          type: ToastType.error,
        );
        return;
      }

      final body = jsonDecode(response.body);
      final bool success = body['success'] == true;
      final String message = body['message']?.toString() ?? '';
      final data = body['data'] ?? {};
      final result = data['result'];

      if (!success) {
        ToastWidget.show(
          context: Get.context!,
          title: "Failed",
          subtitle: message.isNotEmpty ? message : "Unable to fetch details.",
          type: ToastType.error,
        );
        return;
      }

      if (result == null || (result is Map && result.isEmpty)) {
        ToastWidget.show(
          context: Get.context!,
          title: "Invalid details",
          subtitle: "Invalid registration number or no data found.",
          type: ToastType.error,
        );
        return;
      }

      final Map<String, dynamic> r = Map<String, dynamic>.from(result);

      // ✅ Use your new API keys directly
      final String fetchedOwnerName = r['owner']?.toString() ?? '';
      fetchedMakerDescStringToShow.value =
          r['makerDescription']?.toString() ?? '';
      fetchedMakerModelStringToShow.value = r['makerModel']?.toString() ?? '';

      final String registered =
          r['registered']?.toString() ?? ''; // "31-01-2014"

      // Extract year from "31-01-2014"
      String yearOnly = '';
      if (registered.isNotEmpty) {
        final match = RegExp(r'(\d{4})$').firstMatch(registered.trim());
        if (match != null) yearOnly = match.group(1)!;
      }

      // Fill controllers
      ownerNameController.text = fetchedOwnerName;
      yearOfRegController.text = yearOnly;

      // Optional: you can show status somewhere if needed
      // final status = r['status']?.toString(); // "ACTIVE"

      // if (response.statusCode == 200) {
      //   final body = jsonDecode(response.body);

      //   final bool success = body['success'] == true;
      //   final String message = body['message']?.toString() ?? '';
      //   final data = body['data'] ?? {};
      //   final result = data['result'] ?? {};
      //   final String internalStatusCode =
      //       data['internalStatusCode']?.toString() ?? '';

      //   if (!success) {
      //     ToastWidget.show(
      //       context: Get.context!,
      //       title: "Failed",
      //       subtitle: message.isNotEmpty ? message : "Unable to fetch details.",
      //       type: ToastType.error,
      //     );
      //     return;
      //   }

      //   if (internalStatusCode == "101") {
      //     // ✅ Map API result → your form fields
      //     final String fetchedRegistrationNumber =
      //         // result['rc_regn_no']?.toString() ??
      //         carRegistrationNumberController.text.trim();
      //     final String fetchedOwnerName = result['owner']?.toString() ?? '';
      //     fetchedMakerDescStringToShow.value =
      //         result['makerDescription']?.toString() ?? '';
      //     fetchedMakerModelStringToShow.value =
      //         result['makerModel']?.toString() ?? '';
      //     final String fetchedRegistrationMonthYear =
      //         result['registered']?.toString() ?? ''; // e.g. "12-2006"

      //     // Optionally extract year from formats like "12-2006" or "15-04-2015"
      //     String yearOnly = '';
      //     if (fetchedRegistrationMonthYear.isNotEmpty) {
      //       final match = RegExp(
      //         r'(\d{4})$',
      //       ).firstMatch(fetchedRegistrationMonthYear.trim());
      //       if (match != null) {
      //         yearOnly = match.group(1)!; // e.g. "2015"
      //       }
      //     }

      //     // Fill controllers
      //     carRegistrationNumberController.text =
      //         fetchedRegistrationNumber.isNotEmpty
      //         ? fetchedRegistrationNumber
      //         : carRegistrationNumberController.text.trim();
      //     ownerNameController.text = fetchedOwnerName;
      //     yearOfRegController.text = yearOnly;

      //     // // For dropdown: ensure model appears in list
      //     // if (makerModel.isNotEmpty && !carModels.contains(makerModel)) {
      //     //   carModels.insert(0, makerModel);
      //     // }
      //   } else if (internalStatusCode == "102") {
      //     // ❌ Invalid details (based on your backend contract)
      //     ToastWidget.show(
      //       context: Get.context!,
      //       title: "Invalid details",
      //       subtitle: "Invalid registration number or no data found.",
      //       type: ToastType.error,
      //     );
      //   } else {
      //     // ❌ Unknown / unhandled status code
      //     ToastWidget.show(
      //       context: Get.context!,
      //       title: "Failed to fetch car details",
      //       subtitle: "Unexpected response code: $internalStatusCode",
      //       type: ToastType.error,
      //     );
      //   }
      // } else {
      //   debugPrint(
      //     "Failed to fetch car details: status code ${response.statusCode}",
      //   );
      //   ToastWidget.show(
      //     context: Get.context!,
      //     title: "Failed to fetch car details",
      //     subtitle: "Server error: ${response.statusCode}",
      //     type: ToastType.error,
      //   );
      // }
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

  void _setupMakeSearchListener() {
    makeController.addListener(() {
      final make = makeController.text.trim();

      // If make changed => reset model + variant (and their dropdown lists)
      if (make != _lastMake) {
        _lastMake = make;

        modelController.clear();
        variantController.clear();

        isModelEnabled.value = make.isNotEmpty;
        isVariantEnabled.value = false;

        _clearDropdownItems('car_model');
        _clearDropdownItems('car_variant');

        // When make becomes selected, load models immediately
        if (make.isNotEmpty) {
          _fetchModelSuggestions(make, '');
        }
      }

      _makeSearchDebounce?.cancel();

      // fetch makes (empty => top 20)
      _makeSearchDebounce = Timer(const Duration(milliseconds: 350), () {
        _fetchMakeSuggestions(make);
      });
    });
  }

  void _setupModelSearchListener() {
    modelController.addListener(() {
      final make = makeController.text.trim();
      final model = modelController.text.trim();

      // Don't search models until make selected
      if (make.isEmpty) return;

      // If model changed => reset variant
      if (model != _lastModel) {
        _lastModel = model;

        variantController.clear();
        isVariantEnabled.value = model.isNotEmpty;

        _clearDropdownItems('car_variant');

        // When model becomes selected, load variants immediately
        if (model.isNotEmpty) {
          _fetchVariantSuggestions(make, model, '');
        }
      }

      _modelSearchDebounce?.cancel();

      _modelSearchDebounce = Timer(const Duration(milliseconds: 350), () {
        _fetchModelSuggestions(make, model);
      });
    });
  }

  void _setupVariantSearchListener() {
    variantController.addListener(() {
      final make = makeController.text.trim();
      final model = modelController.text.trim();
      final variantQ = variantController.text.trim();

      // Don't search variants until make+model selected
      if (make.isEmpty || model.isEmpty) return;

      _variantSearchDebounce?.cancel();

      _variantSearchDebounce = Timer(const Duration(milliseconds: 350), () {
        _fetchVariantSuggestions(make, model, variantQ);
      });
    });
  }

  Future<void> _fetchMakeSuggestions(String query) async {
    _setDropdownLoading('car_make', true);
    try {
      final response = await ApiService.post(
        endpoint: AppUrls.searchCarMakes,
        body: {'q': query, 'limit': 20},
      );

      if (response.statusCode != 200) return;

      final body = jsonDecode(response.body);
      if (body['success'] != true) return;

      final List<String> makes = (body['data'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();

      _updateDropdownItems('car_make', makes);
    } catch (e) {
      debugPrint('search makes error: $e');
    }
  }

  Future<void> _fetchModelSuggestions(String make, String query) async {
    _setDropdownLoading('car_model', true);
    try {
      final response = await ApiService.post(
        endpoint: AppUrls.searchCarModelsByMake,
        body: {'make': make, 'q': query, 'limit': 20},
      );

      if (response.statusCode != 200) return;

      final body = jsonDecode(response.body);
      if (body['success'] != true) return;

      final List<String> models = (body['data'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();

      _updateDropdownItems('car_model', models);
    } catch (e) {
      debugPrint('search models error: $e');
    }
  }

  Future<void> _fetchVariantSuggestions(
    String make,
    String model,
    String query,
  ) async {
    _setDropdownLoading('car_variant', true);
    try {
      final response = await ApiService.post(
        endpoint: AppUrls.searchCarVariantsByMakeModel,
        body: {'make': make, 'model': model, 'q': query, 'limit': 20},
      );

      if (response.statusCode != 200) return;

      final body = jsonDecode(response.body);
      if (body['success'] != true) return;

      final List<String> variants = (body['data'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();

      _updateDropdownItems('car_variant', variants);
    } catch (e) {
      debugPrint('search variants error: $e');
    }
  }

  // Future<void> _fetchCarModelSuggestions(String query) async {
  //   try {
  //     final response = await ApiService.post(
  //       endpoint: AppUrls.searchCarMakeModelVariant,
  //       body: {
  //         'q': query, // no manual encoding here
  //         'limit': 20,
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final body = jsonDecode(response.body);
  //       final bool success = body['success'] == true;
  //       if (!success) {
  //         debugPrint('Search car models failed: ${body['message']}');
  //         return;
  //       }

  //       final List<dynamic> data = body['data'] ?? [];
  //       final List<String> models = data.map((e) => e.toString()).toList();

  //       // Keep your list if you need it elsewhere
  //       carModels.assignAll(models);

  //       // 🔥 Update the dropdown's internal controller, if it exists
  //       if (Get.isRegistered<DropdownController<String>>(tag: 'car_model')) {
  //         final dropdownCtrl = Get.find<DropdownController<String>>(
  //           tag: 'car_model',
  //         );

  //         final dropdownItems = models
  //             .map((m) => DropdownMenuItem<String>(value: m, child: Text(m)))
  //             .toList();

  //         dropdownCtrl.updateItems(dropdownItems);
  //       }
  //     } else {
  //       debugPrint('Search car models failed: status ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     debugPrint('Search car models error: $e');
  //   }
  // }

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
              (banner) =>
                  banner['type'] == AppConstants.bannerTypes.header &&
                  banner['status'] == AppConstants.bannerStatus.active,
            )
            .cast<Map<String, dynamic>>()
            .toList();

        final footerBannerMaps = dataList
            .where(
              (banner) =>
                  banner['type'] == AppConstants.bannerTypes.footer &&
                  banner['status'] == AppConstants.bannerStatus.active,
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
  Future<bool> submitInspectionRequest({required bool isSchedule}) async {
    if (!(formKey.currentState?.validate() ?? false)) return false;
    final loading = isSchedule
        ? isScheduleInspectionLoading
        : isRequestCallbackLoading;
    loading.value = true;

    try {
      final uri = Uri.parse(AppUrls.addTelecallingRequest);
      final request = http.MultipartRequest('POST', uri);

      final token =
          await SharedPrefsHelper.getString(SharedPrefsHelper.tokenKey) ?? '';

      final customerContactNumber =
          await SharedPrefsHelper.getString(
            SharedPrefsHelper.userPhoneNumberKey,
          ) ??
          '';

      if (token.isNotEmpty) {
        request.headers.addAll({
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        });
      }

      // required fields
      request.fields['carRegistrationNumber'] = carRegistrationNumberController
          .text
          .trim();
      request.fields['ownerName'] = ownerNameController.text.trim();
      request.fields['make'] = makeController.text.trim();
      request.fields['model'] = modelController.text.trim();
      request.fields['variant'] = variantController.text.trim();
      request.fields['yearOfRegistration'] = yearOfRegController.text.trim();
      request.fields['ownershipSerialNumber'] = ownershipToNumber(
        ownershipSerialNoController.text,
      );
      request.fields['customerContactNumber'] = customerContactNumber;

      // optional fields
      if (odometerReadingInKmsController.text.trim().isNotEmpty) {
        request.fields['odometerReadingInKms'] = odometerReadingInKmsController
            .text
            .trim();
      }
      if (additionalNotesController.text.trim().isNotEmpty) {
        request.fields['additionalNotes'] = additionalNotesController.text
            .trim();
      }
      if (inspectionDateTimeUtcForApi != null &&
          inspectionDateTimeUtcForApi!.isNotEmpty) {
        request.fields['inspectionDateTime'] = inspectionDateTimeUtcForApi!;
      }
      if (inspectionAddressController.text.trim().isNotEmpty) {
        request.fields['inspectionAddress'] = inspectionAddressController.text
            .trim();
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

      // debugPrint('Inspection API status: ${response.statusCode}');
      // debugPrint('Inspection API body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      if (response.statusCode == 400) {
        final message =
            json.decode(response.body)['message'] ??
            'Failed to submit inspection request. Please try again.';
        ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: message,
          type: ToastType.error,
        );
        return false;
      } else if (response.statusCode == 405) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Inspection request for this car already exists',
          type: ToastType.error,
        );
        return false;
      } else {
        ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Failed to submit request',
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
      loading.value = false;
    }
  }

  void _updateDropdownItems(String tag, List<String> values) {
    if (!Get.isRegistered<DropdownController<String>>(tag: tag)) return;

    final dropdownCtrl = Get.find<DropdownController<String>>(tag: tag);
    final items = values
        .map((v) => DropdownMenuItem<String>(value: v, child: Text(v)))
        .toList();

    dropdownCtrl.updateItems(items);
  }

  void _clearDropdownItems(String tag) => _updateDropdownItems(tag, []);

  // Convert to number
  String ownershipToNumber(String value) {
    final v = value.trim().toLowerCase();

    // handles: "1st", "2nd", "3rd", "4th", "5th"
    final match = RegExp(r'^(\d+)').firstMatch(v);
    if (match != null) return match.group(1)!;

    // handles: "above" (choose what backend expects)
    if (v == 'above') return '6';

    // fallback: send as-is (or return '' if you want to block)
    return value.trim();
  }

  void _setDropdownLoading(String tag, bool loading) {
    if (!Get.isRegistered<DropdownController<String>>(tag: tag)) return;

    final dropdownCtrl = Get.find<DropdownController<String>>(tag: tag);

    if (!loading) return; // we only need to inject placeholder while loading

    dropdownCtrl.updateItems([
      DropdownMenuItem<String>(
        value: _loadingValueForDropdown,
        enabled: false, // IMPORTANT: user can't select it
        child: Row(
          children: const [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 10),
            Text('Loading...'),
          ],
        ),
      ),
    ]);
  }

  // Close method to dispose controllers
  @override
  void onClose() {
    _makeSearchDebounce?.cancel();
    _modelSearchDebounce?.cancel();
    _variantSearchDebounce?.cancel();

    carRegistrationNumberController.dispose();
    ownerNameController.dispose();
    makeController.dispose();
    modelController.dispose();
    variantController.dispose();
    yearOfRegController.dispose();
    ownershipSerialNoController.dispose();
    odometerReadingInKmsController.dispose();
    additionalNotesController.dispose();
    inspectionDateTimeController.dispose();
    inspectionAddressController.dispose();
    super.onClose();
  }
}

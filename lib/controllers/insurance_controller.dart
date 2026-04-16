import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/services/api_service.dart';
import 'package:otobix_customer_app/services/shared_prefs_helper.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';
import 'package:otobix_customer_app/views/insurance_redirect_page.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';

class InsuranceController extends GetxController {
  // Text controllers
  final registrationNumberController = TextEditingController();
  final manufactureDateController = TextEditingController();

  final RxString selectedPolicyType = 'Comprehensive'.obs;
  final RxString selectedRto = ''.obs;
  final RxString selectedMake = ''.obs;
  final RxString selectedModel = ''.obs;
  final RxString selectedVariant = ''.obs;
  final RxString selectedFuelType = ''.obs;
  final RxString selectedRegionCode = ''.obs;
  final RxString selectedManufacturingDate = ''.obs;

  final RxInt selectedMakeId = 0.obs;
  final RxInt selectedModelId = 0.obs;
  final RxInt selectedVariantId = 0.obs;
  final RxInt selectedFuelTypeId = 0.obs;
  final RxInt selectedRegisteredCityId = 0.obs;
  final RxInt selectedOwnerType = 1.obs; // 1 for Individual, 2 for Corporate

  // Loaders
  RxBool isFetchQuotesLoading = false.obs;
  // RxBool isOpenRedirectLinkPageLoading = false.obs;
  RxBool isFetchRtoListLoading = false.obs;
  RxBool isFetchMakesListLoading = false.obs;
  RxBool isFetchModelsListLoading = false.obs;
  RxBool isFetchVariantsListLoading = false.obs;
  RxBool isFetchFuelTypesListLoading = false.obs;
  RxBool isFetchGeneratedQuotesListLoading = false.obs;
  final RxMap<String, bool> proceedLoadingMap = <String, bool>{}.obs;

  // Conditions
  RxBool isModelEnabled = false.obs;
  RxBool isVariantEnabled = false.obs;
  RxBool isFuelTypeEnabled = false.obs;

  // Lists
  RxList<Map<String, dynamic>> generatedQuotesList =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> rtoList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> makesList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> modelsList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> variantsList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> fuelTypesList = <Map<String, dynamic>>[].obs;

  // Car type options
  final List<Map<String, dynamic>> carTypeOptions = [
    {'label': 'Used Car', 'value': 'used'},
    {'label': 'New Car', 'value': 'new'},
  ];

  // Policy type options
  final List<Map<String, dynamic>> policyTypeOptions = [
    {'label': 'Comprehensive', 'value': 'Comprehensive'},
    {'label': 'Third Party', 'value': 'TP'},
  ];

  // Owner type options
  final List<Map<String, dynamic>> ownerTypeOptions = [
    {'label': 'Individual', 'value': 1},
    {'label': 'Corporate', 'value': 2},
  ];

  // Fuel types
  final List<Map<String, dynamic>> fuelTypeMasterList = [
    {'fuelTypeId': 0, 'fuelTypeName': 'None'},
    {'fuelTypeId': 3, 'fuelTypeName': 'CNG'},
    {'fuelTypeId': 4, 'fuelTypeName': 'Diesel'},
    {'fuelTypeId': 5, 'fuelTypeName': 'LPG'},
    {'fuelTypeId': 7, 'fuelTypeName': 'Petrol'},
    {'fuelTypeId': 8, 'fuelTypeName': 'LPG + Petrol'},
    {'fuelTypeId': 9, 'fuelTypeName': 'Electric'},
  ];

  RxInt selectedCarTypeIndex = 0.obs;
  // RxInt selectedPolicyTypeIndex = 0.obs;

  // API response data
  RxList<dynamic> quotes = <dynamic>[].obs;
  RxString redirectLink = ''.obs;
  // RxString quoteMessage = ''.obs;
  RxBool hasFetchedQuotes = false.obs;

  RxBool isUsedCar = true.obs;
  // bool get isUsedCar =>
  //     carTypeOptions[selectedCarTypeIndex.value]['value'] == 'used';

  bool get hasQuotes => quotes.isNotEmpty;

  bool get hasRedirectLink => redirectLink.value.trim().isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    fetchGeneratedQuotesList();
    fetchRtoList();
    fetchMakesList();
  }

  void onCarTypeChanged(int index) {
    selectedCarTypeIndex.value = index;
    isUsedCar.value = carTypeOptions[index]['value'] == 'used';

    hasFetchedQuotes.value = false;
    quotes.clear();
    redirectLink.value = '';

    if (isUsedCar.value) {
      selectedRto.value = '';
      selectedMake.value = '';
      selectedModel.value = '';
      selectedVariant.value = '';
      selectedFuelType.value = '';
      selectedManufacturingDate.value = '';

      selectedMakeId.value = 0;
      selectedModelId.value = 0;
      selectedVariantId.value = 0;
      selectedFuelTypeId.value = 0;
      selectedRegisteredCityId.value = 0;
      selectedRegionCode.value = '';

      manufactureDateController.clear();

      _clearModelSelection();
      _clearFuelTypeSelection();
      _clearVariantSelection();

      _setModelEnabled(false);
      _setFuelTypeEnabled(false);
      _setVariantEnabled(false);
    } else {
      registrationNumberController.clear();
      selectedPolicyType.value = 'Comprehensive';
    }
  }

  void onPolicyTypeChanged(int index) {
    // selectedPolicyTypeIndex.value = index;
    selectedPolicyType.value = policyTypeOptions[index]['value'];
    // _clearQuoteData();
  }

  void onOwnerTypeChanged(int index) {
    selectedOwnerType.value = ownerTypeOptions[index]['value'];
    // _clearQuoteData();
  }

  void onRegistrationNumberChanged(String value) {
    registrationNumberController.value = TextEditingValue(
      text: value.toUpperCase(),
      selection: TextSelection.collapsed(offset: value.length),
    );

    if (hasFetchedQuotes.value) {
      // _clearQuoteData();
    }
  }

  // void _clearQuoteData() {
  //   quotes.clear();
  //   redirectLink.value = '';
  //   // quoteMessage.value = '';
  //   hasFetchedQuotes.value = false;
  // }

  // Fetch Quotes API
  Future<void> fetchQuotes() async {
    if (isFetchQuotesLoading.value) return;

    if (isUsedCar.value && registrationNumberController.text.trim().isEmpty) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Required',
        subtitle: 'Please enter your car registration number',
        type: ToastType.error,
      );
      return;
    }

    if (!isUsedCar.value && !_validateNewCarFields()) {
      return;
    }

    isFetchQuotesLoading.value = true;
    // _clearQuoteData();

    try {
      final userId =
          await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ?? "";

      final Map<String, dynamic> requestBody;

      if (isUsedCar.value) {
        requestBody = {
          "userId": userId,
          "carType": 'Used Car',
          "registrationNumber": registrationNumberController.text.trim(),
          "policyType": selectedPolicyType.value,
        };
      } else {
        requestBody = {
          "userId": userId,
          "carType": 'New Car',
          "policyType": "New",
          "makeId": selectedMakeId.value,
          "modelId": selectedModelId.value,
          "variantId": selectedVariantId.value,
          "fuelTypeId": selectedFuelTypeId.value,
          "registrationCode": selectedRegisteredCityId.value,
          "registrationRtoCode": selectedRegionCode.value,
          "manufacturingDate": selectedManufacturingDate.value,
          "vehicleOwnedBy":
              selectedOwnerType.value, //1 for Individual 2 for Corporate
          // Extra fields if new car
          "makeName": selectedMake.value,
          "modelName": selectedModel.value,
          "variantName": selectedVariant.value,
          "fuelType": selectedFuelType.value,
        };
      }
      // debugPrint('Request body: $requestBody');

      final response = await ApiService.post(
        endpoint: AppUrls.fetchInsuranceQuotes,
        body: requestBody,
      );

      final responseBody = jsonDecode(response.body);
      // debugPrint('Response body: $responseBody');

      if (response.statusCode == 200) {
        final data = responseBody['data'] ?? {};

        final dynamic fetchedQuotes = data['quotes'];
        if (fetchedQuotes is List) {
          quotes.assignAll(fetchedQuotes);
        }

        redirectLink.value = (data['redirectLink'] ?? '').toString();
        hasFetchedQuotes.value = true;

        // if (quotes.isNotEmpty) {
        //   quoteMessage.value = 'Quotes are available for your car.';
        // } else {
        //   quoteMessage.value =
        //       'No quotes are available for your car right now.';
        // }
      } else if (response.statusCode == 400) {
        final String errorMsg =
            (responseBody['message'] ?? 'Failed to fetch quotes').toString();

        ToastWidget.show(
          context: Get.context!,
          title: 'Failed',
          subtitle: errorMsg,
          type: ToastType.error,
        );
      } else {
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed',
          subtitle: 'Failed to fetch quotes',
          type: ToastType.error,
        );
      }
    } catch (error) {
      debugPrint('Error fetching quotes: $error');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error fetching quotes',
        type: ToastType.error,
      );
    } finally {
      isFetchQuotesLoading.value = false;
    }
  }

  // Fetch Generated Quotes List API
  Future<void> fetchGeneratedQuotesList() async {
    if (isFetchGeneratedQuotesListLoading.value) return;

    isFetchGeneratedQuotesListLoading.value = true;

    final String userId =
        await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ?? '';

    try {
      final response = await ApiService.get(
        endpoint: AppUrls.fetchInsuranceGeneratedQuotesList(userId: userId),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = responseBody['data'] ?? [];
        generatedQuotesList.value = List<Map<String, dynamic>>.from(data);
      }
    } catch (error) {
      debugPrint('Error fetching generated quotes list: $error');
      // ToastWidget.show(
      //   context: Get.context!,
      //   title: 'Error',
      //   subtitle: 'Error fetching generated quotes list',
      //   type: ToastType.error,
      // );
    } finally {
      isFetchGeneratedQuotesListLoading.value = false;
    }
  }

  Future<void> openRedirectLinkPage({
    required String proceedRedirectLink,
  }) async {
    if (proceedRedirectLink.trim().isEmpty) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Failed',
        subtitle: 'Redirect link is not available',
        type: ToastType.error,
      );
      return;
    }

    try {
      proceedLoadingMap[proceedRedirectLink] = true;
      await Get.to(() => InsuranceRedirectPage(url: proceedRedirectLink));
    } catch (error) {
      debugPrint('Error opening redirect link page: $error');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error opening insurance page',
        type: ToastType.error,
      );
    } finally {
      proceedLoadingMap[proceedRedirectLink] = false;
    }
  }

  // Fetch RTO List API
  Future<void> fetchRtoList() async {
    if (isFetchRtoListLoading.value) return;

    isFetchRtoListLoading.value = true;
    try {
      final response = await ApiService.get(
        endpoint: AppUrls.getInsuranceRtoList,
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = responseBody['data'] ?? [];
        rtoList.value = List<Map<String, dynamic>>.from(data);
        selectedRegisteredCityId.value = rtoList.first['RegisteredCityId'];
        selectedRegionCode.value = rtoList.first['RegionCode'];
      } else {
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed',
          subtitle: 'Failed to fetch rto list',
          type: ToastType.error,
        );
      }
    } catch (error) {
      debugPrint('Error fetching rto list: $error');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error fetching rto list',
        type: ToastType.error,
      );
    } finally {
      isFetchRtoListLoading.value = false;
    }
  }

  // Fetch Makes List API
  Future<void> fetchMakesList() async {
    if (isFetchMakesListLoading.value) return;

    isFetchMakesListLoading.value = true;
    try {
      final response = await ApiService.get(
        endpoint: AppUrls.getInsuranceMakesList,
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = responseBody['data'] ?? [];
        makesList.value = List<Map<String, dynamic>>.from(data);
        _setModelEnabled(false);
        _setVariantEnabled(false);
        _setFuelTypeEnabled(false);

        selectedMake.value = '';
        selectedMakeId.value = 0;

        _clearModelSelection();
        _clearVariantSelection();
        _clearFuelTypeSelection();
      } else {
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed',
          subtitle: 'Failed to fetch makes list',
          type: ToastType.error,
        );
      }
    } catch (error) {
      debugPrint('Error fetching makes list: $error');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error fetching makes list',
        type: ToastType.error,
      );
    } finally {
      isFetchMakesListLoading.value = false;
    }
  }

  // Fetch Models List API
  Future<void> fetchModelsList({required int makeId}) async {
    if (isFetchModelsListLoading.value) return;

    isFetchModelsListLoading.value = true;
    _setModelEnabled(false);

    try {
      final response = await ApiService.get(
        endpoint: AppUrls.getInsuranceModelsList(makeId: makeId),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = responseBody['data'] ?? [];
        modelsList.value = List<Map<String, dynamic>>.from(data);

        _setModelEnabled(modelsList.isNotEmpty);
        _setVariantEnabled(false);
        _setFuelTypeEnabled(false);
      } else {
        modelsList.clear();
        _setModelEnabled(false);

        ToastWidget.show(
          context: Get.context!,
          title: 'Failed',
          subtitle: 'Failed to fetch models list',
          type: ToastType.error,
        );
      }
    } catch (error) {
      modelsList.clear();
      _setModelEnabled(false);

      debugPrint('Error fetching models list: $error');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error fetching models list',
        type: ToastType.error,
      );
    } finally {
      isFetchModelsListLoading.value = false;
    }
  }

  // Fetch Fuel Types List API
  Future<void> fetchFuelTypesList() async {
    if (isFetchFuelTypesListLoading.value) return;

    isFetchFuelTypesListLoading.value = true;
    _setFuelTypeEnabled(false);

    try {
      fuelTypesList.assignAll(fuelTypeMasterList);
      _setFuelTypeEnabled(fuelTypesList.isNotEmpty);
      _setVariantEnabled(false);
    } catch (error) {
      fuelTypesList.clear();
      _setFuelTypeEnabled(false);
      _setVariantEnabled(false);

      debugPrint('Error setting fuel types list: $error');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error setting fuel types list',
        type: ToastType.error,
      );
    } finally {
      isFetchFuelTypesListLoading.value = false;
    }
  }

  // Fetch Variants List API
  Future<void> fetchVariantsList({required int modelId}) async {
    if (isFetchVariantsListLoading.value) return;

    isFetchVariantsListLoading.value = true;
    _setVariantEnabled(false);

    try {
      final response = await ApiService.get(
        endpoint: AppUrls.getInsuranceVariantsList(modelId: modelId),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = responseBody['data'] ?? [];
        variantsList.value = List<Map<String, dynamic>>.from(data);

        _setVariantEnabled(variantsList.isNotEmpty);
      } else {
        variantsList.clear();
        _setVariantEnabled(false);

        ToastWidget.show(
          context: Get.context!,
          title: 'Failed',
          subtitle: 'Failed to fetch variants list',
          type: ToastType.error,
        );
      }
    } catch (error) {
      variantsList.clear();
      _setVariantEnabled(false);

      debugPrint('Error fetching variants list: $error');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error fetching variants list',
        type: ToastType.error,
      );
    } finally {
      isFetchVariantsListLoading.value = false;
    }
  }

  // Fetch Variants List Using Fuel Type API
  Future<void> fetchVariantsListUsingFuelType({
    required int modelId,
    required int fuelTypeId,
  }) async {
    if (isFetchVariantsListLoading.value) return;

    isFetchVariantsListLoading.value = true;
    _setVariantEnabled(false);

    try {
      final response = await ApiService.get(
        endpoint: AppUrls.getInsuranceVariantsListUsingFuelType(
          modelId: modelId,
          fuelTypeId: fuelTypeId,
        ),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = responseBody['data'] ?? [];
        variantsList.value = List<Map<String, dynamic>>.from(data);

        _setVariantEnabled(variantsList.isNotEmpty);
      } else {
        variantsList.clear();
        _setVariantEnabled(false);

        ToastWidget.show(
          context: Get.context!,
          title: 'Failed',
          subtitle: 'Failed to fetch variants list using fuel type',
          type: ToastType.error,
        );
      }
    } catch (error) {
      variantsList.clear();
      _setVariantEnabled(false);

      debugPrint('Error fetching variants list using fuel type: $error');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error fetching variants list using fuel type',
        type: ToastType.error,
      );
    } finally {
      isFetchVariantsListLoading.value = false;
    }
  }

  Map<String, dynamic>? _findItemByLabel({
    required List<Map<String, dynamic>> list,
    required String labelKey,
    required String value,
  }) {
    try {
      return list.firstWhere(
        (item) => (item[labelKey] ?? '').toString() == value,
      );
    } catch (_) {
      return null;
    }
  }

  void _clearModelSelection({bool clearList = true}) {
    selectedModel.value = '';
    selectedModelId.value = 0;
    if (clearList) modelsList.clear();
  }

  void _clearVariantSelection({bool clearList = true}) {
    selectedVariant.value = '';
    selectedVariantId.value = 0;
    if (clearList) variantsList.clear();
  }

  void _clearFuelTypeSelection({bool clearList = true}) {
    selectedFuelType.value = '';
    selectedFuelTypeId.value = 0;
    if (clearList) fuelTypesList.clear();
  }

  void _setModelEnabled(bool value) {
    isModelEnabled.value = value;
  }

  void _setVariantEnabled(bool value) {
    isVariantEnabled.value = value;
  }

  void _setFuelTypeEnabled(bool value) {
    isFuelTypeEnabled.value = value;
  }

  void _resetAfterMakeChange() {
    _clearModelSelection();
    _clearFuelTypeSelection();
    _clearVariantSelection();

    _setModelEnabled(false);
    _setFuelTypeEnabled(false);
    _setVariantEnabled(false);
  }

  void _resetAfterModelChange() {
    _clearFuelTypeSelection();
    _clearVariantSelection();

    _setFuelTypeEnabled(false);
    _setVariantEnabled(false);
  }

  void _resetAfterFuelTypeChange() {
    _clearVariantSelection();

    _setVariantEnabled(false);
  }

  void onRtoSelected(String? value) {
    selectedRto.value = value ?? '';
    // _clearQuoteData();

    final selectedItem = value == null || value.isEmpty
        ? null
        : _findItemByLabel(list: rtoList, labelKey: 'RegionCode', value: value);

    selectedRegionCode.value = _safeString(selectedItem?['RegionCode']);
    selectedRegisteredCityId.value = _safeInt(
      selectedItem?['RegisteredCityId'],
    );
  }

  Future<void> onMakeSelected(String? value) async {
    selectedMake.value = value ?? '';

    final selectedItem = value == null || value.isEmpty
        ? null
        : _findItemByLabel(list: makesList, labelKey: 'makeName', value: value);

    selectedMakeId.value = _safeInt(selectedItem?['makeId']);

    _resetAfterMakeChange();

    if (selectedMakeId.value != 0) {
      await fetchModelsList(makeId: selectedMakeId.value);
    }
  }

  Future<void> onModelSelected(String? value) async {
    selectedModel.value = value ?? '';

    final selectedItem = value == null || value.isEmpty
        ? null
        : _findItemByLabel(
            list: modelsList,
            labelKey: 'modelName',
            value: value,
          );

    selectedModelId.value = _safeInt(selectedItem?['modelId']);

    _resetAfterModelChange();

    if (selectedMakeId.value != 0 && selectedModelId.value != 0) {
      await fetchFuelTypesList();
    }
  }

  Future<void> onFuelTypeSelected(String? value) async {
    selectedFuelType.value = value ?? '';

    final selectedItem = value == null || value.isEmpty
        ? null
        : _findItemByLabel(
            list: fuelTypesList,
            labelKey: 'fuelTypeName',
            value: value,
          );

    selectedFuelTypeId.value = _safeInt(selectedItem?['fuelTypeId']);

    _resetAfterFuelTypeChange();

    if (selectedModelId.value == 0 || selectedFuelType.value.trim().isEmpty) {
      return;
    }

    if (selectedFuelTypeId.value == 0) {
      await fetchVariantsList(modelId: selectedModelId.value);
    } else {
      await fetchVariantsListUsingFuelType(
        modelId: selectedModelId.value,
        fuelTypeId: selectedFuelTypeId.value,
      );
    }
  }

  Future<void> onVariantSelected(String? value) async {
    selectedVariant.value = value ?? '';

    final selectedItem = value == null || value.isEmpty
        ? null
        : _findItemByLabel(
            list: variantsList,
            labelKey: 'variantName',
            value: value,
          );

    selectedVariantId.value = _safeInt(selectedItem?['variantId']);

    final int variantFuelTypeId = _safeInt(selectedItem?['fuelTypeId']);
    selectedFuelTypeId.value = variantFuelTypeId;

    final Map<String, dynamic>? fuelTypeItem = fuelTypeMasterList
        .cast<Map<String, dynamic>?>()
        .firstWhere(
          (item) => _safeInt(item?['fuelTypeId']) == variantFuelTypeId,
          orElse: () => null,
        );

    if (fuelTypeItem != null) {
      selectedFuelType.value = _safeString(fuelTypeItem['fuelTypeName']);
    }
  }

  int _safeInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  String _safeString(dynamic value) {
    return value?.toString() ?? '';
  }

  bool _validateNewCarFields() {
    if (selectedRto.value.trim().isEmpty ||
        selectedRegisteredCityId.value == 0 ||
        selectedRegionCode.value.trim().isEmpty) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Required',
        subtitle: 'Please select RTO',
        type: ToastType.error,
      );
      return false;
    }

    if (selectedMakeId.value == 0 || selectedMake.value.trim().isEmpty) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Required',
        subtitle: 'Please select car make',
        type: ToastType.error,
      );
      return false;
    }

    if (selectedModelId.value == 0 || selectedModel.value.trim().isEmpty) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Required',
        subtitle: 'Please select car model',
        type: ToastType.error,
      );
      return false;
    }

    if (selectedFuelType.value.trim().isEmpty) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Required',
        subtitle: 'Please select fuel type',
        type: ToastType.error,
      );
      return false;
    }

    if (selectedVariantId.value == 0 || selectedVariant.value.trim().isEmpty) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Required',
        subtitle: 'Please select variant',
        type: ToastType.error,
      );
      return false;
    }

    if (selectedManufacturingDate.value.trim().isEmpty ||
        manufactureDateController.text.trim().isEmpty) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Required',
        subtitle: 'Please select manufacture date',
        type: ToastType.error,
      );
      return false;
    }

    return true;
  }

  @override
  void onClose() {
    registrationNumberController.dispose();
    manufactureDateController.dispose();
    super.onClose();
  }
}

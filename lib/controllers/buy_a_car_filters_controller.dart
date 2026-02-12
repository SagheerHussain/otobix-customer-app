import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/Models/cars_list_model_for_buy_a_car.dart';
import 'package:otobix_customer_app/services/api_service.dart';
import 'package:otobix_customer_app/utils/app_constants.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';

class BuyACarFiltersController extends GetxController {
  final RxList<String> states = AppConstants.indianStates.obs;

  final RxList<String> bodyTypes = <String>[
    'Hatchback',
    'Sedan',
    'SUV',
    'MUV',
    'Coupe',
    'Convertible',
    'Pickup',
    'Van',
  ].obs;

  final RxList<String> fuelTypes = <String>[
    'Petrol',
    'Diesel',
    'CNG',
    'Electric',
    'Hybrid',
  ].obs;

  final RxList<String> transmissionTypes = <String>[
    'Manual',
    'Automatic',
    'AMT',
    'CVT',
    'DCT',
  ].obs;

  final RxList<String> makeOptions = <String>[].obs;
  final RxList<String> modelOptions = <String>[].obs;
  final RxList<String> variantOptions = <String>[].obs;

  final isMakeLoading = false.obs;
  final isModelLoading = false.obs;
  final isVariantLoading = false.obs;

  final isModelEnabled = false.obs;
  final isVariantEnabled = false.obs;

  Timer? _makeDebounce;
  Timer? _modelDebounce;
  Timer? _variantDebounce;

  final RxnString selectedMake = RxnString(null);
  final RxnString selectedModel = RxnString(null);
  final RxnString selectedVariant = RxnString(null);
  final RxnString selectedState = RxnString(null);

  final RxList<String> selectedFuelTypes = <String>[].obs;
  final RxList<String> selectedTransmissions = <String>[].obs;
  final RxList<String> selectedBodyTypes = <String>[].obs;

  static const double minCarAgeYears = 1;
  static const double maxCarAgeYears = 10;

  final Rx<RangeValues> selectedCarAgeYears = const RangeValues(
    minCarAgeYears,
    maxCarAgeYears,
  ).obs;

  final Rx<RangeValues> appliedCarAgeYears = const RangeValues(
    minCarAgeYears,
    maxCarAgeYears,
  ).obs;

  static const double minMileageKm = 1; // 10000;
  static const double maxMileageKm = 100000; // 50000;

  final Rx<RangeValues> selectedMileageKm = const RangeValues(
    minMileageKm,
    maxMileageKm,
  ).obs;

  final Rx<RangeValues> appliedMileageKm = const RangeValues(
    minMileageKm,
    maxMileageKm,
  ).obs;

  final RxBool isApplied = false.obs;

  final RxnString appliedMake = RxnString(null);
  final RxnString appliedModel = RxnString(null);
  final RxnString appliedVariant = RxnString(null);
  final RxnString appliedState = RxnString(null);

  final RxSet<String> appliedFuelTypes = <String>{}.obs;
  final RxSet<String> appliedTransmissions = <String>{}.obs;
  final RxSet<String> appliedBodyTypes = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    isModelEnabled.value = false;
    isVariantEnabled.value = false;
    fetchMakeSuggestions('');
  }

  @override
  void onClose() {
    _makeDebounce?.cancel();
    _modelDebounce?.cancel();
    _variantDebounce?.cancel();
    super.onClose();
  }

  void setOptionsFromCars(List<CarsListModelForBuyACar> cars) {
    // ✅ Always keep full list of Indian states in dropdown
    states.assignAll(AppConstants.indianStates);

    bodyTypes.assignAll(
      _mergeUnique(bodyTypes, cars.map((c) => c.carBodyType)),
    );
    fuelTypes.assignAll(
      _mergeUnique(fuelTypes, cars.map((c) => c.carFuelType)),
    );
    transmissionTypes.assignAll(
      _mergeUnique(transmissionTypes, cars.map((c) => c.carTransmission)),
    );
  }

  void onMakePicked(String? mk) {
    selectedMake.value = mk;
    selectedModel.value = null;
    selectedVariant.value = null;

    modelOptions.clear();
    variantOptions.clear();

    final make = (mk ?? '').trim();
    isModelEnabled.value = make.isNotEmpty;
    isVariantEnabled.value = false;

    if (make.isNotEmpty) {
      fetchModelSuggestions(make: make, query: '');
    }
  }

  void onModelPicked(String? md) {
    selectedModel.value = md;
    selectedVariant.value = null;

    variantOptions.clear();

    final model = (md ?? '').trim();
    isVariantEnabled.value = model.isNotEmpty;

    final make = (selectedMake.value ?? '').trim();
    if (make.isNotEmpty && model.isNotEmpty) {
      fetchVariantSuggestions(make: make, model: model, query: '');
    }
  }

  void onVariantPicked(String? vr) {
    selectedVariant.value = vr;
  }

  void onMakeSearchChanged(String q) {
    _makeDebounce?.cancel();
    _makeDebounce = Timer(const Duration(milliseconds: 350), () {
      fetchMakeSuggestions(q.trim());
    });
  }

  void onModelSearchChanged(String q) {
    final make = (selectedMake.value ?? '').trim();
    if (make.isEmpty) return;

    _modelDebounce?.cancel();
    _modelDebounce = Timer(const Duration(milliseconds: 350), () {
      fetchModelSuggestions(make: make, query: q.trim());
    });
  }

  void onVariantSearchChanged(String q) {
    final make = (selectedMake.value ?? '').trim();
    final model = (selectedModel.value ?? '').trim();
    if (make.isEmpty || model.isEmpty) return;

    _variantDebounce?.cancel();
    _variantDebounce = Timer(const Duration(milliseconds: 350), () {
      fetchVariantSuggestions(make: make, model: model, query: q.trim());
    });
  }

  Future<void> fetchMakeSuggestions(String query) async {
    isMakeLoading.value = true;
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

      makeOptions.assignAll(makes);
    } catch (e) {
      debugPrint('fetchMakeSuggestions error: $e');
    } finally {
      isMakeLoading.value = false;
    }
  }

  Future<void> fetchModelSuggestions({
    required String make,
    required String query,
  }) async {
    isModelLoading.value = true;
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

      modelOptions.assignAll(models);
    } catch (e) {
      debugPrint('fetchModelSuggestions error: $e');
    } finally {
      isModelLoading.value = false;
    }
  }

  Future<void> fetchVariantSuggestions({
    required String make,
    required String model,
    required String query,
  }) async {
    isVariantLoading.value = true;
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

      variantOptions.assignAll(variants);
    } catch (e) {
      debugPrint('fetchVariantSuggestions error: $e');
    } finally {
      isVariantLoading.value = false;
    }
  }

  void applyFilters() {
    appliedMake.value = selectedMake.value;
    appliedModel.value = selectedModel.value;
    appliedVariant.value = selectedVariant.value;
    appliedState.value = selectedState.value;

    appliedFuelTypes
      ..clear()
      ..addAll(selectedFuelTypes);

    appliedTransmissions
      ..clear()
      ..addAll(selectedTransmissions);

    appliedBodyTypes
      ..clear()
      ..addAll(selectedBodyTypes);

    appliedCarAgeYears.value = selectedCarAgeYears.value;
    appliedMileageKm.value = selectedMileageKm.value;

    isApplied.value = true;
  }

  void resetFilters() {
    selectedMake.value = null;
    selectedModel.value = null;
    selectedVariant.value = null;
    selectedState.value = null;

    selectedFuelTypes.clear();
    selectedTransmissions.clear();
    selectedBodyTypes.clear();

    selectedCarAgeYears.value = const RangeValues(
      minCarAgeYears,
      maxCarAgeYears,
    );
    selectedMileageKm.value = const RangeValues(minMileageKm, maxMileageKm);

    appliedMake.value = null;
    appliedModel.value = null;
    appliedVariant.value = null;
    appliedState.value = null;

    appliedFuelTypes.clear();
    appliedTransmissions.clear();
    appliedBodyTypes.clear();

    appliedCarAgeYears.value = const RangeValues(
      minCarAgeYears,
      maxCarAgeYears,
    );
    appliedMileageKm.value = const RangeValues(minMileageKm, maxMileageKm);

    isApplied.value = false;

    isModelEnabled.value = false;
    isVariantEnabled.value = false;
    modelOptions.clear();
    variantOptions.clear();

    fetchMakeSuggestions('');
  }

  List<CarsListModelForBuyACar> filterCars({
    required List<CarsListModelForBuyACar> source,
    required String searchQueryLower,
  }) {
    final q = searchQueryLower.trim();
    final useFilters = isApplied.value;

    return source.where((c) {
      if (q.isNotEmpty && !c.carName.toLowerCase().contains(q)) return false;
      if (!useFilters) return true;

      if (appliedMake.value != null && appliedMake.value!.isNotEmpty) {
        if (c.carMake != appliedMake.value!) return false;
      }
      if (appliedModel.value != null && appliedModel.value!.isNotEmpty) {
        if (c.carModel != appliedModel.value!) return false;
      }
      if (appliedVariant.value != null && appliedVariant.value!.isNotEmpty) {
        if (c.carVariant != appliedVariant.value!) return false;
      }

      if (appliedState.value != null && appliedState.value!.isNotEmpty) {
        if (c.dealerState != appliedState.value!) return false;
      }

      if (appliedFuelTypes.isNotEmpty &&
          !appliedFuelTypes.contains(c.carFuelType))
        return false;

      if (appliedTransmissions.isNotEmpty &&
          !appliedTransmissions.contains(c.carTransmission))
        return false;

      if (appliedBodyTypes.isNotEmpty &&
          !appliedBodyTypes.contains(c.carBodyType))
        return false;

      final carAge = _carAgeYears(c.carYear);
      final minAge = appliedCarAgeYears.value.start.round();
      final maxAge = appliedCarAgeYears.value.end.round();
      if (carAge < minAge || carAge > maxAge) return false;

      final kms = _parseIntLoose(c.carKms);
      final minKm = appliedMileageKm.value.start.round();
      final maxKm = appliedMileageKm.value.end.round();
      if (kms < minKm || kms > maxKm) return false;

      return true;
    }).toList();
  }

  int _carAgeYears(String yearStr) {
    final year = int.tryParse(yearStr.trim()) ?? 0;
    if (year <= 0) return 5;
    final nowYear = DateTime.now().year;
    return (nowYear - year).clamp(0, 100);
  }

  int _parseIntLoose(String s) {
    final cleaned = s.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleaned) ?? 0;
  }

  List<String> _unique(Iterable<String> items) {
    final set = <String>{};
    for (final x in items) {
      final v = x.trim();
      if (v.isNotEmpty) set.add(v);
    }
    final list = set.toList()..sort();
    return list;
  }

  List<String> _mergeUnique(List<String> existing, Iterable<String> incoming) {
    final set = <String>{};

    for (final e in existing) {
      final v = e.trim();
      if (v.isNotEmpty) set.add(v);
    }
    for (final x in incoming) {
      final v = x.trim();
      if (v.isNotEmpty) set.add(v);
    }

    final list = set.toList()..sort();
    return list;
  }

  Map<String, dynamic> buildAppliedFilterPayload() {
    // ensure applyFilters() was called before using this
    return {
      "make": appliedMake.value,
      "model": appliedModel.value,
      "variant": appliedVariant.value,
      "dealerState": appliedState.value,
      "fuelTypes": appliedFuelTypes.toList(),
      "transmissions": appliedTransmissions.toList(),
      "bodyTypes": appliedBodyTypes.toList(),
      "carAgeYears": {
        "min": appliedCarAgeYears.value.start.round(),
        "max": appliedCarAgeYears.value.end.round(),
      },
      "mileageKm": {
        "min": appliedMileageKm.value.start.round(),
        "max": appliedMileageKm.value.end.round(),
      },
    }..removeWhere((k, v) {
      if (v == null) return true;
      if (v is String && v.trim().isEmpty) return true;
      if (v is List && v.isEmpty) return true;
      return false;
    });
  }
}

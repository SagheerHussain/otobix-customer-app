import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/Models/cars_list_model_for_buy_a_car.dart';

class BuyACarFiltersController extends GetxController {
  // -------------------- OPTIONS (can be set from real cars list) --------------------
  final RxList<String> makes = <String>[].obs;
  final RxMap<String, List<String>> modelsByMake = <String, List<String>>{}.obs;
  final RxMap<String, List<String>> variantsByModel =
      <String, List<String>>{}.obs;

  final RxList<String> cities = <String>[].obs; // dealer location => userCity
  final RxList<String> bodyTypes = <String>[].obs;
  final RxList<String> fuelTypes = <String>[].obs;
  final RxList<String> transmissionTypes = <String>[].obs;

  // -------------------- UI SELECTED (inside sheet) --------------------
  final RxnString selectedMake = RxnString(null);
  final RxnString selectedModel = RxnString(null);
  final RxnString selectedVariant = RxnString(null);

  final RxnString selectedCity = RxnString(null);

  // Multi-select chips
  final RxList<String> selectedFuelTypes = <String>[].obs;
  final RxList<String> selectedTransmissions = <String>[].obs;
  final RxList<String> selectedBodyTypes = <String>[].obs;

  // Year of registration bucket slider: 0..3
  // 0=<1, 1=1-3, 2=3-5, 3=5+
  static const double minRegBucket = 0;
  static const double maxRegBucket = 3;
  final Rx<RangeValues> selectedRegBucket = const RangeValues(0, 3).obs;

  // Odometer bucket slider: 0..3
  // 0=<10k, 1=10-30k, 2=30-50k, 3=50k+
  static const double minOdoBucket = 0;
  static const double maxOdoBucket = 3;
  final Rx<RangeValues> selectedOdoBucket = const RangeValues(0, 3).obs;

  // -------------------- APPLIED SNAPSHOT (used by page list) --------------------
  final RxBool isApplied = false.obs;

  final RxnString appliedMake = RxnString(null);
  final RxnString appliedModel = RxnString(null);
  final RxnString appliedVariant = RxnString(null);
  final RxnString appliedCity = RxnString(null);

  final RxSet<String> appliedFuelTypes = <String>{}.obs;
  final RxSet<String> appliedTransmissions = <String>{}.obs;
  final RxSet<String> appliedBodyTypes = <String>{}.obs;

  final Rx<RangeValues> appliedRegBucket = const RangeValues(0, 3).obs;
  final Rx<RangeValues> appliedOdoBucket = const RangeValues(0, 3).obs;

  // -------------------- INIT OPTIONS --------------------
  /// Call this once when you have cars list (recommended)
  void setOptionsFromCars(List<CarsListModelForBuyACar> cars) {
    // Make list
    makes.assignAll(_unique(cars.map((c) => c.carMake)));

    // Cities
    cities.assignAll(_unique(cars.map((c) => c.dealerCity)));

    // Body types / fuel / transmission
    bodyTypes.assignAll(_unique(cars.map((c) => c.carBodyType)));
    fuelTypes.assignAll(_unique(cars.map((c) => c.carFuelType)));
    transmissionTypes.assignAll(_unique(cars.map((c) => c.carTransmission)));

    // Models by make
    final mapMakeModels = <String, Set<String>>{};
    final mapModelVariants = <String, Set<String>>{};

    for (final c in cars) {
      final mk = c.carMake.trim();
      final md = c.carModel.trim();
      final vr = c.carVariant.trim();
      if (mk.isEmpty) continue;

      mapMakeModels.putIfAbsent(mk, () => <String>{});
      if (md.isNotEmpty) mapMakeModels[mk]!.add(md);

      if (md.isNotEmpty) {
        mapModelVariants.putIfAbsent(md, () => <String>{});
        if (vr.isNotEmpty) mapModelVariants[md]!.add(vr);
      }
    }

    modelsByMake.assignAll({
      for (final e in mapMakeModels.entries) e.key: (e.value.toList()..sort()),
    });

    variantsByModel.assignAll({
      for (final e in mapModelVariants.entries)
        e.key: (e.value.toList()..sort()),
    });
  }

  /// Dummy options (use if you want to test without backend)
  void setDummyOptions() {
    makes.assignAll(['Toyota', 'Honda', 'Kia']);
    modelsByMake.assignAll({
      'Toyota': ['Corolla', 'Hilux'],
      'Honda': ['Civic'],
      'Kia': ['Sportage'],
    });
    variantsByModel.assignAll({
      'Corolla': ['XLi', 'GLi'],
      'Hilux': ['Revo'],
      'Civic': ['Oriel'],
      'Sportage': ['FWD'],
    });

    cities.assignAll(['Lahore', 'Karachi', 'Islamabad']);
    bodyTypes.assignAll(['Sedan', 'SUV', 'Pickup']);
    fuelTypes.assignAll(['Petrol', 'Diesel']);
    transmissionTypes.assignAll(['Manual', 'Automatic']);
  }

  // -------------------- CASCADING DROPDOWNS --------------------
  List<String> get modelsForSelectedMake {
    final mk = selectedMake.value;
    if (mk == null) return [];
    return modelsByMake[mk] ?? [];
  }

  List<String> get variantsForSelectedModel {
    final md = selectedModel.value;
    if (md == null) return [];
    return variantsByModel[md] ?? [];
  }

  void onMakeChanged(String? mk) {
    selectedMake.value = mk;
    selectedModel.value = null;
    selectedVariant.value = null;
  }

  void onModelChanged(String? md) {
    selectedModel.value = md;
    selectedVariant.value = null;
  }

  // -------------------- APPLY / RESET --------------------
  void applyFilters() {
    appliedMake.value = selectedMake.value;
    appliedModel.value = selectedModel.value;
    appliedVariant.value = selectedVariant.value;
    appliedCity.value = selectedCity.value;

    appliedFuelTypes
      ..clear()
      ..addAll(selectedFuelTypes);

    appliedTransmissions
      ..clear()
      ..addAll(selectedTransmissions);

    appliedBodyTypes
      ..clear()
      ..addAll(selectedBodyTypes);

    appliedRegBucket.value = selectedRegBucket.value;
    appliedOdoBucket.value = selectedOdoBucket.value;

    isApplied.value = true;
  }

  void resetFilters() {
    // selected (UI)
    selectedMake.value = null;
    selectedModel.value = null;
    selectedVariant.value = null;
    selectedCity.value = null;

    selectedFuelTypes.clear();
    selectedTransmissions.clear();
    selectedBodyTypes.clear();

    selectedRegBucket.value = const RangeValues(0, 3);
    selectedOdoBucket.value = const RangeValues(0, 3);

    // applied snapshot
    appliedMake.value = null;
    appliedModel.value = null;
    appliedVariant.value = null;
    appliedCity.value = null;

    appliedFuelTypes.clear();
    appliedTransmissions.clear();
    appliedBodyTypes.clear();

    appliedRegBucket.value = const RangeValues(0, 3);
    appliedOdoBucket.value = const RangeValues(0, 3);

    isApplied.value = false;
  }

  // -------------------- FILTER LOGIC (use this from BuyACarController) --------------------
  List<CarsListModelForBuyACar> filterCars({
    required List<CarsListModelForBuyACar> source,
    required String searchQueryLower,
  }) {
    final q = searchQueryLower.trim();

    // if not applied, still apply search only
    final useFilters = isApplied.value;

    return source.where((c) {
      // Search by car name (your requirement)
      if (q.isNotEmpty && !c.carName.toLowerCase().contains(q)) return false;

      if (!useFilters) return true;

      // Make / Model / Variant
      if (appliedMake.value != null && appliedMake.value!.isNotEmpty) {
        if (c.carMake != appliedMake.value!) return false;
      }
      if (appliedModel.value != null && appliedModel.value!.isNotEmpty) {
        if (c.carModel != appliedModel.value!) return false;
      }
      if (appliedVariant.value != null && appliedVariant.value!.isNotEmpty) {
        if (c.carVariant != appliedVariant.value!) return false;
      }

      // City
      if (appliedCity.value != null && appliedCity.value!.isNotEmpty) {
        if (c.dealerCity != appliedCity.value!) return false;
      }

      // Fuel / Transmission / Body (multi select)
      if (appliedFuelTypes.isNotEmpty &&
          !appliedFuelTypes.contains(c.carFuelType)) {
        return false;
      }
      if (appliedTransmissions.isNotEmpty &&
          !appliedTransmissions.contains(c.carTransmission)) {
        return false;
      }
      if (appliedBodyTypes.isNotEmpty &&
          !appliedBodyTypes.contains(c.carBodyType)) {
        return false;
      }

      // Year of registration bucket
      final regBucket = _regBucketIndex(c.carYear);
      final regMin = appliedRegBucket.value.start.round();
      final regMax = appliedRegBucket.value.end.round();
      if (regBucket < regMin || regBucket > regMax) return false;

      // Odometer bucket
      final odoBucket = _odoBucketIndex(c.carKms);
      final odoMin = appliedOdoBucket.value.start.round();
      final odoMax = appliedOdoBucket.value.end.round();
      if (odoBucket < odoMin || odoBucket > odoMax) return false;

      return true;
    }).toList();
  }

  // -------------------- BUCKET HELPERS --------------------
  int _regBucketIndex(String yearStr) {
    final year = int.tryParse(yearStr.trim()) ?? 0;
    if (year <= 0) return 3; // treat unknown as 5+ (old)

    final nowYear = DateTime.now().year;
    final age = (nowYear - year).clamp(0, 100);

    if (age < 1) return 0; // < 1
    if (age < 3) return 1; // 1 - 3
    if (age < 5) return 2; // 3 - 5
    return 3; // 5+
  }

  int _odoBucketIndex(String kmsStr) {
    final kms = _parseIntLoose(kmsStr);
    if (kms < 10000) return 0; // <10k
    if (kms < 30000) return 1; // 10-30k
    if (kms < 50000) return 2; // 30-50k
    return 3; // 50k+
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
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/Models/cars_list_model.dart';

class UsedCarsController extends GetxController {
  final RxBool isPageLoading = true.obs;

  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // main list for this screen
  final RxList<CarsListModel> myCars = <CarsListModel>[].obs;

  // Use this filtered list for UI
  final RxList<CarsListModel> filteredCars = <CarsListModel>[].obs;

  // this is what your UI should use: getxController.sortFilteredCarsList
  List<CarsListModel> get sortFilteredCarsList =>
      filteredCars.isEmpty ? myCars : filteredCars;

  @override
  void onInit() {
    super.onInit();
    _loadDummyCars();
  }

  void _loadDummyCars() async {
    // just to simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();

    final car1 = CarsListModel(
      id: 'car_1',
      appointmentId: 'APT-001',
      imageUrl:
          'https://imgcdnblog.carmudi.com.ph/wp-content/uploads/2020/08/21102247/ZW-Toyota-Innova-TRD-Sportivo_01.jpg',
      make: 'Toyota',
      model: 'Innova',
      variant: 'Crysta ZX',
      priceDiscovery: 1850000,
      yearMonthOfManufacture: DateTime(2020, 5, 1),
      odometerReadingInKms: 55000,
      ownerSerialNumber: 1,
      fuelType: 'Diesel',
      commentsOnTransmission: 'Automatic',
      roadTaxValidity: 'LTT',
      taxValidTill: DateTime(2030, 5, 1),
      registrationNumber: 'KA01AB1234',
      registeredRto: 'Bangalore',
      registrationState: 'Karnataka',
      registrationDate: DateTime(2020, 6, 15),
      inspectionLocation: 'Bangalore, Karnataka',
      isInspected: true,
      cubicCapacity: 2393,
      highestBid: 1750000.0.obs,
      auctionStartTime: now.subtract(const Duration(hours: 3)),
      auctionEndTime: now.add(const Duration(hours: 4)),
      auctionDuration: 7,
      auctionStatus: 'live',
      upcomingTime: 0,
      upcomingUntil: now,
      liveAt: now.subtract(const Duration(hours: 3)),
      oneClickPrice: 1900000,
      otobuyOffer: 1820000,
      soldAt: 0,
      registeredOwner: 'John Doe',
      registeredAddressAsPerRc: '123 Main St, Bangalore, Karnataka',
      contactNumber: '+91 98765 43210',
      emailAddress: 'john.doe@example.com',
      chassisNumber: 'ABC123DEF456',
      engineNumber: 'ENG123ABC456',
      imageUrls: const [],
    );

    final car2 = CarsListModel(
      id: 'car_2',
      appointmentId: 'APT-002',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWBmMVbnfUTmYSgVsGX_fFX6VE_vW62C0k1A&s',
      make: 'Honda',
      model: 'City',
      variant: 'ZX CVT',
      priceDiscovery: 950000,
      yearMonthOfManufacture: DateTime(2021, 3, 1),
      odometerReadingInKms: 28000,
      ownerSerialNumber: 1,
      fuelType: 'Petrol',
      commentsOnTransmission: 'Automatic',
      roadTaxValidity: '31/12/2031',
      taxValidTill: DateTime(2031, 12, 31),
      registrationNumber: 'MH02CD5678',
      registeredRto: 'Mumbai',
      registrationState: 'Maharashtra',
      registrationDate: DateTime(2021, 4, 20),
      inspectionLocation: 'Mumbai, Maharashtra',
      isInspected: true,
      cubicCapacity: 1498,
      highestBid: 920000.0.obs,
      auctionStartTime: now.subtract(const Duration(hours: 1)),
      auctionEndTime: now.add(const Duration(hours: 6)),
      auctionDuration: 7,
      auctionStatus: 'live',
      upcomingTime: 0,
      upcomingUntil: now,
      liveAt: now.subtract(const Duration(hours: 1)),
      oneClickPrice: 980000,
      otobuyOffer: 940000,
      soldAt: 0,
      registeredOwner: 'Jane Smith',
      registeredAddressAsPerRc: '456 Oak Ave, New Delhi, Delhi',
      contactNumber: '+91 98765 43211',
      emailAddress: 'jane.smith@example.com',
      chassisNumber: 'XYZ789ABC123',
      engineNumber: 'ENG789XYZ123',
      imageUrls: const [],
    );

    myCars.assignAll([car1, car2]);
    isPageLoading.value = false;
  }

  // Add these to your UsedCarsController
  RxString selectedSort = ''.obs;
  RxString selectedMake = ''.obs;
  RxString selectedModel = ''.obs;
  RxList<String> selectedTransmissions = <String>[].obs;
  RxList<String> selectedOwnerships = <String>[].obs;
  RxList<String> selectedFuelTypes = <String>[].obs;
  Rx<RangeValues> kmsRange = const RangeValues(0, 200000).obs;

  TextEditingController minRegYearController = TextEditingController();
  TextEditingController maxRegYearController = TextEditingController();
  TextEditingController minMfgYearController = TextEditingController();
  TextEditingController maxMfgYearController = TextEditingController();

  // Sample data - replace with your actual data
  List<String> get availableMakes => [
    'Maruti Suzuki',
    'Hyundai',
    'Honda',
    'Toyota',
    'Mahindra',
    'Tata',
  ];

  List<String> get availableModels => [
    'Swift',
    'Creta',
    'City',
    'Innova',
    'Scorpio',
    'Nexon',
  ];

  void clearAllFilters() {
    selectedSort.value = '';
    selectedMake.value = '';
    selectedModel.value = '';
    selectedTransmissions.clear();
    selectedOwnerships.clear();
    selectedFuelTypes.clear();
    kmsRange.value = const RangeValues(0, 200000);
    minRegYearController.clear();
    maxRegYearController.clear();
    minMfgYearController.clear();
    maxMfgYearController.clear();
    filteredCars.clear(); // Clear filtered results
  }

  int getAppliedFiltersCount() {
    int count = 0;
    if (selectedSort.value.isNotEmpty) count++;
    if (selectedMake.value.isNotEmpty) count++;
    if (selectedModel.value.isNotEmpty) count++;
    count += selectedTransmissions.length;
    count += selectedOwnerships.length;
    count += selectedFuelTypes.length;
    if (minRegYearController.text.isNotEmpty ||
        maxRegYearController.text.isNotEmpty)
      count++;
    if (minMfgYearController.text.isNotEmpty ||
        maxMfgYearController.text.isNotEmpty)
      count++;
    if (kmsRange.value.start > 0 || kmsRange.value.end < 200000) count++;
    return count;
  }

  void applyFilters() {
    // Apply filters to myCars and store result in filteredCars
    filteredCars.assignAll(_applyFiltersToCars(myCars));

    // Apply sorting if selected
    if (selectedSort.value.isNotEmpty) {
      _applySorting(filteredCars);
    }
  }

  List<CarsListModel> _applyFiltersToCars(List<CarsListModel> cars) {
    return cars.where((car) {
      // Make filter
      if (selectedMake.value.isNotEmpty &&
          !car.make.toLowerCase().contains(selectedMake.value.toLowerCase())) {
        return false;
      }

      // Model filter
      if (selectedModel.value.isNotEmpty &&
          !car.model.toLowerCase().contains(
            selectedModel.value.toLowerCase(),
          )) {
        return false;
      }

      // Transmission filter
      if (selectedTransmissions.isNotEmpty) {
        final carTransmission = car.commentsOnTransmission.toLowerCase();
        final hasMatchingTransmission = selectedTransmissions.any(
          (transmission) =>
              carTransmission.contains(transmission.toLowerCase()),
        );
        if (!hasMatchingTransmission) return false;
      }

      // Ownership filter
      if (selectedOwnerships.isNotEmpty) {
        final ownershipText = car.ownerSerialNumber == 1
            ? '1st Owner'
            : '${car.ownerSerialNumber} Owners';
        if (!selectedOwnerships.contains(ownershipText)) return false;
      }

      // Fuel type filter
      if (selectedFuelTypes.isNotEmpty &&
          !selectedFuelTypes.any(
            (fuel) => car.fuelType.toLowerCase().contains(fuel.toLowerCase()),
          )) {
        return false;
      }

      // Registration year filter
      if (minRegYearController.text.isNotEmpty ||
          maxRegYearController.text.isNotEmpty) {
        final regYear = car.registrationDate?.year ?? 0;
        final minYear = int.tryParse(minRegYearController.text) ?? 0;
        final maxYear = int.tryParse(maxRegYearController.text) ?? 9999;

        if (minRegYearController.text.isNotEmpty && regYear < minYear)
          return false;
        if (maxRegYearController.text.isNotEmpty && regYear > maxYear)
          return false;
      }

      // Manufacture year filter
      if (minMfgYearController.text.isNotEmpty ||
          maxMfgYearController.text.isNotEmpty) {
        final mfgYear = car.yearMonthOfManufacture?.year ?? 0;
        final minYear = int.tryParse(minMfgYearController.text) ?? 0;
        final maxYear = int.tryParse(maxMfgYearController.text) ?? 9999;

        if (minMfgYearController.text.isNotEmpty && mfgYear < minYear)
          return false;
        if (maxMfgYearController.text.isNotEmpty && mfgYear > maxYear)
          return false;
      }

      // KMs range filter
      final carKms = car.odometerReadingInKms;
      if (carKms < kmsRange.value.start || carKms > kmsRange.value.end) {
        return false;
      }

      return true;
    }).toList();
  }

  void _applySorting(List<CarsListModel> cars) {
    switch (selectedSort.value) {
      case 'newest':
        cars.sort(
          (a, b) => (b.registrationDate ?? DateTime(0)).compareTo(
            a.registrationDate ?? DateTime(0),
          ),
        );
        break;
      case 'price_low':
        cars.sort((a, b) => (a.priceDiscovery).compareTo(b.priceDiscovery));
        break;
      case 'price_high':
        cars.sort((a, b) => (b.priceDiscovery).compareTo(a.priceDiscovery));
        break;
      case 'year_new':
        cars.sort(
          (a, b) => (b.yearMonthOfManufacture ?? DateTime(0)).compareTo(
            a.yearMonthOfManufacture ?? DateTime(0),
          ),
        );
        break;
      case 'year_old':
        cars.sort(
          (a, b) => (a.yearMonthOfManufacture ?? DateTime(0)).compareTo(
            b.yearMonthOfManufacture ?? DateTime(0),
          ),
        );
        break;
      case 'km_low':
        cars.sort(
          (a, b) => (a.odometerReadingInKms).compareTo(b.odometerReadingInKms),
        );
        break;
      case 'km_high':
        cars.sort(
          (a, b) => (b.odometerReadingInKms).compareTo(a.odometerReadingInKms),
        );
        break;
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/Models/cars_list_model.dart';

class ManagerMyCarsController extends GetxController {
  final RxBool isPageLoading = true.obs;

  final TextEditingController searchController = TextEditingController();

  final RxString searchQuery = ''.obs;

  // main list for this screen
  final RxList<CarsListModel> myCars = <CarsListModel>[].obs;

  // this is what your UI should use: getxController.sortFilteredCarsList
  List<CarsListModel> get sortFilteredCarsList => myCars;

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
          'https://images.pexels.com/photos/112460/pexels-photo-112460.jpeg', // any test image
      make: 'Maruti Suzuki',
      model: 'Swift',
      variant: 'VXi',
      priceDiscovery: 550000,
      yearMonthOfManufacture: DateTime(2022, 1, 1),
      odometerReadingInKms: 42000,
      ownerSerialNumber: 1,
      fuelType: 'Petrol',
      commentsOnTransmission: 'Manual',
      roadTaxValidity: 'LTT',
      taxValidTill: DateTime(2032, 1, 1),
      registrationNumber: 'MH12AB1234',
      registeredRto: 'Pune',
      registrationState: 'Maharashtra',
      registrationDate: DateTime(2022, 3, 10),
      inspectionLocation: 'Pune, Maharashtra',
      isInspected: true,
      cubicCapacity: 1197,
      highestBid: 450000.0.obs,
      auctionStartTime: now.subtract(const Duration(hours: 1)),
      auctionEndTime: now.add(const Duration(hours: 2)),
      auctionDuration: 3,
      auctionStatus: 'live',
      upcomingTime: 0,
      upcomingUntil: now,
      liveAt: now.subtract(const Duration(hours: 1)),
      oneClickPrice: 565000,
      otobuyOffer: 540000,
      soldAt: 0,
      registeredOwner: 'John Doe',
      registeredAddressAsPerRc: '123 Main St, Pune, Maharashtra',
      contactNumber: '+91 98765 43210',
      emailAddress: 'john.doe@example.com',
      chassisNumber: 'ABC123XYZ789',
      engineNumber: 'ENG456XYZ789',
      imageUrls: const [],
    );

    final car2 = CarsListModel(
      id: 'car_2',
      appointmentId: 'APT-002',
      imageUrl:
          'https://images.pexels.com/photos/210019/pexels-photo-210019.jpeg',
      make: 'Hyundai',
      model: 'Creta',
      variant: 'SX(O) Diesel',
      priceDiscovery: 1450000,
      yearMonthOfManufacture: DateTime(2021, 7, 1),
      odometerReadingInKms: 31000,
      ownerSerialNumber: 2,
      fuelType: 'Diesel',
      commentsOnTransmission: 'Automatic',
      roadTaxValidity: '31/12/2031',
      taxValidTill: DateTime(2031, 12, 31),
      registrationNumber: 'DL8CAF5678',
      registeredRto: 'New Delhi',
      registrationState: 'Delhi',
      registrationDate: DateTime(2021, 8, 15),
      inspectionLocation: 'New Delhi',
      isInspected: true,
      cubicCapacity: 1493,
      highestBid: 1320000.0.obs,
      auctionStartTime: now.subtract(const Duration(hours: 2)),
      auctionEndTime: now.add(const Duration(hours: 1)),
      auctionDuration: 3,
      auctionStatus: 'live',
      upcomingTime: 0,
      upcomingUntil: now,
      liveAt: now.subtract(const Duration(hours: 2)),
      oneClickPrice: 1495000,
      otobuyOffer: 1400000,
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
}

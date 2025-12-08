import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/Models/cars_list_model.dart';
import 'package:otobix_customer_app/services/api_service.dart';
import 'package:otobix_customer_app/services/shared_prefs_helper.dart';
import 'package:otobix_customer_app/utils/app_constants.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';

class MyAuctionsController extends GetxController {
  final RxBool isPageLoading = true.obs;

  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  /// Main list for this screen (all cars)
  final RxList<CarsListModel> myAuctionCarsList = <CarsListModel>[].obs;

  /// List actually used by UI (after search/filter)
  final RxList<CarsListModel> filteredCarsList = <CarsListModel>[].obs;

  /// appointmentId -> “hh : mm : ss”
  final RxMap<String, String> remainingTimeByAppointmentId =
      <String, String>{}.obs;

  Timer? _countdownTimer;

  @override
  void onInit() {
    super.onInit();
    _fetchCarsList();

    // Whenever searchQuery changes, re-apply filter
    ever<String>(searchQuery, (_) => filterCars());
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    searchController.dispose();
    super.onClose();
  }

  // Fetch My Auction Cars
  Future<void> _fetchCarsList() async {
    isPageLoading.value = true;
    try {
      final String phoneNumber =
          await SharedPrefsHelper.getString(
            SharedPrefsHelper.userPhoneNumberKey,
          ) ??
          '';

      final response = await ApiService.post(
        endpoint: AppUrls.fetchMyAuctionCarsList,
        body: {'phoneNumber': phoneNumber},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final List<dynamic> dataList = decoded['data'] as List<dynamic>;

        final fetchedCarsList = dataList
            .map<CarsListModel>(
              (car) => CarsListModel.fromJson(
                id: car['id'] as String,
                data: Map<String, dynamic>.from(car as Map),
              ),
            )
            .toList();

        myAuctionCarsList.assignAll(fetchedCarsList);

        // Initialize filtered list (show all before user types anything)
        filterCars();

        // Start / reset countdowns based on new data
        _initCountdowns();
      } else {
        debugPrint('Failed to load cars: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error loading cars: $error');
    } finally {
      isPageLoading.value = false;
    }
  }

  /// Filters cars by appointmentId / registration number using `searchQuery`
  void filterCars() {
    final query = searchQuery.value.trim().toLowerCase();

    if (query.isEmpty) {
      filteredCarsList.assignAll(myAuctionCarsList);
      return;
    }

    final filtered = myAuctionCarsList.where((car) {
      final appointmentId = car.appointmentId.toLowerCase();
      final reg = car.registrationNumber.toLowerCase();
      return appointmentId.contains(query) || reg.contains(query);
    }).toList();

    filteredCarsList.assignAll(filtered);
  }

  // ----------------- COUNTDOWN LOGIC -----------------

  void _initCountdowns() {
    // Fill initial values
    final now = DateTime.now();
    for (final car in myAuctionCarsList) {
      final diff = car.auctionStatus == AppConstants.auctionStatuses.upcoming
          ? car.upcomingUntil!.difference(now)
          : car.auctionEndTime!.difference(now);
      remainingTimeByAppointmentId[car.appointmentId] = _formatDuration(diff);
    }

    // Restart timer
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _tickCountdowns();
    });
  }

  void _tickCountdowns() {
    final now = DateTime.now();

    for (final car in myAuctionCarsList) {
      final diff = car.auctionStatus == AppConstants.auctionStatuses.upcoming
          ? car.upcomingUntil!.difference(now)
          : car.auctionEndTime!.difference(now);
      remainingTimeByAppointmentId[car.appointmentId] = _formatDuration(diff);
    }
  }

  String _formatDuration(Duration diff) {
    var totalSeconds = diff.inSeconds;

    if (totalSeconds <= 0) {
      return '00 : 00 : 00'; // auction over
    }

    final hours = totalSeconds ~/ 3600;
    totalSeconds %= 3600;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    final h = hours.toString().padLeft(2, '0');
    final m = minutes.toString().padLeft(2, '0');
    final s = seconds.toString().padLeft(2, '0');

    return '${h}h : ${m}m : ${s}s';
  }
}

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:otobix_customer_app/Models/cars_list_model.dart';
// import 'package:otobix_customer_app/services/api_service.dart';
// import 'package:otobix_customer_app/services/shared_prefs_helper.dart';
// import 'package:otobix_customer_app/utils/app_urls.dart';

// class MyAuctionsController extends GetxController {
//   final RxBool isPageLoading = true.obs;

//   final TextEditingController searchController = TextEditingController();
//   final RxString searchQuery = ''.obs;

//   /// Main list for this screen (all cars)
//   final RxList<CarsListModel> myAuctionCarsList = <CarsListModel>[].obs;

//   /// List actually used by UI (after search/filter)
//   final RxList<CarsListModel> filteredCarsList = <CarsListModel>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _fetchCarsList();

//     // Whenever searchQuery changes, re-apply filter
//     ever<String>(searchQuery, (_) => filterCars());
//   }

//   // Fetch My Auction Cars
//   Future<void> _fetchCarsList() async {
//     isPageLoading.value = true;
//     try {
//       final String phoneNumber =
//           await SharedPrefsHelper.getString(
//             SharedPrefsHelper.userPhoneNumberKey,
//           ) ??
//           '';

//       final response = await ApiService.post(
//         endpoint: AppUrls.fetchMyAuctionCarsList,
//         // ⚠ make sure this key matches your backend: phoneNumber vs contactNumber
//         body: {'phoneNumber': phoneNumber},
//       );

//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body) as Map<String, dynamic>;
//         final List<dynamic> dataList = decoded['data'] as List<dynamic>;

//         final fetchedCarsList = dataList
//             .map<CarsListModel>(
//               (car) => CarsListModel.fromJson(
//                 id: car['id'] as String,
//                 data: Map<String, dynamic>.from(car as Map),
//               ),
//             )
//             .toList();

//         myAuctionCarsList.assignAll(fetchedCarsList);

//         // Initialize filtered list (show all before user types anything)
//         filterCars();
//       } else {
//         debugPrint('Failed to load cars: ${response.statusCode}');
//       }
//     } catch (error) {
//       debugPrint('Error loading cars: $error');
//     } finally {
//       isPageLoading.value = false;
//     }
//   }

//   /// Filters cars by name (make + model + variant) using `searchQuery`
//   void filterCars() {
//     final query = searchQuery.value.trim().toLowerCase();

//     if (query.isEmpty) {
//       // If search is empty, show all
//       filteredCarsList.assignAll(myAuctionCarsList);
//       return;
//     }

//     final filtered = myAuctionCarsList.where((car) {
//       // final name = '${car.make} ${car.model} ${car.variant}'
//       //     .toLowerCase()
//       //     .trim();
//       final appointmentId = car.appointmentId;

//       // you can also add registration number or other fields if you want:
//       final reg = (car.registrationNumber).toLowerCase();

//       return appointmentId.contains(query) || reg.contains(query);
//     }).toList();

//     filteredCarsList.assignAll(filtered);
//   }
// }

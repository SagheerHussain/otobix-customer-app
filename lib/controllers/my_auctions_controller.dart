import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/Models/cars_list_model.dart';
import 'package:otobix_customer_app/services/api_service.dart';
import 'package:otobix_customer_app/services/shared_prefs_helper.dart';
import 'package:otobix_customer_app/services/socket_service.dart';
import 'package:otobix_customer_app/utils/app_constants.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';
import 'package:otobix_customer_app/utils/socket_events.dart';

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
    fetchCarsList();
    _listenToAllCarSectionsInRealtime();

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
  Future<void> fetchCarsList() async {
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

  // Get auction status text
  String getAuctionStatus({required String auctionStatus}) {
    final String auctionStatusText =
        auctionStatus == AppConstants.auctionStatuses.upcoming
        ? 'Upcoming'
        : auctionStatus == AppConstants.auctionStatuses.live
        ? 'Live'
        : auctionStatus == AppConstants.auctionStatuses.liveAuctionEnded
        ? 'Auction Completed'
        : auctionStatus == AppConstants.auctionStatuses.otobuy
        ? 'OtoBuy'
        : auctionStatus == AppConstants.auctionStatuses.otobuyEnded
        ? 'Completed OtoBuy'
        : auctionStatus == AppConstants.auctionStatuses.sold
        ? 'Sold'
        : 'Removed';
    return auctionStatusText;
  }

  // ----------------- COUNTDOWN LOGIC -----------------
  void _initCountdowns() {
    _countdownTimer?.cancel();

    _tickCountdowns(); // fill once immediately

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _tickCountdowns();
    });
  }

  void _tickCountdowns() {
    final now = DateTime.now();

    for (final car in myAuctionCarsList) {
      Duration? diff;

      if (car.auctionStatus == AppConstants.auctionStatuses.upcoming) {
        final until = car.upcomingUntil;
        if (until != null) diff = until.difference(now);
      } else if (car.auctionStatus == AppConstants.auctionStatuses.live) {
        final end = car.auctionEndTime;
        if (end != null) diff = end.difference(now);
      } else {
        // For completed/sold/removed/etc you probably want no timer
        diff = null;
      }

      remainingTimeByAppointmentId[car.appointmentId] = diff == null
          ? '-- : -- : --'
          : _formatDuration(diff);
    }
  }

  // void _initCountdowns1() {
  //   // Fill initial values
  //   final now = DateTime.now();
  //   for (final car in myAuctionCarsList) {
  //     final diff = car.auctionStatus == AppConstants.auctionStatuses.upcoming
  //         ? car.upcomingUntil!.difference(now)
  //         : car.auctionEndTime!.difference(now);
  //     remainingTimeByAppointmentId[car.appointmentId] = _formatDuration(diff);
  //   }

  //   // Restart timer
  //   _countdownTimer?.cancel();
  //   _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
  //     _tickCountdowns();
  //   });
  // }

  // void _tickCountdowns1() {
  //   final now = DateTime.now();

  //   for (final car in myAuctionCarsList) {
  //     final diff = car.auctionStatus == AppConstants.auctionStatuses.upcoming
  //         ? car.upcomingUntil!.difference(now)
  //         : car.auctionEndTime!.difference(now);
  //     remainingTimeByAppointmentId[car.appointmentId] = _formatDuration(diff);
  //   }
  // }

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

  // Listen to all car sections realtime
  void _listenToAllCarSectionsInRealtime() {
    // Completed Auctions Section
    SocketService.instance.joinRoom(
      SocketEvents.auctionCompletedCarsSectionRoom,
    );
    SocketService.instance.on(SocketEvents.auctionCompletedCarsSectionUpdated, (
      data,
    ) async {
      final String id = '${data['id']}';

      // refresh only if this car already exists in my list
      final bool exists = myAuctionCarsList.any((car) => car.id == id);
      if (exists) {
        await fetchCarsList();
      }
    });

    // Otobuy Section
    SocketService.instance.joinRoom(SocketEvents.otobuyCarsSectionRoom);
    SocketService.instance.on(SocketEvents.otobuyCarsSectionUpdated, (
      data,
    ) async {
      final String id = '${data['id']}';

      // refresh only if this car already exists in my list
      final bool exists = myAuctionCarsList.any((car) => car.id == id);
      if (exists) {
        await fetchCarsList();
      }
    });
  }
}

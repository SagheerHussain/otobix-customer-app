import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/Models/cars_list_model.dart';
import 'package:otobix_customer_app/services/api_service.dart';
import 'package:otobix_customer_app/services/shared_prefs_helper.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';

class ClaimRsaCarsListController extends GetxController {
  final RxBool isPageLoading = true.obs;

  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  /// Main list for this screen (all cars)
  final RxList<CarsListModel> claimRsaCarsList = <CarsListModel>[].obs;

  /// List actually used by UI (after search/filter)
  final RxList<CarsListModel> filteredCarsList = <CarsListModel>[].obs;


  @override
  void onInit() {
    super.onInit();
    fetchCarsList();

    // Whenever searchQuery changes, re-apply filter
    ever<String>(searchQuery, (_) => filterCars());
  }

  @override
  void onClose() {
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
        endpoint: AppUrls.fetchInspectedCarsList,
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

        claimRsaCarsList.assignAll(fetchedCarsList);

        // Initialize filtered list (show all before user types anything)
        filterCars();

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
      filteredCarsList.assignAll(claimRsaCarsList);
      return;
    }

    final filtered = claimRsaCarsList.where((car) {
      final appointmentId = car.appointmentId.toLowerCase();
      final reg = car.registrationNumber.toLowerCase();
      return appointmentId.contains(query) || reg.contains(query);
    }).toList();

    filteredCarsList.assignAll(filtered);
  }


}

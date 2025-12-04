import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/Models/cars_list_model.dart';
import 'package:otobix_customer_app/services/api_service.dart';
import 'package:otobix_customer_app/services/shared_prefs_helper.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';

class MyAuctionsController extends GetxController {
  final RxBool isPageLoading = true.obs;

  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  /// Main list for this screen (all cars)
  final RxList<CarsListModel> myAuctionCarsList = <CarsListModel>[].obs;

  /// List actually used by UI (after search/filter)
  final RxList<CarsListModel> filteredCarsList = <CarsListModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchCarsList();

    // Whenever searchQuery changes, re-apply filter
    ever<String>(searchQuery, (_) => filterCars());
  }

  // Fetch My Auction Cars
  Future<void> _fetchCarsList() async {
    isPageLoading.value = true;
    try {
      final String contactNumber =
          await SharedPrefsHelper.getString(
            SharedPrefsHelper.userContactNumberKey,
          ) ??
          '';

      final response = await ApiService.post(
        endpoint: AppUrls.fetchMyAuctionCarsList,
        // ⚠ make sure this key matches your backend: phoneNumber vs contactNumber
        body: {'contactNumber': contactNumber},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final List<dynamic> dataList = decoded['data'] as List<dynamic>;

        debugPrint('cars loaded: ${dataList.toString()}');

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
      } else {
        debugPrint('Failed to load cars: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error loading cars: $error');
    } finally {
      isPageLoading.value = false;
    }
  }

  /// Filters cars by name (make + model + variant) using `searchQuery`
  void filterCars() {
    final query = searchQuery.value.trim().toLowerCase();

    if (query.isEmpty) {
      // If search is empty, show all
      filteredCarsList.assignAll(myAuctionCarsList);
      return;
    }

    final filtered = myAuctionCarsList.where((car) {
      final name = '${car.make} ${car.model} ${car.variant}'
          .toLowerCase()
          .trim();

      // you can also add registration number or other fields if you want:
      final reg = (car.registrationNumber).toLowerCase();

      return name.contains(query) || reg.contains(query);
    }).toList();

    filteredCarsList.assignAll(filtered);
  }
}

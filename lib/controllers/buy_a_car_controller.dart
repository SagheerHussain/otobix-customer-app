import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/Models/cars_list_model_for_buy_a_car.dart';
import 'package:otobix_customer_app/services/api_service.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';

class BuyACarController extends GetxController {
  final RxBool isPageLoading = true.obs;

  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // main list
  final RxList<CarsListModelForBuyACar> carsList =
      <CarsListModelForBuyACar>[].obs;

  // search filtered list
  final RxList<CarsListModelForBuyACar> searchFilteredCarsList =
      <CarsListModelForBuyACar>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCarsList();
    // Listen to search query changes
    ever(searchQuery, (_) => _filterCarsList());
  }

  // Fetch 10 Random Cars
  Future<void> fetchCarsList() async {
    isPageLoading.value = true;

    try {
      final response = await ApiService.get(
        endpoint: AppUrls.fetch10RandomCarsList,
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);

        final data = decodedResponse['data'];
        if (data is! List) {
          debugPrint('Invalid data format: data is not a list');
          carsList.clear();
          searchFilteredCarsList.clear();
          return;
        }

        final List<CarsListModelForBuyACar> fetchedList = data
            .whereType<Map<String, dynamic>>() // only valid maps
            .map((e) => CarsListModelForBuyACar.fromJson(e))
            .toList();

        carsList.assignAll(fetchedList);
        searchFilteredCarsList.assignAll(fetchedList);
      } else {
        debugPrint('Failed to load cars: ${response.statusCode}');
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed',
          subtitle: 'Failed to load cars',
          type: ToastType.error,
        );
        carsList.clear();
        searchFilteredCarsList.clear();
      }
    } catch (error) {
      debugPrint('Error loading cars: $error');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error loading cars',
        type: ToastType.error,
      );
      carsList.clear();
      searchFilteredCarsList.clear();
    } finally {
      isPageLoading.value = false;
    }
  }

  // Filter cars based on search query (search only by carName)
  void _filterCarsList() {
    if (searchQuery.value.isEmpty) {
      searchFilteredCarsList.assignAll(carsList);
    } else {
      final filtered = carsList.where((car) {
        return car.carName.toLowerCase().contains(searchQuery.value);
      }).toList();
      searchFilteredCarsList.assignAll(filtered);
    }
  }

  // Clear search
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

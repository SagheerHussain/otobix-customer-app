import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/Models/cars_list_model_for_buy_a_car.dart';
import 'package:otobix_customer_app/services/api_service.dart';
import 'package:otobix_customer_app/services/shared_prefs_helper.dart';
import 'package:otobix_customer_app/utils/app_constants.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';

class BuyACarController extends GetxController {
  final RxBool isPageLoading = false.obs;
  final RxBool isSaveInterestedBuyerLoading = false.obs;

  // NEW: load more state
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;

  // NEW: pagination cursor + random startPath
  String? cursorPath;
  String? startPath;

  // NEW: scroll controller
  final ScrollController scrollController = ScrollController();

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
    // fetchCarsList();
    // // Listen to search query changes
    // ever(searchQuery, (_) => _filterCarsList());

    fetchCarsFirstPage();

    ever(searchQuery, (_) => _applySearchFilter());

    // Listen to scroll to load more
    scrollController.addListener(() {
      if (!hasMore.value) return;
      if (isPageLoading.value || isLoadingMore.value) return;

      // when near bottom (200px)
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        fetchCarsNextPage();
      }
    });
  }

  Future<void> fetchCarsFirstPage() async {
    isPageLoading.value = true;

    // reset pagination
    cursorPath = null;
    startPath = null;
    hasMore.value = true;

    try {
      final endpoint = "${AppUrls.fetchCarsListForBuyACar}?limit=10";

      final response = await ApiService.get(endpoint: endpoint);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final List data = decoded['data'] ?? [];
        cursorPath = decoded['cursor'];
        startPath = decoded['startPath'];
        hasMore.value = decoded['hasMore'] == true;

        final fetched = data
            .whereType<Map<String, dynamic>>()
            .map((e) => CarsListModelForBuyACar.fromJson(e))
            .toList();

        carsList.assignAll(fetched);
        _applySearchFilter();
      } else {
        carsList.clear();
        searchFilteredCarsList.clear();
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed',
          subtitle: 'Failed to load cars',
          type: ToastType.error,
        );
      }
    } catch (e) {
      carsList.clear();
      searchFilteredCarsList.clear();
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error loading cars',
        type: ToastType.error,
      );
    } finally {
      isPageLoading.value = false;
    }
  }

  Future<void> fetchCarsNextPage() async {
    if (!hasMore.value) return;
    if (cursorPath == null || startPath == null) return;

    isLoadingMore.value = true;

    try {
      final endpoint =
          "${AppUrls.fetchCarsListForBuyACar}?limit=10&cursor=$cursorPath&startPath=$startPath";

      final response = await ApiService.get(endpoint: endpoint);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final List data = decoded['data'] ?? [];
        cursorPath = decoded['cursor'];
        hasMore.value = decoded['hasMore'] == true;

        final fetched = data
            .whereType<Map<String, dynamic>>()
            .map((e) => CarsListModelForBuyACar.fromJson(e))
            .toList();

        if (fetched.isNotEmpty) {
          // Append (no duplicates due to cursor pagination)
          carsList.addAll(fetched);
          _applySearchFilter();
        }
      }
    } catch (e) {
      // keep silent (don’t disturb user on scroll)
    } finally {
      isLoadingMore.value = false;
    }
  }

  void _applySearchFilter() {
    if (searchQuery.value.isEmpty) {
      searchFilteredCarsList.assignAll(carsList);
    } else {
      final q = searchQuery.value;
      final filtered = carsList.where((car) {
        return car.carName.toLowerCase().contains(q);
      }).toList();
      searchFilteredCarsList.assignAll(filtered);
    }
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

  // Save interested buyer
  Future<void> saveInterestedBuyer({
    required CarsListModelForBuyACar car,
    required String activityType,
  }) async {
    if (isUserClickedOnInterested(activityType)) {
      isSaveInterestedBuyerLoading.value = true;
    }

    try {
      final String userId =
          await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ?? '';

      final CarsListModelForBuyACar requestBody = CarsListModelForBuyACar(
        userDocId: car.userDocId,
        userPhoneNumber: car.userPhoneNumber,
        userRole: car.userRole,
        userCity: car.userCity,
        dealerName: car.dealerName,
        userAssignedPhone: car.userAssignedPhone,
        userState: car.userState,
        userId: car.userId,
        userEmail: car.userEmail,
        userName: car.userName,
        carDocId: car.carDocId,
        carContact: car.carContact,
        carName: car.carName,
        carDesc: car.carDesc,
        carPrice: car.carPrice,
        carYear: car.carYear,
        carTaxValidity: car.carTaxValidity,
        carOwnershipSerialNo: car.carOwnershipSerialNo,
        carMake: car.carMake,
        carModel: car.carModel,
        carVariant: car.carVariant,
        carKms: car.carKms,
        carTransmission: car.carTransmission,
        carFuelType: car.carFuelType,
        bodyType: car.bodyType,
        imageUrls: car.imageUrls,
        activityType: activityType,
        interestedBuyerId: userId,
      );

      final response = await ApiService.post(
        endpoint: AppUrls.saveInterestedBuyer,
        body: requestBody.toJson(),
      );

      if (response.statusCode == 200) {
        if (isUserClickedOnInterested(activityType)) {
          Get.back();
          _showSuccessDialog();
        }
      } else {
        debugPrint('Failed to save interested buyer: ${response.statusCode}');
        if (isUserClickedOnInterested(activityType)) {
          ToastWidget.show(
            context: Get.context!,
            title: 'Failed',
            subtitle: 'Failed to save interested buyer',
            type: ToastType.error,
          );
        }
      }
    } catch (error) {
      debugPrint('Error saving interested buyer: $error');
      if (isUserClickedOnInterested(activityType)) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Error saving interested buyer',
          type: ToastType.error,
        );
      }
    } finally {
      if (isUserClickedOnInterested(activityType)) {
        isSaveInterestedBuyerLoading.value = false;
      }
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

  // Check if user clicked on interested button
  bool isUserClickedOnInterested(String activityType) {
    return activityType == AppConstants.buyACarActivityType.interested;
  }

  void _showSuccessDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Icon(Icons.check_circle, color: Colors.green, size: 50),
        content: const Text(
          'Interest submitted successfully!\nOur team will contact you soon.',
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: ButtonWidget(
              text: 'OK',
              height: 35,
              fontSize: 12,
              isLoading: false.obs,
              onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose(); // NEW
    super.onClose();
  }
}

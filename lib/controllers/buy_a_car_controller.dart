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

import 'buy_a_car_filters_controller.dart';

enum BuyACarMode { normal, searching, filtering }

class BuyACarController extends GetxController {
  final RxBool isPageLoading = false.obs;
  final RxBool isSaveInterestedBuyerLoading = false.obs;

  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;

  // Mode: search and filters are mutually exclusive
  final Rx<BuyACarMode> mode = BuyACarMode.normal.obs;

  // Pagination
  int pageNumber = 0; // start from 0 (random page)
  String? cursorDocId; // sequential cursor
  final List<String> excludedIds = []; // first random 10 ids only

  final ScrollController scrollController = ScrollController();

  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // Raw fetched list (what you got from API)
  final RxList<CarsListModelForBuyACar> carsList =
      <CarsListModelForBuyACar>[].obs;

  // ✅ UI should render ONLY this list
  final RxList<CarsListModelForBuyACar> visibleCars =
      <CarsListModelForBuyACar>[].obs;

  // Pagination
  final int limit = 10;

  late final BuyACarFiltersController filtersController;

  @override
  void onInit() {
    super.onInit();

    // Must already be created in BuyACarPage (Get.put(permanent:true))
    filtersController = Get.find<BuyACarFiltersController>();

    fetchCars(loadMore: false);
    scrollController.addListener(_onScrollLoadMore);
  }

  void _onScrollLoadMore() {
    // ✅ Disable pagination in search/filter mode
    if (mode.value != BuyACarMode.normal) return;

    if (!hasMore.value) return;
    if (isPageLoading.value || isLoadingMore.value) return;

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      fetchCars(loadMore: true);
    }
  }

  /// Single fetch function
  /// - loadMore=false => first page (reset)
  /// - loadMore=true  => next page (append)
  Future<void> fetchCars({required bool loadMore}) async {
    if (!hasMore.value && loadMore) return;

    if (loadMore) {
      isLoadingMore.value = true;
    } else {
      isPageLoading.value = true;

      // Reset pagination
      pageNumber = 0;
      cursorDocId = null;
      excludedIds.clear();
      hasMore.value = true;

      carsList.clear();
      visibleCars.clear();
    }

    try {
      // ✅ For NOW you still use the same endpoint
      // Later you can switch endpoint based on mode:
      // - if (mode.value == BuyACarMode.searching) => search endpoint
      // - if (mode.value == BuyACarMode.filtering) => filter endpoint
      String endpoint =
          "${AppUrls.fetch10RandomCarsList}?limit=$limit&pageNumber=$pageNumber";

      if (pageNumber >= 1 && cursorDocId != null && cursorDocId!.isNotEmpty) {
        endpoint += "&cursorDocId=$cursorDocId";
      }

      if (excludedIds.isNotEmpty) {
        endpoint += "&excludedIds=${excludedIds.join(",")}";
      }

      final response = await ApiService.get(endpoint: endpoint);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final List raw = decoded['carsList'] ?? [];
        hasMore.value = decoded['hasMore'] == true || raw.length == limit;

        final List rawExcluded = decoded['excludedIds'] ?? [];
        if (pageNumber == 0 && excludedIds.isEmpty && rawExcluded.isNotEmpty) {
          excludedIds.addAll(rawExcluded.map((e) => e.toString()));
        }

        final nextCursor = decoded['nextCursorDocId'];
        if (nextCursor != null) {
          cursorDocId = nextCursor.toString();
        }

        final fetched = raw
            .whereType<Map<String, dynamic>>()
            .map((e) => CarsListModelForBuyACar.fromJson(e))
            .toList();

        if (fetched.isNotEmpty) {
          carsList.addAll(fetched);

          // Update filter options from incoming cars (optional)
          filtersController.setOptionsFromCars(carsList);

          // Apply current mode (normal/search/filter) on visible list
          _applyModeToVisibleCars();

          pageNumber += 1;
        } else {
          hasMore.value = false;
        }
      } else {
        if (!loadMore) {
          ToastWidget.show(
            context: Get.context!,
            title: 'Failed',
            subtitle: 'Failed to load cars',
            type: ToastType.error,
          );
        }
      }
    } catch (_) {
      if (!loadMore) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Error loading cars',
          type: ToastType.error,
        );
      }
    } finally {
      if (loadMore) {
        isLoadingMore.value = false;
      } else {
        isPageLoading.value = false;
      }
    }
  }

  // =========================
  // INTENTS (separate modes)
  // =========================

  /// Called from TextField onChanged
  void onSearchChanged(String value) {
    final q = value.trim().toLowerCase();

    if (q.isEmpty) {
      clearSearch();
      return;
    }

    // Search clears filters
    _resetFiltersSilently();

    mode.value = BuyACarMode.searching;
    searchQuery.value = q;

    // For NOW: local search on fetched cars
    _applyModeToVisibleCars();

    // LATER: call server search
    // fetchCars(loadMore: false);
  }

  /// Called when user taps Apply in filter sheet (after fc.applyFilters())
  void onApplyFiltersPressed() {
    // Filters clear search
    _clearSearchSilently();

    mode.value = BuyACarMode.filtering;

    // For NOW: local filter on fetched cars
    _applyModeToVisibleCars();

    // LATER: call server filter
    // fetchCars(loadMore: false);
  }

  /// Called when user taps Reset in filter sheet
  void onResetFiltersPressed() {
    filtersController.resetFilters();
    mode.value = BuyACarMode.normal;
    _applyModeToVisibleCars();
    fetchCars(loadMore: false); // ✅ refresh normal list
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    mode.value = BuyACarMode.normal;
    _applyModeToVisibleCars();
    fetchCars(loadMore: false); // ✅ refresh normal list
  }

  void _applyModeToVisibleCars() {
    if (mode.value == BuyACarMode.searching) {
      final q = searchQuery.value.trim();
      if (q.isEmpty) {
        visibleCars.assignAll(carsList);
        return;
      }
      final filtered = carsList.where((c) {
        return c.carName.toLowerCase().contains(q);
      }).toList();
      visibleCars.assignAll(filtered);
      return;
    }

    if (mode.value == BuyACarMode.filtering) {
      final filtered = filtersController.filterCars(
        source: carsList,
        searchQueryLower: '', // search is cleared in filter mode
      );
      visibleCars.assignAll(filtered);
      return;
    }

    visibleCars.assignAll(carsList);
  }

  void _clearSearchSilently() {
    searchController.clear();
    searchQuery.value = '';
  }

  void _resetFiltersSilently() {
    filtersController.resetFilters();
  }

  // =========================
  // Interested Buyer
  // =========================

  bool isUserClickedOnInterested(String activityType) {
    return activityType == AppConstants.buyACarActivityType.interested;
  }

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
        dealerDocId: car.dealerDocId,
        dealerPhoneNumber: car.dealerPhoneNumber,
        dealerRole: car.dealerRole,
        dealerCity: car.dealerCity,
        dealerName: car.dealerName,
        dealerAssignedPhone: car.dealerAssignedPhone,
        dealerState: car.dealerState,
        dealerUserId: car.dealerUserId,
        dealerEmail: car.dealerEmail,
        dealerUserName: car.dealerUserName,
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
        carBodyType: car.carBodyType,
        carImageUrls: car.carImageUrls,
        isDeleted: car.isDeleted,
        scrapedAt: car.scrapedAt,
        uploadedAt: car.uploadedAt,
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
        if (isUserClickedOnInterested(activityType)) {
          ToastWidget.show(
            context: Get.context!,
            title: 'Failed',
            subtitle: 'Failed to save interested buyer',
            type: ToastType.error,
          );
        }
      }
    } catch (_) {
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

  /// Called when user submits search (keyboard search button)
  Future<void> onSearchSubmitted(String value) async {
    final q = value.trim();
    if (q.isEmpty) {
      clearSearch();
      return;
    }

    // ✅ Search clears filters
    _resetFiltersSilently();

    // ✅ switch mode
    mode.value = BuyACarMode.searching;

    // ✅ set query (lowercase optional depending on backend)
    searchQuery.value = q.toLowerCase();

    // ✅ clear old lists (important)
    _clearListsAndStopPagination();

    // ✅ hit search API and replace list
    await _fetchCarsFromSearchApi(query: searchQuery.value);
  }

  /// Called when user taps Apply in filter sheet
  Future<void> onApplyFiltersPressedServer() async {
    // ✅ clear search when filtering
    _clearSearchSilently();

    // ✅ switch mode
    mode.value = BuyACarMode.filtering;

    // ✅ clear old lists (important)
    _clearListsAndStopPagination();

    // ✅ build payload and hit filter API
    final payload = filtersController.buildAppliedFilterPayload();
    await _fetchCarsFromFilterApi(payload: payload);
  }

  void _clearListsAndStopPagination() {
    // stop normal pagination state
    hasMore.value = false;
    isLoadingMore.value = false;

    // clear both lists
    carsList.clear();
    visibleCars.clear();

    // reset random pagination state (not used in search/filter, but safe)
    pageNumber = 0;
    cursorDocId = null;
    excludedIds.clear();
  }

  Future<void> _fetchCarsFromSearchApi({required String query}) async {
    isPageLoading.value = true;
    try {
      final response = await ApiService.post(
        endpoint: AppUrls.searchCarsInBuyACar,
        body: {
          "q": query,
          // "limit": limit,
          // if later you want pagination for search:
          // "cursorDocId": cursorDocId,
        },
      );

      if (response.statusCode != 200) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed',
          subtitle: 'Search failed',
          type: ToastType.error,
        );
        return;
      }

      final decoded = jsonDecode(response.body);
      final List raw = decoded['carsList'] ?? [];

      final fetched = raw
          .whereType<Map<String, dynamic>>()
          .map((e) => CarsListModelForBuyACar.fromJson(e))
          .toList();

      // ✅ replace list with server results
      carsList.assignAll(fetched);
      visibleCars.assignAll(fetched);

      // (optional) update filter options from results
      // filtersController.setOptionsFromCars(carsList);

      // Keep pagination OFF in search mode (as per your requirement)
      hasMore.value = false;
    } catch (_) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error searching cars',
        type: ToastType.error,
      );
    } finally {
      isPageLoading.value = false;
    }
  }

  Future<void> _fetchCarsFromFilterApi({
    required Map<String, dynamic> payload,
  }) async {
    isPageLoading.value = true;
    try {
      final response = await ApiService.post(
        endpoint: AppUrls.filterCarsInBuyACar,
        body: {
          ...payload,
          // "limit": limit,
          // if later you want pagination for filter:
          // "cursorDocId": cursorDocId,
        },
      );

      if (response.statusCode != 200) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed',
          subtitle: 'Filter failed',
          type: ToastType.error,
        );
        return;
      }

      final decoded = jsonDecode(response.body);
      final List raw = decoded['carsList'] ?? [];

      final fetched = raw
          .whereType<Map<String, dynamic>>()
          .map((e) => CarsListModelForBuyACar.fromJson(e))
          .toList();

      // ✅ replace list with server results
      carsList.assignAll(fetched);
      visibleCars.assignAll(fetched);

      // Keep pagination OFF in filter mode (as per your requirement)
      hasMore.value = false;
    } catch (_) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error filtering cars',
        type: ToastType.error,
      );
    } finally {
      isPageLoading.value = false;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.removeListener(_onScrollLoadMore);
    scrollController.dispose();
    super.onClose();
  }
}

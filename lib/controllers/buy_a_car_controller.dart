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

  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;

  // Pagination (NEW)
  int pageNumber = 0; // start from 0 (random page)
  String? cursorDocId; // sequential cursor
  final List<String> excludedIds = []; // first random 10 ids only

  final ScrollController scrollController = ScrollController();

  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  final RxList<CarsListModelForBuyACar> carsList =
      <CarsListModelForBuyACar>[].obs;
  final RxList<CarsListModelForBuyACar> searchFilteredCarsList =
      <CarsListModelForBuyACar>[].obs;

  // Pagination
  final int limit = 10;

  @override
  void onInit() {
    super.onInit();

    ever(searchQuery, (_) => _applySearchFilter());

    fetchCars(loadMore: false);

    scrollController.addListener(_onScrollLoadMore);
  }

  void _onScrollLoadMore() {
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
      pageNumber = 0; // first hit should be random
      cursorDocId = null;
      excludedIds.clear();
      hasMore.value = true;
      carsList.clear();
      searchFilteredCarsList.clear();
    }

    try {
      // final endpoint =
      //     "${AppUrls.fetch10RandomCarsList}?limit=$limit&pageNumber=$pageNumber";

      String endpoint =
          "${AppUrls.fetch10RandomCarsList}?limit=$limit&pageNumber=$pageNumber";

      // For sequential pages (pageNumber >= 1), send cursor if available
      if (pageNumber >= 1 && cursorDocId != null && cursorDocId!.isNotEmpty) {
        endpoint += "&cursorDocId=$cursorDocId";
      }

      // Send excludedIds (only after first random call has saved them)
      // If your ApiService.get supports query params only:
      if (excludedIds.isNotEmpty) {
        endpoint += "&excludedIds=${excludedIds.join(",")}";
      }

      final response = await ApiService.get(endpoint: endpoint);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // Your API returns `carsList`
        final List raw = decoded['carsList'] ?? [];

        // Read hasMore safely (if missing, fallback to raw length == limit)
        hasMore.value = decoded['hasMore'] == true || raw.length == limit;

        // Save excludedIds only once (from first random response)
        final List rawExcluded = decoded['excludedIds'] ?? [];
        if (pageNumber == 0 && excludedIds.isEmpty && rawExcluded.isNotEmpty) {
          excludedIds.addAll(rawExcluded.map((e) => e.toString()));
        }

        // Save cursor for next sequential request
        final nextCursor = decoded['nextCursorDocId'];
        if (nextCursor != null) {
          cursorDocId = nextCursor.toString();
        }

        final fetched = raw
            .whereType<Map<String, dynamic>>()
            .map((e) => CarsListModelForBuyACar.fromJson(e))
            .toList();

        // debugPrint('Response: ${decoded.toString()}');

        if (fetched.isNotEmpty) {
          if (loadMore) {
            carsList.addAll(fetched);
          } else {
            carsList.assignAll(fetched);
          }

          _applySearchFilter();

          // Move to next page only when we got some data
          pageNumber += 1;
        } else {
          // No data -> no more pages
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

  void _applySearchFilter() {
    final q = searchQuery.value.trim().toLowerCase();

    if (q.isEmpty) {
      searchFilteredCarsList.assignAll(carsList);
      return;
    }

    final filtered = carsList.where((car) {
      return car.carName.toLowerCase().contains(q);
    }).toList();

    searchFilteredCarsList.assignAll(filtered);
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

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

  @override
  void onClose() {
    searchController.dispose();
    scrollController.removeListener(_onScrollLoadMore);
    scrollController.dispose();
    super.onClose();
  }
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:otobix_customer_app/Models/cars_list_model_for_buy_a_car.dart';
// import 'package:otobix_customer_app/services/api_service.dart';
// import 'package:otobix_customer_app/services/shared_prefs_helper.dart';
// import 'package:otobix_customer_app/utils/app_constants.dart';
// import 'package:otobix_customer_app/utils/app_urls.dart';
// import 'package:otobix_customer_app/widgets/button_widget.dart';
// import 'package:otobix_customer_app/widgets/toast_widget.dart';

// class BuyACarController extends GetxController {
//   final RxBool isPageLoading = false.obs;
//   final RxBool isSaveInterestedBuyerLoading = false.obs;

//   // NEW: load more state
//   final RxBool isLoadingMore = false.obs;
//   final RxBool hasMore = true.obs;

//   // NEW: pagination cursor + random startPath
//   String? cursorPath;
//   String? startPath;

//   // NEW: scroll controller
//   final ScrollController scrollController = ScrollController();

//   final TextEditingController searchController = TextEditingController();
//   final RxString searchQuery = ''.obs;

//   // main list
//   final RxList<CarsListModelForBuyACar> carsList =
//       <CarsListModelForBuyACar>[].obs;

//   // search filtered list
//   final RxList<CarsListModelForBuyACar> searchFilteredCarsList =
//       <CarsListModelForBuyACar>[].obs;

//   @override
//   void onInit() {
//     super.onInit();

//     // // Listen to search query changes
//     // ever(searchQuery, (_) => _filterCarsList());

//     fetchCarsFirstPage();

//     ever(searchQuery, (_) => _applySearchFilter());

//     // Listen to scroll to load more
//     scrollController.addListener(() {
//       if (!hasMore.value) return;
//       if (isPageLoading.value || isLoadingMore.value) return;

//       // when near bottom (200px)
//       if (scrollController.position.pixels >=
//           scrollController.position.maxScrollExtent - 200) {
//         fetchCarsNextPage();
//       }
//     });
//   }

//   Future<void> fetchCarsFirstPage() async {
//     isPageLoading.value = true;

//     // reset pagination
//     cursorPath = null;
//     startPath = null;
//     hasMore.value = true;

//     try {
//       final endpoint = "${AppUrls.fetch10RandomCarsList}?limit=10";

//       final response = await ApiService.get(endpoint: endpoint);

//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);

//         final List data = decoded['data'] ?? [];
//         cursorPath = decoded['cursor'];
//         startPath = decoded['startPath'];
//         hasMore.value = decoded['hasMore'] == true;

//         final fetched = data
//             .whereType<Map<String, dynamic>>()
//             .map((e) => CarsListModelForBuyACar.fromJson(e))
//             .toList();

//         carsList.assignAll(fetched);
//         _applySearchFilter();
//       } else {
//         carsList.clear();
//         searchFilteredCarsList.clear();
//         ToastWidget.show(
//           context: Get.context!,
//           title: 'Failed',
//           subtitle: 'Failed to load cars',
//           type: ToastType.error,
//         );
//       }
//     } catch (e) {
//       carsList.clear();
//       searchFilteredCarsList.clear();
//       ToastWidget.show(
//         context: Get.context!,
//         title: 'Error',
//         subtitle: 'Error loading cars',
//         type: ToastType.error,
//       );
//     } finally {
//       isPageLoading.value = false;
//     }
//   }

//   Future<void> fetchCarsNextPage() async {
//     if (!hasMore.value) return;
//     if (cursorPath == null || startPath == null) return;

//     isLoadingMore.value = true;

//     try {
//       final endpoint =
//           "${AppUrls.fetch10RandomCarsList}?limit=10&cursor=$cursorPath&startPath=$startPath";

//       final response = await ApiService.get(endpoint: endpoint);

//       debugPrint(jsonDecode(response.body));

//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);

//         final List data = decoded['data'] ?? [];
//         cursorPath = decoded['cursor'];
//         hasMore.value = decoded['hasMore'] == true;

//         final fetched = data
//             .whereType<Map<String, dynamic>>()
//             .map((e) => CarsListModelForBuyACar.fromJson(e))
//             .toList();

//         if (fetched.isNotEmpty) {
//           // Append (no duplicates due to cursor pagination)
//           carsList.addAll(fetched);
//           _applySearchFilter();
//         }
//       }
//     } catch (e) {
//       // keep silent (don’t disturb user on scroll)
//     } finally {
//       isLoadingMore.value = false;
//     }
//   }

//   void _applySearchFilter() {
//     if (searchQuery.value.isEmpty) {
//       searchFilteredCarsList.assignAll(carsList);
//     } else {
//       final q = searchQuery.value;
//       final filtered = carsList.where((car) {
//         return car.carName.toLowerCase().contains(q);
//       }).toList();
//       searchFilteredCarsList.assignAll(filtered);
//     }
//   }

//   // Save interested buyer
//   Future<void> saveInterestedBuyer({
//     required CarsListModelForBuyACar car,
//     required String activityType,
//   }) async {
//     if (isUserClickedOnInterested(activityType)) {
//       isSaveInterestedBuyerLoading.value = true;
//     }

//     try {
//       final String userId =
//           await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ?? '';

//       final CarsListModelForBuyACar requestBody = CarsListModelForBuyACar(
//         dealerDocId: car.dealerDocId,
//         dealerPhoneNumber: car.dealerPhoneNumber,
//         dealerRole: car.dealerRole,
//         dealerCity: car.dealerCity,
//         dealerName: car.dealerName,
//         dealerAssignedPhone: car.dealerAssignedPhone,
//         dealerState: car.dealerState,
//         dealerUserId: car.dealerUserId,
//         dealerEmail: car.dealerEmail,
//         dealerUserName: car.dealerUserName,

//         carDocId: car.carDocId,
//         carContact: car.carContact,
//         carName: car.carName,
//         carDesc: car.carDesc,
//         carPrice: car.carPrice,
//         carYear: car.carYear,
//         carTaxValidity: car.carTaxValidity,
//         carOwnershipSerialNo: car.carOwnershipSerialNo,
//         carMake: car.carMake,
//         carModel: car.carModel,
//         carVariant: car.carVariant,
//         carKms: car.carKms,
//         carTransmission: car.carTransmission,
//         carFuelType: car.carFuelType,
//         carBodyType: car.carBodyType,
//         carImageUrls: car.carImageUrls,

//         isDeleted: car.isDeleted,
//         scrapedAt: car.scrapedAt,
//         uploadedAt: car.uploadedAt,

//         activityType: activityType,
//         interestedBuyerId: userId,
//       );

//       final response = await ApiService.post(
//         endpoint: AppUrls.saveInterestedBuyer,
//         body: requestBody.toJson(),
//       );

//       if (response.statusCode == 200) {
//         if (isUserClickedOnInterested(activityType)) {
//           Get.back();
//           _showSuccessDialog();
//         }
//       } else {
//         debugPrint('Failed to save interested buyer: ${response.statusCode}');
//         if (isUserClickedOnInterested(activityType)) {
//           ToastWidget.show(
//             context: Get.context!,
//             title: 'Failed',
//             subtitle: 'Failed to save interested buyer',
//             type: ToastType.error,
//           );
//         }
//       }
//     } catch (error) {
//       debugPrint('Error saving interested buyer: $error');
//       if (isUserClickedOnInterested(activityType)) {
//         ToastWidget.show(
//           context: Get.context!,
//           title: 'Error',
//           subtitle: 'Error saving interested buyer',
//           type: ToastType.error,
//         );
//       }
//     } finally {
//       if (isUserClickedOnInterested(activityType)) {
//         isSaveInterestedBuyerLoading.value = false;
//       }
//     }
//   }

//   // Filter cars based on search query (search only by carName)
//   void _filterCarsList() {
//     if (searchQuery.value.isEmpty) {
//       searchFilteredCarsList.assignAll(carsList);
//     } else {
//       final filtered = carsList.where((car) {
//         return car.carName.toLowerCase().contains(searchQuery.value);
//       }).toList();
//       searchFilteredCarsList.assignAll(filtered);
//     }
//   }

//   // Clear search
//   void clearSearch() {
//     searchController.clear();
//     searchQuery.value = '';
//   }

//   // Check if user clicked on interested button
//   bool isUserClickedOnInterested(String activityType) {
//     return activityType == AppConstants.buyACarActivityType.interested;
//   }

//   void _showSuccessDialog() {
//     showDialog(
//       context: Get.context!,
//       builder: (context) => AlertDialog(
//         title: const Icon(Icons.check_circle, color: Colors.green, size: 50),
//         content: const Text(
//           'Interest submitted successfully!\nOur team will contact you soon.',
//           textAlign: TextAlign.center,
//         ),
//         actions: [
//           Center(
//             child: ButtonWidget(
//               text: 'OK',
//               height: 35,
//               fontSize: 12,
//               isLoading: false.obs,
//               onTap: () => Navigator.pop(context),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void onClose() {
//     searchController.dispose();
//     scrollController.dispose(); // NEW
//     super.onClose();
//   }
// }

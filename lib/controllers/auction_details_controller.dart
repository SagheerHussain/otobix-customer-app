import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_customer_app/Models/auction_details_model.dart';
import 'package:otobix_customer_app/services/api_service.dart';
import 'package:otobix_customer_app/services/shared_prefs_helper.dart';
import 'package:otobix_customer_app/services/socket_service.dart';
import 'package:otobix_customer_app/utils/app_constants.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';
import 'package:otobix_customer_app/utils/socket_events.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';

enum ScreenType {
  upcoming,
  live,
  auctionCompleted,
  otobuy,
  removed,
  defaultScreen,
}

class AuctionDetailsController extends GetxController {
  final RxBool isSetExpectedPriceLoading = false.obs;
  final RxBool isRemoveCarLoading = false.obs;
  final RxBool isMoveCarToOtobuyLoading = false.obs;

  final auctionDetails = AuctionDetailsModel.empty().obs;

  late final String appointmentId;

  @override
  void onInit() {
    super.onInit();
    // Fetch appointmentId from Get.arguments
    appointmentId = Get.arguments['appointmentId'];
    fetchAuctionDetails();
    _listenToCustomerExpectedPriceRealtime();
  }

  // Fetching auction details from the API
  Future<void> fetchAuctionDetails() async {
    try {
      final response = await ApiService.post(
        endpoint: AppUrls.fetchAuctionDetails,
        body: {'appointmentId': appointmentId},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        auctionDetails.value = AuctionDetailsModel.fromJson(
          jsonResponse['data'],
        );
        // debugPrint('Auction Details: ${auctionDetails.value.toJson()}');
      } else {
        auctionDetails.value = AuctionDetailsModel.empty();
        debugPrint('Failed to load auction details');
      }
    } catch (error) {
      auctionDetails.value = AuctionDetailsModel.empty();
      debugPrint('Error: $error');
    }
  }

  // Set customer expected price
  Future<void> setCustomerExpectedPrice({
    required String carId,
    required int customerExpectedPrice,
  }) async {
    if (customerExpectedPrice <= 0) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Enter a valid amount',
        type: ToastType.error,
      );
      return;
    }

    isSetExpectedPriceLoading.value = true;

    try {
      final response = await ApiService.put(
        endpoint: AppUrls.setCustomerExpectedPrice,
        body: {'carId': carId, 'customerExpectedPrice': customerExpectedPrice},
      );

      if (response.statusCode == 200) {
        ToastWidget.show(
          context: Get.context!,
          title:
              'Successfully updated expected price to Rs. ${NumberFormat.decimalPattern('en_IN').format(customerExpectedPrice)}/-',
          type: ToastType.success,
        );
      } else {
        debugPrint('Failed to update expected price ${response.statusCode}');
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed to update expected price',
          type: ToastType.error,
        );
      }
    } catch (error) {
      debugPrint('Error: $error');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error updating expected price',
        type: ToastType.error,
      );
    } finally {
      isSetExpectedPriceLoading.value = false;
    }
  }

  // Remove car
  Future<void> removeCar({
    required String carId,
    required String reasonOfRemoval,
  }) async {
    isRemoveCarLoading.value = true;
    try {
      final String userId =
          await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ?? '';

      final response = await ApiService.post(
        endpoint: AppUrls.removeCar,
        body: {
          'carId': carId,
          'reasonOfRemoval': reasonOfRemoval,
          'removedBy': userId,
        },
      );

      if (response.statusCode == 200) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Removed Car Successfully',
          type: ToastType.success,
        );
      } else {
        debugPrint('Failed to remove the car ${response.statusCode}');
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed to remove the car',
          type: ToastType.error,
        );
      }
    } catch (error) {
      debugPrint('Error: $error');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error removing car',
        type: ToastType.error,
      );
    } finally {
      isRemoveCarLoading.value = false;
    }
  }

  // Move car to otobuy
  Future<void> moveCarToOtobuy({
    required String carId,
    required double oneClickPrice,
  }) async {
    isMoveCarToOtobuyLoading.value = true;
    try {
      final response = await ApiService.post(
        endpoint: AppUrls.moveCarToOtobuy,
        body: {'carId': carId, 'oneClickPrice': oneClickPrice},
      );

      if (response.statusCode == 200) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Car successfully moved to otobuy',
          type: ToastType.success,
        );
      } else {
        debugPrint('Failed to move car to otobuy ${response.statusCode}');
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed to move car to otobuy',
          type: ToastType.error,
        );
      }
    } catch (error) {
      debugPrint('Error: $error');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error moving car to otobuy',
        type: ToastType.error,
      );
    } finally {
      isMoveCarToOtobuyLoading.value = false;
    }
  }

  // Listen to Customer Expected Price realtime
  void _listenToCustomerExpectedPriceRealtime() {
    SocketService.instance.on(SocketEvents.customerExpectedPriceUpdated, (
      data,
    ) {
      final String carId = data['carId'];
      final int newCustomerExpectedPrice = data['newCustomerExpectedPrice'];

      // Check if the carId matches the current auction carId
      if (auctionDetails.value.carId == carId) {
        // Update the customerExpectedPrice in auctionDetails
        auctionDetails.value = auctionDetails.value.copyWith(
          customerExpectedPrice: newCustomerExpectedPrice,
        );
        debugPrint(
          '📢 New expected price received for car $carId: $newCustomerExpectedPrice',
        );
      }
    });
  }

  // Check Screen Type
  ScreenType checkScreenType(String auctionStatus) {
    final screenType = auctionStatus == AppConstants.auctionStatuses.upcoming
        ? ScreenType.upcoming
        : auctionStatus == AppConstants.auctionStatuses.live
        ? ScreenType.live
        : auctionStatus == AppConstants.auctionStatuses.liveAuctionEnded
        ? ScreenType.auctionCompleted
        : auctionStatus == AppConstants.auctionStatuses.otobuy
        ? ScreenType.otobuy
        : auctionStatus == AppConstants.auctionStatuses.removed
        ? ScreenType.removed
        : ScreenType.defaultScreen;
    return screenType;
  }
}

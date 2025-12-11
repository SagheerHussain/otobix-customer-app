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
  final RxBool isAcceptOfferLoading = false.obs;
  final RxBool isSetOneClickPriceLoading = false.obs;

  final auctionDetails = AuctionDetailsModel.empty().obs;

  late final String appointmentId;

  @override
  void onInit() {
    super.onInit();
    // Fetch appointmentId from Get.arguments
    appointmentId = Get.arguments['appointmentId'];
    fetchAuctionDetails();
    _listenToCustomerExpectedPriceRealtime();
    _listenToNewBidAndAddToLiveBidsList();
    _listenToCustomerOneClickPriceRealtime();
    _listenToNewOfferAndAddToOtobuyOffersList();
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
    required double customerExpectedPrice,
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

  // Accept Offer
  Future<bool> acceptOffer({
    required String carId,
    required String soldTo,
    required double soldAt,
  }) async {
    isAcceptOfferLoading.value = true;
    try {
      final String userId =
          await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ?? '';

      final response = await ApiService.post(
        endpoint: AppUrls.acceptOffer,
        body: {
          'carId': carId,
          'soldTo': soldTo,
          'soldBy': userId,
          'soldAt': soldAt,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('Failed to accept the offer ${response.statusCode}');
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed to accept the offer',
          type: ToastType.error,
        );
        return false;
      }
    } catch (error) {
      debugPrint('Error: $error');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error accepting the offer',
        type: ToastType.error,
      );
      return false;
    } finally {
      isAcceptOfferLoading.value = false;
    }
  }

  // Set one click price
  Future<void> setOneClickPrice({
    required String carId,
    required double oneClickPrice,
  }) async {
    if (oneClickPrice <= 0) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Enter a valid amount',
        type: ToastType.error,
      );
      return;
    }

    isSetOneClickPriceLoading.value = true;

    try {
      final response = await ApiService.put(
        endpoint: AppUrls.setOneClickPrice,
        body: {'carId': carId, 'oneClickPrice': oneClickPrice},
      );

      if (response.statusCode == 200) {
        ToastWidget.show(
          context: Get.context!,
          title:
              'Successfully updated otobuy price to Rs. ${NumberFormat.decimalPattern('en_IN').format(oneClickPrice)}/-',
          type: ToastType.success,
        );
      } else {
        debugPrint('Failed to update otobuy price ${response.statusCode}');
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed to update otobuy price',
          type: ToastType.error,
        );
      }
    } catch (error) {
      debugPrint('Error: $error');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error updating otobuy price',
        type: ToastType.error,
      );
    } finally {
      isSetOneClickPriceLoading.value = false;
    }
  }

  // Listen to Customer Expected Price realtime
  void _listenToCustomerExpectedPriceRealtime() {
    SocketService.instance.on(SocketEvents.customerExpectedPriceUpdated, (
      data,
    ) {
      final String carId = data['carId'];
      final double newCustomerExpectedPrice =
          (data['newCustomerExpectedPrice'] as num).toDouble();

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

  // Listen to new bid and add to live bids list
  void _listenToNewBidAndAddToLiveBidsList() {
    SocketService.instance.on(SocketEvents.bidUpdated, (data) {
      final String carId = data['carId'];
      final double highestBid = (data['highestBid'] as num).toDouble();
      final String bidderId = data['userId'];
      final DateTime bidTime = DateTime.parse(data['time']);

      // ✅ Only update if this AuctionDetailsController is showing
      // the same car as the incoming bid
      if (auctionDetails.value.carId != carId) {
        return;
      }

      // ✅ Only when the current auction is in LIVE state
      if (checkScreenType(auctionDetails.value.auctionStatus) !=
          ScreenType.live) {
        return;
      }

      // Create your bid model. Replace `LiveBidModel` with your
      // actual type used in `auctionDetails.value.liveBids`.
      final newBid = AuctionDetailsBidModel(
        amount: highestBid,
        offerBy: bidderId,
        date: bidTime,
      );

      // Insert at the top of the list in a reactive-safe way
      final current = auctionDetails.value;

      auctionDetails.value = current.copyWith(
        liveBids: [newBid, ...current.liveBids],
      );

      debugPrint('📢 New bid added on live screen for car $carId: $highestBid');
    });
  }

  // Listen to Customer One Click Price realtime
  void _listenToCustomerOneClickPriceRealtime() {
    SocketService.instance.on(SocketEvents.customerOneClickPriceUpdated, (
      data,
    ) {
      final String carId = data['carId'];
      final double newCustomerOneClickPrice =
          (data['newCustomerOneClickPrice'] as num).toDouble();

      // Check if the carId matches the current auction carId
      if (auctionDetails.value.carId == carId) {
        // Update the customerOneClickPrice in auctionDetails
        auctionDetails.value = auctionDetails.value.copyWith(
          oneClickPrice: newCustomerOneClickPrice,
        );
        debugPrint(
          '📢 New one click price update received for car $carId: $newCustomerOneClickPrice',
        );
      }
    });
  }

  // Listen to new offer and add to otobuy offers list
  void _listenToNewOfferAndAddToOtobuyOffersList() {
    SocketService.instance.on(SocketEvents.otobuyOfferUpdated, (data) {
      final String carId = data['carId'];
      final double newOfferAmount = (data['newOfferAmmount'] as num).toDouble();
      final String offerBy = data['offerBy'];
      final DateTime offerTime = DateTime.parse(data['offerTime']);

      // ✅ Only update if this AuctionDetailsController is showing
      // the same car as the incoming offer
      if (auctionDetails.value.carId != carId) {
        return;
      }

      // ✅ Only when the current auction is in OTOBUY state
      if (checkScreenType(auctionDetails.value.auctionStatus) !=
          ScreenType.otobuy) {
        return;
      }

      // Create your offer model. Replace `AuctionDetailsOtobuyOfferModel` with your
      // actual type used in `auctionDetails.value.otobuyOffers`.
      final newOffer = AuctionDetailsOtobuyOfferModel(
        amount: newOfferAmount,
        offerBy: offerBy,
        date: offerTime,
      );

      // Insert at the top of the list in a reactive-safe way
      final current = auctionDetails.value;

      auctionDetails.value = current.copyWith(
        otobuyOffers: [newOffer, ...current.otobuyOffers],
      );

      debugPrint(
        '📢 New offer added on otobuy screen for car $carId: $newOfferAmount',
      );
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

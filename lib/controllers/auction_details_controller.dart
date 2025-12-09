import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/Models/auction_details_model.dart';
import 'package:otobix_customer_app/services/api_service.dart';
import 'package:otobix_customer_app/utils/app_constants.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';

enum ScreenType { upcoming, live, auctionCompleted, otobuy, defaultScreen }

class AuctionDetailsController extends GetxController {
  final auctionDetails = AuctionDetailsModel.empty().obs;

  late final String appointmentId;

  @override
  void onInit() {
    super.onInit();
    // Fetch appointmentId from Get.arguments
    appointmentId = Get.arguments['appointmentId'];
    fetchAuctionDetails();
  }

  // Fetching auction details from the API
  void fetchAuctionDetails() async {
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
        : ScreenType.defaultScreen;
    return screenType;
  }
}

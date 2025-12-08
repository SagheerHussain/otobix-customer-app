import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:otobix_customer_app/utils/app_constants.dart';

enum ScreenType { upcoming, live, auctionCompleted, otobuy, defaultScreen }

class AuctionDetailsController extends GetxController {
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

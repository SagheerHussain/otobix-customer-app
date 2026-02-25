import 'package:otobix_customer_app/utils/app_constants.dart';

class AppUrls {
  static String get baseUrl => AppConstants.renderBaseUrl;

  static final String socketBaseUrl = _extractSocketBaseUrl(
    baseUrl,
  ); // Socket base URL

  static String get sendOtp => "${baseUrl}otp/send-otp";

  static String get verifyOtp => "${baseUrl}otp/verify-otp";

  static String get fetchDetails => "${baseUrl}otp/fetch-details";

  static String get login => "${baseUrl}user/login";

  static String get register => "${baseUrl}user/register";

  static String get setNewPassword => "${baseUrl}user/set-new-password";

  static String get fetchVehicleRegistrationDetails =>
      "${baseUrl}customer/sell-my-car/fetch-vehicle-registration-details";

  // static String get searchCarMakeModelVariant =>
  //     "${baseUrl}customer/search-car-make-model-variant";

  static String get searchCarMakes =>
      "${baseUrl}customer/sell-my-car/search-car-makes";
  static String get searchCarModelsByMake =>
      "${baseUrl}customer/sell-my-car/search-car-models-by-make";
  static String get searchCarVariantsByMakeModel =>
      "${baseUrl}customer/sell-my-car/search-car-variants-by-make-model";

  static String get fetchCarBannersList =>
      "${baseUrl}customer/sell-my-car/fetch-car-banners-list";

  static String get fetchMyAuctionCarsList =>
      "${baseUrl}customer/view-my-auctions/fetch-my-auction-cars-list";

  static String get fetchAuctionDetails =>
      "${baseUrl}customer/auction-details/fetch-auction-details";

  static String get setCustomerExpectedPrice =>
      "${baseUrl}customer/auction-details/set-customer-expected-price";

  static String get addTelecallingRequest =>
      "${baseUrl}inspection/telecallings/add";

  static String get updateTelecallingRequest =>
      "${baseUrl}inspection/telecallings/update";

  static String get removeCar => "${baseUrl}car/remove-car";

  static String get moveCarToOtobuy => "${baseUrl}otobuy/move-car-to-otobuy";

  static String get acceptOffer =>
      "${baseUrl}customer/auction-details/accept-offer";

  static String get setOneClickPrice =>
      "${baseUrl}customer/auction-details/set-one-click-price";

  static String get submitReAuctionRequest =>
      "${baseUrl}customer/auction-details/submit-re-auction-request";

  static String get fetch10RandomCarsList =>
      "${baseUrl}customer/buy-a-car/fetch-10-random-cars-from-firestore";

  static String get saveInterestedBuyer =>
      "${baseUrl}customer/buy-a-car/save-interested-buyer";

  static String get searchCarsInBuyACar =>
      "${baseUrl}customer/buy-a-car/search";

  static String get filterCarsInBuyACar =>
      "${baseUrl}customer/buy-a-car/filter";

  static String get fetchInspectedCarsListForWarranty =>
      "${baseUrl}customer/warranty/fetch-last-sixty-days-inspected-cars-list"; //

  static String get createRazorpayOrder => "${baseUrl}razorpay/create-order";

  static String get verifyRazorpayPayment =>
      "${baseUrl}razorpay/verify-payment";

  static String get ewiSaleApiForRSA => "${baseUrl}ewi/sale-api-for-rsa";

  static String get ewiSaleApiForGetWarranty =>
      "${baseUrl}ewi/sale-api-for-get-warranty";

  // static String get allUsersList => "${baseUrl}user/all-users-list";

  // static String get approvedUsersList => "${baseUrl}user/approved-users-list";

  // static String get pendingUsersList => "${baseUrl}user/pending-users-list";

  // static String get rejectedUsersList => "${baseUrl}user/rejected-users-list";

  // static String get usersLength => "${baseUrl}user/users-length";

  // static String get updateProfile => "${baseUrl}user/update-profile";

  static String get getUserProfile => "${baseUrl}user/user-profile";

  static String checkUsernameExists(String username) =>
      "${baseUrl}user/check-username?username=$username";

  static String get addUserActivityLog =>
      "${baseUrl}user/add-user-activity-log";

  // static String updateUserStatus(String userId) =>
  //     "${baseUrl}user/update-user-status/$userId";

  // static String getUserStatus(String userId) =>
  //     "${baseUrl}user/user-status/$userId";

  static String logout(String userId) => "${baseUrl}user/logout/$userId";

  // static String getCarDetails(String carId) => "${baseUrl}car/details/$carId";

  // static String getCarsList({required String auctionStatus}) =>
  //     "${baseUrl}car/cars-list?auctionStatus=$auctionStatus";

  // static String get getCarDetailsForNotification =>
  //     "${baseUrl}car/get-cars-list-model-for-a-car";

  // static String get getAuctionStatusAndRemainingTime =>
  //     "${baseUrl}car/get-car-auction-status-and-remaining-time";

  // static String updateUserThroughAdmin(String userId) =>
  //     "${baseUrl}user/update-user-through-admin/?userId=$userId";

  // static String get updateCarBid => "${baseUrl}car/update-bid";

  // static String get updateCarAuctionTime => "${baseUrl}car/update-auction-time";

  // static String get schedulAuction =>
  //     "${baseUrl}upcoming/update-car-auction-time";

  // static String get checkHighestBidder => "${baseUrl}car/check-highest-bidder";

  // static String get submitAutoBidForLiveSection =>
  //     "${baseUrl}car/submit-auto-bid-for-live-section";

  // static String get userNotifications =>
  //     "${baseUrl}user/notifications/create-notification";

  // static String userNotificationsList({
  //   required String userId,
  //   required int page,
  //   required int limit,
  // }) =>
  //     "${baseUrl}user/notifications/notifications-list?userId=$userId&page=$page&limit=$limit";

  // static String userNotificationsDetail({
  //   required String userId,
  //   required String notificationId,
  // }) =>
  //     "${baseUrl}user/notifications/notification-details?userId=$userId&notificationId=$notificationId";

  // static String get userNotificationsMarkRead =>
  //     "${baseUrl}user/notifications/mark-notification-as-read";

  // static String get userNotificationsMarkAllRead =>
  //     "${baseUrl}user/notifications/mark-all-notifications-as-read";

  // static String userNotificationsUnreadNotificationsCount({
  //   required String userId,
  // }) =>
  //     "${baseUrl}user/notifications/get-unread-notifications-count?userId=$userId";

  // static String getUserWishlist({required String userId}) =>
  //     "${baseUrl}user/get-user-wishlist?userId=$userId";

  // static String get addToWishlist => "${baseUrl}user/add-to-wishlist";

  // static String get removeFromWishlist => "${baseUrl}user/remove-from-wishlist";

  // static String getUserWishlistCarsList({required String userId}) =>
  //     "${baseUrl}user/get-user-wishlist-cars-list?userId=$userId";

  // static String getUserMyBidsList({required String userId}) =>
  //     "${baseUrl}user/get-user-my-bids?userId=$userId";

  // static String get addToMyBids => "${baseUrl}user/add-to-my-bids";

  // static String get removeFromMyBids => "${baseUrl}user/remove-from-my-bids";

  // static String getUserMyBidsCarsList({required String userId}) =>
  //     "${baseUrl}user/get-user-my-bids-cars-list?userId=$userId";

  // static String getUserBidsForCar({
  //   required String userId,
  //   required String carId,
  // }) => "${baseUrl}user/get-user-bids-for-car?userId=$userId&carId=$carId";

  // static String get uploadTermsAndConditions => "${baseUrl}terms/upload";

  static String get getLatestTermsAndConditions => "${baseUrl}terms/latest";

  // static String get uploadPrivacyPolicy => "${baseUrl}privacy-policy/upload";

  static String get getLatestPrivacyPolicy => "${baseUrl}privacy-policy/latest";

  // static String get uploadDealerGuide => "${baseUrl}dealer-guide/upload";

  static String get getLatestDealerGuide => "${baseUrl}dealer-guide/latest";

  // static String get moveCarToOtobuy => "${baseUrl}otobuy/move-car-to-otobuy";

  // static String get buyCar => "${baseUrl}otobuy/buy-car";

  // static String get makeOfferForCar => "${baseUrl}otobuy/make-offer-for-car";

  // static String get markCarAsSold => "${baseUrl}otobuy/mark-car-as-sold";

  // static String get removeCar => "${baseUrl}car/remove-car";

  static String get getEntityNamesList =>
      "${baseUrl}entity-documents/get-entity-names-list";

  // GET one entity (with documents) by name
  static String getEntityDocumentsByName({required String entityName}) =>
      "${baseUrl}entity-documents/get-entity-documents-by-name/${Uri.encodeComponent(entityName)}";

  // GET app update info
  static String getAppUpdateInfo({required String appKey}) =>
      "${baseUrl}admin/get-app-update-info?appKey=$appKey";

  // Socket URL Extraction
  static String _extractSocketBaseUrl(String url) {
    final uri = Uri.parse(url);
    return '${uri.scheme}://${uri.host}:${uri.port}';
  }
}

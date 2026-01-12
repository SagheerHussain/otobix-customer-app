enum DeploymentEnvironment { local, dev, prod }

class AppConstants {
  // ---- Deploy on Production or Development by changing this ----
  static const DeploymentEnvironment deploymentEnvironment =
      DeploymentEnvironment.dev;

  // Other constant classes
  static final Roles roles = Roles();
  static final AuctionStatuses auctionStatuses = AuctionStatuses();
  static final BannerStatus bannerStatus = BannerStatus();
  static final BannerTypes bannerTypes = BannerTypes();
  static final BannerViews bannerViews = BannerViews();
  static final BannerScreenNames bannerScreenNames = BannerScreenNames();
  static final ActivityLogEvents activityLogEvents = ActivityLogEvents();

  // App Key for update app info
  static const String appKey = 'customer';

  // ---- configuration per environment ----
  static const _localConfiguration = _EnvConfig(
    deploymentEnvironmentName: 'local',
    renderBaseUrl: 'http://192.168.100.99:4000/api/',
    oneSignalAppId: 'ed92ee62-6b5c-4e1a-a5c0-5846bab4055e',
  );

  static const _devConfiguration = _EnvConfig(
    deploymentEnvironmentName: 'dev',
    renderBaseUrl: 'https://otobix-app-backend-development.onrender.com/api/',
    oneSignalAppId: 'ed92ee62-6b5c-4e1a-a5c0-5846bab4055e',
  );

  static const _prodConfiguration = _EnvConfig(
    deploymentEnvironmentName: 'prod',
    renderBaseUrl: 'https://ob-dealerapp-kong.onrender.com/api/',
    oneSignalAppId: 'ed92ee62-6b5c-4e1a-a5c0-5846bab4055e',
  );

  static _EnvConfig get env =>
      deploymentEnvironment == DeploymentEnvironment.prod
      ? _prodConfiguration
      : deploymentEnvironment == DeploymentEnvironment.dev
      ? _devConfiguration
      : _localConfiguration;

  // convenience getters
  static String get envName => env.deploymentEnvironmentName; // 'dev' | 'prod'
  static bool get isProd => deploymentEnvironment == DeploymentEnvironment.prod;
  static String get renderBaseUrl => env.renderBaseUrl;
  static String get oneSignalAppId => env.oneSignalAppId;
  static String externalIdForNotifications(String mongoUserId) =>
      '$envName:$mongoUserId';
}

// User roles class
class Roles {
  // Fields
  final String dealer = 'Dealer';
  final String customer = 'Customer';
  final String salesManager = 'Sales Manager';
  final String admin = 'Admin';

  final String userStatusPending = 'Pending';
  final String userStatusApproved = 'Approved';
  final String userStatusRejected = 'Rejected';

  List<String> get all => [dealer, customer, salesManager, admin];
}

// Auction statuses class
class AuctionStatuses {
  final String all = 'all';
  final String upcoming = 'upcoming';
  final String live = 'live';
  final String otobuy = 'otobuy';
  final String marketplace = 'marketplace';
  final String liveAuctionEnded = 'liveAuctionEnded';
  final String sold = 'sold';
  final String otobuyEnded = 'otobuyEnded';
  final String removed = 'removed';
}

// Banners class
class Banners {
  final String active = 'Active';
  final String inactive = 'Inactive';
  final String header = 'Header';
  final String footer = 'Footer';
}

// Environments Configuration class
class _EnvConfig {
  final String deploymentEnvironmentName; // 'dev' or 'prod'
  final String renderBaseUrl;
  final String oneSignalAppId;
  const _EnvConfig({
    required this.deploymentEnvironmentName,
    required this.renderBaseUrl,
    required this.oneSignalAppId,
  });
}

// Banners class
class BannerStatus {
  final String active = 'Active';
  final String inactive = 'Inactive';
}

// Banners class
class BannerTypes {
  final String header = 'Header';
  final String footer = 'Footer';
}

// Banners class
class BannerViews {
  final String home = 'Home';
  final String sellMyCar = 'Sell My Car';
}

// Banners Screens Names
class BannerScreenNames {
  final String buyACar = 'Buy a Car';
  final String sellYourCar = 'Sell Your Car';
  final String warranty = 'Warranty';
  final String finance = 'Finance';
  final String insurance = 'Insurance';
}

// Activity log events
class ActivityLogEvents {
  final String login = 'login';
}

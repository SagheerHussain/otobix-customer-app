enum DeploymentEnvironment { local, dev, prod }

class AppConstants {
  // ---- Deploy on Production or Development by changing this ----
  static const DeploymentEnvironment deploymentEnvironment =
      DeploymentEnvironment.local;

  // Other constant classes
  static final Roles roles = Roles();
  static final AuctionStatuses auctionStatuses = AuctionStatuses();

  // ---- configuration per environment ----
  static const _localConfiguration = _EnvConfig(
    deploymentEnvironmentName: 'local',
    renderBaseUrl: 'http://192.168.100.99:4000/api/',
    oneSignalAppId: 'a0e49af5-e4b3-4c25-9661-942110d82981',
  );

  static const _devConfiguration = _EnvConfig(
    deploymentEnvironmentName: 'dev',
    renderBaseUrl: 'https://otobix-app-backend-development.onrender.com/api/',
    oneSignalAppId: 'a0e49af5-e4b3-4c25-9661-942110d82981',
  );

  static const _prodConfiguration = _EnvConfig(
    deploymentEnvironmentName: 'prod',
    renderBaseUrl: 'https://otobix-app-backend-rq8m.onrender.com/api/',
    oneSignalAppId: 'a0e49af5-e4b3-4c25-9661-942110d82981',
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

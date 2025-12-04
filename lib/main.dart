import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/services/notification_sevice.dart';
import 'package:otobix_customer_app/services/shared_prefs_helper.dart';
import 'package:otobix_customer_app/services/socket_service.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/views/bottom_navigation_bar_page.dart';
import 'package:otobix_customer_app/views/login_page.dart';

void main() async {
  final start = await init();

  runApp(MyApp(home: start));
}

class MyApp extends StatelessWidget {
  final Widget home;
  const MyApp({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: Get
          .key, // enables Get.* navigation from services (for route to specific screen via notification click)
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        // fontFamily: 'Poppins',
        scaffoldBackgroundColor: AppColors.white,
        canvasColor: AppColors.white,
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.white,
          brightness: Brightness.light,
        ),
      ),

      home: home,
    );
  }
}

// Initialize important services and return first screen
Future<Widget> init() async {
  Get.config(enableLog: false);
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService.instance.init();

  await SharedPrefsHelper.init();

  final userId = await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey);
  if (userId != null && userId.isNotEmpty) {
    await NotificationService.instance.login(userId);
  }

  // Initialize socket connection globally
  SocketService.instance.initSocket(AppUrls.socketBaseUrl);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final token = await SharedPrefsHelper.getString(SharedPrefsHelper.tokenKey);
  // debugPrint('PlayerID: ${await OneSignal.User.pushSubscription.id}');
  // Decide first screen BEFORE runApp
  Widget start;
  if (token != null && token.isNotEmpty) {
    start = BottomNavigationBarPage();
  } else {
    start = LoginPage();
  }

  return start;
}

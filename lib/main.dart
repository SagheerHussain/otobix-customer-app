import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/services/app_update_service.dart';
import 'package:otobix_customer_app/services/notification_sevice.dart';
import 'package:otobix_customer_app/services/shared_prefs_helper.dart';
import 'package:otobix_customer_app/services/socket_service.dart';
import 'package:otobix_customer_app/utils/app_constants.dart';
import 'package:otobix_customer_app/utils/app_urls.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/views/bottom_navigation_bar_page.dart';
import 'package:otobix_customer_app/views/login_page.dart';
import 'package:otobix_customer_app/views/registration_form_page.dart';

void main() async {
  final start = await init();
  runApp(MyApp(home: start));
}

class MyApp extends StatefulWidget {
  final Widget home;
  const MyApp({super.key, required this.home});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // ✅ run after first frame to ensure context exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppUpdateService.instance.checkOnLaunch(appKey: AppConstants.appKey);
    });
  }

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

      home: widget.home,
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
  final userRole = await SharedPrefsHelper.getString(
    SharedPrefsHelper.userTypeKey,
  );
  // debugPrint('PlayerID: ${await OneSignal.User.pushSubscription.id}');
  // Decide first screen BEFORE runApp
  Widget start;
  if (userRole != AppConstants.roles.customer) {
    start = LoginPage();
  } else if (token != null && token.isNotEmpty) {
    start = BottomNavigationBarPage();
  } else {
    start = LoginPage();
  }

  return start;
  // return RegistrationFormPage(userRole: 'Customer', phoneNumber: '9857463524');
}

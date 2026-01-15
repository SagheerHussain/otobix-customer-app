import 'package:flutter/cupertino.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/views/under_development_page.dart';

class UserNotificationsPage extends StatelessWidget {
  const UserNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UnderDevelopmentPage(
      screenName: "Notifications",
      icon: CupertinoIcons.bell,
      color: AppColors.red,
    );
  }
}

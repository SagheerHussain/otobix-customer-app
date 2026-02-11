import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/views/under_development_page.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';
import 'package:otobix_customer_app/widgets/empty_data_widget.dart';

class UserNotificationsPage extends StatelessWidget {
  const UserNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // return const UnderDevelopmentPage(
    //   screenName: "Notifications",
    //   icon: CupertinoIcons.bell,
    //   color: AppColors.red,
    // );
    return Scaffold(
      appBar: AppBarWidget(title: 'Notifications'),
      body: Center(
        child: EmptyDataWidget(
          icon: CupertinoIcons.bell_slash,
          message: 'No Notifications Yet',
        ),
      ),
    );
  }
}

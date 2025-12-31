import 'package:flutter/cupertino.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/views/under_development_page.dart';

class FinancePage extends StatelessWidget {
  const FinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UnderDevelopmentPage(
      screenName: "Finance",
      icon: CupertinoIcons.money_dollar_circle,
      color: AppColors.green,
    );
  }
}

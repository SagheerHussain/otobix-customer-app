import 'package:flutter/cupertino.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/views/under_development_page.dart';

class InsurancePage extends StatelessWidget {
  const InsurancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UnderDevelopmentPage(
      screenName: "Insurance",
      icon: CupertinoIcons.shield_lefthalf_fill,
      color: AppColors.red,
    );
  }
}

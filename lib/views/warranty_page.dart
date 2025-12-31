import 'package:flutter/cupertino.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/views/under_development_page.dart';

class WarrantyPage extends StatelessWidget {
  const WarrantyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UnderDevelopmentPage(
      screenName: "Warranty",
      icon: CupertinoIcons.checkmark_shield,
      color: AppColors.blue,
    );
  }
}

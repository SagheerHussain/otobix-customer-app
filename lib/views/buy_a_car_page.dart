import 'package:flutter/cupertino.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/views/under_development_page.dart';

class BuyACarPage extends StatelessWidget {
  const BuyACarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UnderDevelopmentPage(
      screenName: "Buy A Car",
      icon: CupertinoIcons.cart_fill,
      color: AppColors.deepOrange,
    );
  }
}

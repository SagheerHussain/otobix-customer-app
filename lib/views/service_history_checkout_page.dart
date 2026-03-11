import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/controllers/service_history_checkout_controller.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';

class ServiceHistoryCheckoutPage extends StatelessWidget {
  ServiceHistoryCheckoutPage({super.key});

  final ServiceHistoryCheckoutController serviceHistoryCheckoutController =
      Get.put(ServiceHistoryCheckoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Service History Checkout'),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xffdfe3e8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildTopSummaryCard(),
                  const SizedBox(height: 10),
                  _buildDeliveryInfoCard(),
                  const SizedBox(height: 10),
                  _buildBillDetailsCard(),
                  const SizedBox(height: 20),
                  _buildCheckoutButton(),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xffeef0f3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 76,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.directions_car_filled_rounded,
                  size: 40,
                  color: Color(0xff4a5e78),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serviceHistoryCheckoutController.carDetails['carName'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff143d79),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transmission - ${serviceHistoryCheckoutController.carDetails['transmission']}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xff6c7785),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Fuel Type - ${serviceHistoryCheckoutController.carDetails['fuelType']}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xff4f6075),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Year - ${serviceHistoryCheckoutController.carDetails['year']}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xff4f6075),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Ownership - ${serviceHistoryCheckoutController.carDetails['ownership']}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xff4f6075),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Service History Summary',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xff143d79),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: serviceHistoryCheckoutController.leftSummaryItems
                      .map((item) => _buildSummaryItem(item))
                      .toList(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: serviceHistoryCheckoutController.rightSummaryItems
                      .map((item) => _buildSummaryItem(item))
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.check, color: Color(0xff00b84f), size: 20),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xff35537d),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xffeef0f3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time_outlined,
                color: Color(0xff5c7190),
                size: 20,
              ),
              const SizedBox(width: 5),

              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xff35537d),
                    ),
                    children: [
                      const TextSpan(
                        text: 'Get Detailed Service History within ',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text: '4 hours*',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Terms & Conditions Apply*',
              style: TextStyle(
                fontSize: 10,
                color: Color(0xff6f7b8a),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: BoxDecoration(
        color: const Color(0xffbcc6d4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Bill Details',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xff143d79),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildBillRow(
            'Service History',
            serviceHistoryCheckoutController.billDetails['serviceHistory']!,
          ),
          const SizedBox(height: 3),
          _buildBillRow(
            'GST 18%',
            serviceHistoryCheckoutController.billDetails['gst']!,
          ),
          const Divider(color: AppColors.white, thickness: .5),
          _buildBillRow(
            'Total',
            serviceHistoryCheckoutController.billDetails['total']!,
            isTotal: true,
          ),
          // const SizedBox(height: 10),
          // _buildOffersField(),
        ],
      ),
    );
  }

  Widget _buildBillRow(String title, String amount, {bool isTotal = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? 13 : 12,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: const Color(0xff35537d),
            ),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 13 : 12,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: const Color(0xff35537d),
          ),
        ),
      ],
    );
  }

  Widget _buildOffersField() {
    return InkWell(
      onTap: serviceHistoryCheckoutController.onOffersAndCouponsTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xffedf0f5),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: const Color(0xff6884a8),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: const [
            Icon(
              Icons.local_offer_outlined,
              size: 18,
              color: Color(0xff2f5585),
            ),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                'Offers & Coupons',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff35537d),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Color(0xff35537d), size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return ButtonWidget(
      text: 'Proceed to Checkout',
      isLoading: false.obs,
      onTap: serviceHistoryCheckoutController.onProceedToCheckout,
      width: 250,
      height: 35,
      elevation: 2,
      borderRadius: 22,
      fontSize: 13,
      backgroundColor: AppColors.red,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ScreenType;
import 'package:otobix_customer_app/controllers/auction_details_controller.dart';
import 'package:otobix_customer_app/views/auction_details_auction_completed_section.dart';
import 'package:otobix_customer_app/views/auction_details_default_section.dart';
import 'package:otobix_customer_app/views/auction_details_live_section.dart';
import 'package:otobix_customer_app/views/auction_details_otobuy_section.dart';
import 'package:otobix_customer_app/views/auction_details_removed_section.dart';
import 'package:otobix_customer_app/views/auction_details_upcoming_section.dart';
import 'package:otobix_customer_app/widgets/access_inspection_report_widget.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';
import 'package:otobix_customer_app/widgets/shimmer_widget.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AuctionDetailsPage extends StatelessWidget {
  final String appointmentId;
  final String auctionStatus;
  AuctionDetailsPage({
    super.key,
    required this.appointmentId,
    required this.auctionStatus,
  });

  final AuctionDetailsController getxController = Get.put(
    AuctionDetailsController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Auction Details'),
      body: SafeArea(
        child: Column(
          children: [
            _buildScreen(),
            const SizedBox(height: 20),
            AccessInspectionReportWidget(
              // onTap: () {
              //   debugPrint('Access Inspection Report Tapped');
              // },
              onTap: () async {
                final Uri url = Uri.parse('https://otobix.in/privacy-policy');

                if (await canLaunchUrl(url)) {
                  // Checks if the URL can be launched
                  await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  ); // Opens the URL in an external browser
                } else {
                  ToastWidget.show(
                    context: Get.context!,
                    title: 'Could not access the inspection report now',
                    type: ToastType.error,
                  );
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Final Screen
  Widget _buildScreen() {
    return Obx(() {
      if (getxController.auctionDetails.value.registrationNumber.isEmpty) {
        return _buildScreenLoading();
      }

      final ScreenType screenType = getxController.checkScreenType(
        auctionStatus,
      );

      switch (screenType) {
        case ScreenType.upcoming:
          return AuctionDetailsUpcomingSection(appointmentId: appointmentId);
        case ScreenType.live:
          return AuctionDetailsLiveSection(appointmentId: appointmentId);
        case ScreenType.auctionCompleted:
          return AuctionDetailsAuctionCompletedSection(
            appointmentId: appointmentId,
          );
        case ScreenType.otobuy:
          return AuctionDetailsOtobuySection(appointmentId: appointmentId);
        case ScreenType.removed:
          return AuctionDetailsRemovedSection(appointmentId: appointmentId);
        case ScreenType.defaultScreen:
          return AuctionDetailsDefaultSection(appointmentId: appointmentId);
      }
    });
  }

  Widget _buildScreenLoading() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            const SizedBox(height: 10),
            // Shimmer for Car Image
            ShimmerWidget(
              height: 200,
              borderRadius: 15,
              baseColor: const Color(0xFFE0E0E0),
              highlightColor: const Color(0xFFF5F5F5),
            ),
            // Shimmer for Car Name
            ShimmerWidget(
              height: 20,
              width: 250,
              borderRadius: 50,
              baseColor: const Color(0xFFE0E0E0),
              highlightColor: const Color(0xFFF5F5F5),
            ),
            // Shimmer for Set Expected Price Button
            ShimmerWidget(
              height: 20,
              width: 200,
              borderRadius: 50,
              baseColor: const Color(0xFFE0E0E0),
              highlightColor: const Color(0xFFF5F5F5),
            ),
            // Shimmer for Remaining Time (just a placeholder for shimmer effect)
            ShimmerWidget(
              height: 20,
              width: 250,
              borderRadius: 50,
              baseColor: const Color(0xFFE0E0E0),
              highlightColor: const Color(0xFFF5F5F5),
            ),
          ],
        ),
      ),
    );
  }
}

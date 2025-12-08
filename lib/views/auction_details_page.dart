import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ScreenType;
import 'package:otobix_customer_app/controllers/auction_details_controller.dart';
import 'package:otobix_customer_app/views/auction_details_auction_completed_section.dart';
import 'package:otobix_customer_app/views/auction_details_default_section.dart';
import 'package:otobix_customer_app/views/auction_details_live_section.dart';
import 'package:otobix_customer_app/views/auction_details_otobuy_section.dart';
import 'package:otobix_customer_app/views/auction_details_upcoming_section.dart';
import 'package:otobix_customer_app/widgets/access_inspection_report_widget.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';

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
      body: Column(
        children: [
          _buildScreen(),
          const SizedBox(height: 20),
          AccessInspectionReportWidget(
            onTap: () {
              debugPrint('Access Inspection Report Tapped');
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Final Screen
  Widget _buildScreen() {
    final ScreenType screenType = getxController.checkScreenType(auctionStatus);

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
      case ScreenType.defaultScreen:
        return AuctionDetailsDefaultSection();
    }
  }
}

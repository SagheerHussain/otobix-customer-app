import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/controllers/auction_details_controller.dart';
import 'package:otobix_customer_app/controllers/my_auctions_controller.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/utils/app_images.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';

class AuctionDetailsUpcomingSection extends StatelessWidget {
  final String appointmentId;
  AuctionDetailsUpcomingSection({super.key, required this.appointmentId});

  // My Auctions Controller
  final MyAuctionsController myAuctionsController =
      Get.find<MyAuctionsController>();

  // Auction Details Controller
  final AuctionDetailsController auctionDetailsController =
      Get.find<AuctionDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),

          child: Column(
            spacing: 20,
            children: [
              const SizedBox(height: 10),
              _buildCarImage(),
              _buildCarName(),
              _buildSetExpectedPriceButton(),
              _buildRemainingTime(controller: myAuctionsController),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Remaining Time
  Widget _buildRemainingTime({required MyAuctionsController controller}) {
    return Obx(() {
      final remainingAuctionTime =
          controller.remainingTimeByAppointmentId[appointmentId] ??
          '00h : 00m : 00s';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Text(
            'Your Car is in Upcoming Auctions and expected to go Live in',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(),
          ),
          Text(
            remainingAuctionTime,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.red,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      );
    });
  }

  // Car Image
  Widget _buildCarImage() {
    final double screenWidth = MediaQuery.of(Get.context!).size.width;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(15),
        bottom: Radius.circular(15),
      ),

      child: CachedNetworkImage(
        imageUrl: auctionDetailsController.auctionDetails.value.frontMainImage,

        height: screenWidth * 0.7,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: screenWidth * 0.7,
          width: double.infinity,
          color: AppColors.grey,
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.green,
              strokeWidth: 2,
            ),
          ),
        ),
        errorWidget: (context, error, stackTrace) {
          return Image.asset(
            AppImages.carNotFound,
            height: screenWidth * 0.7,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  // Car Name
  Widget _buildCarName() {
    final String registrationNumber =
        auctionDetailsController.auctionDetails.value.registrationNumber;

    // Masking the last five characters
    final maskedRegistrationNumber = registrationNumber.length > 5
        ? '${registrationNumber.substring(0, registrationNumber.length - 5)}*****'
        : registrationNumber;

    final String carName =
        '${auctionDetailsController.auctionDetails.value.make} ${auctionDetailsController.auctionDetails.value.model} ${auctionDetailsController.auctionDetails.value.variant}';
    return Text(
      '$maskedRegistrationNumber, $carName',
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  // Set Expected Price Button
  Widget _buildSetExpectedPriceButton() {
    return ButtonWidget(
      text: 'Set/Revise My Price',
      isLoading: false.obs,
      width: 200,
      backgroundColor: AppColors.green,
      elevation: 5,
      fontSize: 12,
      onTap: () => _showSetExpectedPriceDialog(),
    );
  }

  void _showSetExpectedPriceDialog() {
    final TextEditingController priceController = TextEditingController();
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Set Expected Price',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ButtonWidget(
                      text: 'Cancel',
                      isLoading: false.obs,
                      width: double.infinity,
                      height: 35,
                      backgroundColor: AppColors.grey,
                      fontSize: 14,
                      onTap: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ButtonWidget(
                      text: 'Set',
                      isLoading: false.obs,
                      width: double.infinity,
                      height: 35,
                      backgroundColor: AppColors.green,
                      fontSize: 14,
                      onTap: () {
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

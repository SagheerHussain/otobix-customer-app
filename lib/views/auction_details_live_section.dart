import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_customer_app/controllers/auction_details_controller.dart';
import 'package:otobix_customer_app/controllers/my_auctions_controller.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/utils/app_images.dart';
import 'package:otobix_customer_app/utils/global_functions.dart';
import 'package:otobix_customer_app/views/my_auctions_page.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';
import 'package:otobix_customer_app/widgets/set_expected_price_dialog_widget.dart';

class AuctionDetailsLiveSection extends StatelessWidget {
  final String appointmentId;
  AuctionDetailsLiveSection({super.key, required this.appointmentId});

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
            spacing: 15,
            children: [
              const SizedBox(height: 10),
              _buildRemainingTime(controller: myAuctionsController),
              _buildCarImage(),
              _buildCarName(),
              _buildShowMyCurrentExpectedPrice(),
              _buildSetExpectedPriceButton(),
              _buildBidsList(),
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

      return Text(
        'Auction Ends - $remainingAuctionTime',
        style: const TextStyle(
          color: AppColors.red,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
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

  // Show My Expected Price
  Widget _buildShowMyCurrentExpectedPrice() {
    return Column(
      children: [
        Text(
          'My Expected Price',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        Obx(() {
          return Text(
            'Rs. ${NumberFormat.decimalPattern('en_IN').format(auctionDetailsController.auctionDetails.value.customerExpectedPrice)}/-',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.green,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          );
        }),
      ],
    );
  }

  // Set Expected Price Button
  Widget _buildSetExpectedPriceButton() {
    return ButtonWidget(
      text: 'Set Expected Price',
      isLoading: false.obs,
      width: 200,
      backgroundColor: AppColors.green,
      elevation: 5,
      fontSize: 12,
      onTap: () => showSetExpectedPriceDialog(
        context: Get.context!,
        title: 'Set Expected Price',
        isSetPriceLoading: auctionDetailsController.isSetExpectedPriceLoading,
        initialValue: auctionDetailsController
            .auctionDetails
            .value
            .customerExpectedPrice
            .toDouble(),
        onPriceSelected: (selectedPrice) {
          auctionDetailsController.setCustomerExpectedPrice(
            carId: auctionDetailsController.auctionDetails.value.carId,
            customerExpectedPrice: selectedPrice.toDouble(),
          );
        },
      ),
    );
  }

  // Bids List
  Widget _buildBidsList() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: .2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: AppColors.grey.withValues(alpha: .3)),
      ),
      child: Column(
        children: [
          _buildBidsHeader(),
          SizedBox(
            height: 300, // 👈 fixed height for bids list area
            child: Obx(() {
              final liveBids =
                  auctionDetailsController.auctionDetails.value.liveBids;

              if (liveBids.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('No bids yet.'),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.only(top: 0),
                itemCount: liveBids.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: AppColors.grayWithOpacity1),
                itemBuilder: (context, index) {
                  final bid = liveBids[index];
                  final bool showActions = index == 0;

                  return _buildBidRow(
                    carId: auctionDetailsController.auctionDetails.value.carId,
                    timestamp: GlobalFunctions.getFormattedDate(
                      date: bid.date,
                      type: GlobalFunctions.clearDateTime,
                    ).toString(),
                    offerAmmount: bid.amount.toDouble(),
                    offerBy: bid.offerBy,
                    showActions:
                        showActions, // Show actions only on the first offer
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Bids Header
  Widget _buildBidsHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      decoration: const BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            'Live Bids',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Offers',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Bid Row
  Widget _buildBidRow({
    required String carId,
    required String timestamp,
    required double offerAmmount,
    required String offerBy,
    bool showActions = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            timestamp,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Text(
                NumberFormat.decimalPattern('en_IN').format(offerAmmount),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (showActions) ...[
                const SizedBox(width: 10),
                InkWell(
                  onTap: () => _showAcceptOfferDialog(
                    carId: carId,
                    offerAmmount: offerAmmount,
                    offerBy: offerBy,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: AppColors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => showSetExpectedPriceDialog(
                    context: Get.context!,
                    title: 'Set Expected Price',
                    isSetPriceLoading:
                        auctionDetailsController.isSetExpectedPriceLoading,
                    initialValue: auctionDetailsController
                        .auctionDetails
                        .value
                        .customerExpectedPrice
                        .toDouble(),
                    onPriceSelected: (selectedPrice) {
                      auctionDetailsController.setCustomerExpectedPrice(
                        carId:
                            auctionDetailsController.auctionDetails.value.carId,
                        customerExpectedPrice: selectedPrice.toDouble(),
                      );
                    },
                  ),
                  child: const Icon(
                    Icons.refresh,
                    color: AppColors.blue,
                    size: 20,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _showAcceptOfferDialog({
    required String carId,
    required double offerAmmount,
    required String offerBy,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Please Confirm',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'You accept the offer of Rs. ${NumberFormat.decimalPattern('en_IN').format(offerAmmount)}/-',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.black),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ButtonWidget(
                      text: 'No',
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
                      text: 'Yes',
                      isLoading: auctionDetailsController.isAcceptOfferLoading,
                      width: double.infinity,
                      height: 35,
                      backgroundColor: AppColors.green,
                      fontSize: 14,
                      onTap: () async {
                        final bool ok = await auctionDetailsController
                            .acceptOffer(
                              carId: carId,
                              soldTo: offerBy,
                              soldAt: offerAmmount,
                            );
                        if (ok) {
                          Get.off(MyAuctionsPage());
                          myAuctionsController.fetchCarsList();
                          _showCongratulationsDialog();
                        }
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

  void _showCongratulationsDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.celebration, color: AppColors.yellow, size: 50),
              SizedBox(height: 15),
              Text(
                'Congratulations!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.green,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Our sales team will contact you shortly!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ButtonWidget(
                text: 'Close',
                isLoading: false.obs,
                width: double.infinity,
                height: 35,
                backgroundColor: AppColors.green,
                fontSize: 14,
                onTap: () {
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

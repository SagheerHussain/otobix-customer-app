import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_customer_app/controllers/auction_details_controller.dart';
import 'package:otobix_customer_app/controllers/my_auctions_controller.dart';
import 'package:otobix_customer_app/services/car_margin_helpers.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/utils/app_images.dart';
import 'package:otobix_customer_app/utils/global_functions.dart';
import 'package:otobix_customer_app/views/my_auctions_page.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';
import 'package:otobix_customer_app/widgets/set_expected_price_dialog_widget.dart';

class AuctionDetailsOtobuySection extends StatelessWidget {
  final String appointmentId;
  AuctionDetailsOtobuySection({super.key, required this.appointmentId});

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
              _buildCarImage(),
              _buildCarName(),
              _buildShowMyCurrentOtobuyPrice(),
              _buildAcceptOfferButton(),
              _buildReviseOtobuyPriceAndRemoveCarButtons(),
              _buildOtobuyOffersList(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
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

  // Show My Otobuy Price
  Widget _buildShowMyCurrentOtobuyPrice() {
    return Column(
      children: [
        Text(
          'My OtoBuy Price',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        Obx(() {
          return Text(
            'Rs. ${NumberFormat.decimalPattern('en_IN').format(auctionDetailsController.auctionDetails.value.oneClickPrice)}/-',
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

  // Accept Offer Button
  Widget _buildAcceptOfferButton() {
    return Obx(() {
      final hide = auctionDetailsController
          .has72HoursPassedSinceOtobuyStarted();
      return hide
          ? const SizedBox.shrink()
          : ButtonWidget(
              text: 'Accept Offer',
              isLoading: false.obs,
              width: double.infinity,
              backgroundColor: AppColors.blue,
              elevation: 5,
              fontSize: 12,
              onTap: () {
                final otobuyOffers =
                    auctionDetailsController.auctionDetails.value.otobuyOffers;

                final offer = otobuyOffers[0];

                final offerAmountAfterMarginAdjustment =
                    CarMarginHelpers.netAfterMarginsFlexible(
                      originalPrice: offer.amount,
                      priceDiscovery: auctionDetailsController
                          .auctionDetails
                          .value
                          .priceDiscovery,
                      fixedMargin: offer.fixedMargin,
                      variableMargin: offer.variableMargin,
                    );

                _showAcceptOfferDialog(
                  carId: auctionDetailsController.auctionDetails.value.carId,
                  originalOfferAmmount: offer.amount,
                  marginAdjustedOfferAmmount: offerAmountAfterMarginAdjustment,
                  offerBy: offer.offerBy,
                );
              },
            );
    });
  }

  // Revise Otobuy Price Button
  Widget _buildReviseOtobuyPriceAndRemoveCarButtons() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ButtonWidget(
                text: 'Revise',
                isLoading: false.obs,
                width: 200,
                backgroundColor: AppColors.green,
                elevation: 5,
                fontSize: 12,
                onTap: () => showSetExpectedPriceDialog(
                  context: Get.context!,
                  title: 'Set OtoBuy Price',
                  isSetPriceLoading:
                      auctionDetailsController.isSetOneClickPriceLoading,
                  initialValue: auctionDetailsController
                      .auctionDetails
                      .value
                      .oneClickPrice,
                  canIncreasePriceUpto150Percent: true,
                  onPriceSelected: (selectedPrice) {
                    auctionDetailsController.setOneClickPrice(
                      carId:
                          auctionDetailsController.auctionDetails.value.carId,
                      oneClickPrice: selectedPrice.toDouble(),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: ButtonWidget(
                text: 'Remove Car',
                isLoading: false.obs,
                width: 200,
                backgroundColor: AppColors.red,
                elevation: 5,
                fontSize: 12,
                onTap: () => _showRemoveCarDialog(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // Otobuy Offers List
  Widget _buildOtobuyOffersList() {
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
          _buildOtobuyOffersHeader(),
          SizedBox(
            height: 300, // 👈 fixed height for the offers area
            child: Obx(() {
              final otobuyOffers =
                  auctionDetailsController.auctionDetails.value.otobuyOffers;

              if (otobuyOffers.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('No offers yet.'),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.only(top: 0),
                itemCount: otobuyOffers.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: AppColors.grayWithOpacity1),
                itemBuilder: (context, index) {
                  final offer = otobuyOffers[index];
                  // final bool showActions = index == 0; // latest offer only
                  final bool showActions = false; // disabled for now

                  final offerAmountAfterMarginAdjustment =
                      CarMarginHelpers.netAfterMarginsFlexible(
                        originalPrice: offer.amount,
                        priceDiscovery: auctionDetailsController
                            .auctionDetails
                            .value
                            .priceDiscovery,
                        fixedMargin: offer.fixedMargin,
                        variableMargin: offer.variableMargin,
                      );

                  return _buildOfferRow(
                    carId: auctionDetailsController.auctionDetails.value.carId,
                    timestamp: GlobalFunctions.getFormattedDate(
                      date: offer.date,
                      type: GlobalFunctions.clearDateTime,
                    ).toString(),
                    originalOfferAmmount: offer.amount,
                    marginAdjustedOfferAmmount:
                        offerAmountAfterMarginAdjustment,
                    offerBy: offer.offerBy,
                    showActions: showActions,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Otobuy Offers Header
  Widget _buildOtobuyOffersHeader() {
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
            'OtoBuy Offers',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Text(
          //   'Offers',
          //   style: TextStyle(
          //     fontSize: 14,
          //     color: AppColors.white,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
        ],
      ),
    );
  }

  // Otobuy Offer Row
  Widget _buildOfferRow({
    required String carId,
    required String timestamp,
    required double originalOfferAmmount,
    required double marginAdjustedOfferAmmount,
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
                NumberFormat.decimalPattern(
                  'en_IN',
                ).format(marginAdjustedOfferAmmount),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (showActions) ...[
                const SizedBox(width: 10),
                Obx(() {
                  final hide = auctionDetailsController
                      .has72HoursPassedSinceOtobuyStarted();
                  return hide
                      ? const SizedBox.shrink()
                      : Row(
                          children: [
                            InkWell(
                              onTap: () => _showAcceptOfferDialog(
                                carId: carId,
                                originalOfferAmmount: originalOfferAmmount,
                                marginAdjustedOfferAmmount:
                                    marginAdjustedOfferAmmount,
                                offerBy: offerBy,
                              ),
                              child: const Icon(
                                Icons.check_circle,
                                color: AppColors.green,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        );
                }),

                InkWell(
                  onTap: () => showSetExpectedPriceDialog(
                    context: Get.context!,
                    title: 'Set OtoBuy Price',
                    isSetPriceLoading:
                        auctionDetailsController.isSetOneClickPriceLoading,
                    initialValue: auctionDetailsController
                        .auctionDetails
                        .value
                        .oneClickPrice,
                    canIncreasePriceUpto150Percent: true,
                    onPriceSelected: (selectedPrice) {
                      auctionDetailsController.setOneClickPrice(
                        carId:
                            auctionDetailsController.auctionDetails.value.carId,
                        oneClickPrice: selectedPrice.toDouble(),
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
    required double originalOfferAmmount,
    required double marginAdjustedOfferAmmount,
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
                'You accept the offer of Rs. ${NumberFormat.decimalPattern('en_IN').format(marginAdjustedOfferAmmount)}/-',
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
                              soldAt: originalOfferAmmount,
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

  // Remove Car Dialog
  void _showRemoveCarDialog() {
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
              const Text(
                'You want to remove this car?',
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
                      isLoading: false.obs,
                      width: double.infinity,
                      height: 35,
                      backgroundColor: AppColors.green,
                      fontSize: 14,
                      onTap: () {
                        Get.back();
                        _showResonOfCarRemovalDialog();
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

  // Reason of Car Removal Dialog
  void _showResonOfCarRemovalDialog() {
    final RxString selectedReason = "Already Sold".obs;
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Reason of Removal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 15),

              // Reason 1
              Obx(() {
                return RadioListTile<String>(
                  title: const Text("Already Sold"),
                  value: "Already Sold",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0,
                  ),
                  groupValue: selectedReason.value,
                  onChanged: (value) {
                    selectedReason.value = value!;
                  },
                );
              }),

              // Reason 2
              Obx(() {
                return RadioListTile<String>(
                  title: const Text("Price Not Acceptable"),
                  value: "Price Not Acceptable",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0,
                  ),
                  groupValue: selectedReason.value,
                  onChanged: (value) {
                    selectedReason.value = value!;
                  },
                );
              }),

              // Reason 3
              Obx(() {
                return RadioListTile<String>(
                  title: const Text("Sell Later"),
                  value: "Sell Later",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0,
                  ),
                  groupValue: selectedReason.value,
                  onChanged: (value) {
                    selectedReason.value = value!;
                  },
                );
              }),

              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ButtonWidget(
                  text: 'Submit',
                  isLoading: auctionDetailsController.isRemoveCarLoading,
                  width: double.infinity,
                  height: 35,
                  backgroundColor: AppColors.green,
                  fontSize: 14,
                  onTap: () {
                    auctionDetailsController.removeCar(
                      carId:
                          auctionDetailsController.auctionDetails.value.carId,
                      reasonOfRemoval: selectedReason.value,
                    );
                    Get.back();
                    Get.back();
                    myAuctionsController.fetchCarsList();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

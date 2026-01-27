import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:otobix_customer_app/controllers/auction_details_controller.dart';
import 'package:otobix_customer_app/controllers/my_auctions_controller.dart';
import 'package:otobix_customer_app/services/car_margin_helpers.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/utils/app_images.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';
import 'package:otobix_customer_app/widgets/set_expected_price_dialog_widget.dart';
import 'package:otobix_customer_app/widgets/toast_widget.dart';

class AuctionDetailsAuctionCompletedSection extends StatelessWidget {
  final String appointmentId;
  AuctionDetailsAuctionCompletedSection({
    super.key,
    required this.appointmentId,
  });

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
              // _buildInfoText(),
              _buildShowHighestBid(),
              _buildShowMyCurrentExpectedPrice(),
              _buildAcceptOfferButton(),
              _buildRunOtobuyAndRemoveCarButtons(),
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

  // // Info Text
  // Widget _buildInfoText() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       SizedBox(height: 20),
  //       Text(
  //         'The Live Auction did not fetch your expected price',
  //         textAlign: TextAlign.center,
  //         style: const TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.w600,
  //           letterSpacing: 0.5,
  //         ),
  //       ),
  //       SizedBox(height: 20),
  //     ],
  //   );
  // }

  // Show Highest Bid
  Widget _buildShowHighestBid() {
    return Column(
      children: [
        Text(
          'Highest Bid',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        Obx(() {
          final highestBid = auctionDetailsController
              .auctionDetails
              .value
              .liveBids
              .first
              .amount;
          final priceDiscovery =
              auctionDetailsController.auctionDetails.value.priceDiscovery;
          final fixedMargin = auctionDetailsController
              .auctionDetails
              .value
              .liveBids
              .first
              .fixedMargin;
          final variableMargin = auctionDetailsController
              .auctionDetails
              .value
              .liveBids
              .first
              .variableMargin;

          double highestBidAfterMarginAdjustment =
              CarMarginHelpers.netAfterMarginsFlexible(
                originalPrice: highestBid,
                priceDiscovery: priceDiscovery,
                fixedMargin: fixedMargin,
                variableMargin: variableMargin,
              );

          return Text(
            'Rs. ${NumberFormat.decimalPattern('en_IN').format(highestBidAfterMarginAdjustment)}/-',
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

  // Run Otobuy and Remove Car Buttons
  Widget _buildRunOtobuyAndRemoveCarButtons() {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Obx(() {
          // Check if 15 days have passed since auction end
          bool has15DaysPassedSinceAuctionEnd = auctionDetailsController
              .has15DaysPassedSinceAuctionEnd();

          // Check if 30 days have passed since auction end
          bool has30DaysPassedSinceAuctionEnd = auctionDetailsController
              .has30DaysPassedSinceAuctionEnd();

          if (has15DaysPassedSinceAuctionEnd &&
              !has30DaysPassedSinceAuctionEnd) {
            return Expanded(
              child: ButtonWidget(
                text: 'Run Re-Auction',
                isLoading: false.obs,
                width: 200,
                backgroundColor: AppColors.green,
                elevation: 5,
                fontSize: 12,
                onTap: () => _showRunReAuctionDialog(),
              ),
            );
          }
          if (has30DaysPassedSinceAuctionEnd) {
            return Expanded(
              child: ButtonWidget(
                text: 'Run Re-Inspection',
                isLoading: false.obs,
                width: 200,
                backgroundColor: AppColors.green,
                elevation: 5,
                fontSize: 12,
                onTap: () => _showRunReInspectionDialog(),
              ),
            );
          }

          return Expanded(
            child: ButtonWidget(
              text: 'Run OtoBuy',
              isLoading: false.obs,
              width: 200,
              backgroundColor: AppColors.green,
              elevation: 5,
              fontSize: 12,
              onTap: () => showSetExpectedPriceDialog(
                context: Get.context!,
                title: 'Set OtoBuy Price',
                isSetPriceLoading:
                    auctionDetailsController.isMoveCarToOtobuyLoading,
                initialValue: auctionDetailsController
                    .auctionDetails
                    .value
                    .oneClickPrice
                    .toDouble(),
                canIncreasePriceUpto150Percent: true,
                onPriceSelected: (selectedPrice) {
                  auctionDetailsController.moveCarToOtobuy(
                    carId: auctionDetailsController.auctionDetails.value.carId,
                    oneClickPrice: selectedPrice,
                  );
                  Get.back();
                  myAuctionsController.fetchCarsList();
                },
              ),
            ),
          );
        }),
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

  // Accept Offer Button
  Widget _buildAcceptOfferButton() {
    return Obx(() {
      final hide = auctionDetailsController.has72HoursPassedSinceAuctionEnd();
      return hide
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ButtonWidget(
                text: 'Accept Offer',
                isLoading: false.obs,
                width: double.infinity,
                backgroundColor: AppColors.blue,
                elevation: 5,
                fontSize: 12,
                onTap: () => _showAcceptOfferDialog(),
              ),
            );
    });
  }

  //  Accept Offer Dialog
  void _showAcceptOfferDialog() {
    final highestBid =
        auctionDetailsController.auctionDetails.value.liveBids.first.amount;
    final priceDiscovery =
        auctionDetailsController.auctionDetails.value.priceDiscovery;
    final fixedMargin = auctionDetailsController
        .auctionDetails
        .value
        .liveBids
        .first
        .fixedMargin;
    final variableMargin = auctionDetailsController
        .auctionDetails
        .value
        .liveBids
        .first
        .variableMargin;

    double highestBidAfterMarginAdjustment =
        CarMarginHelpers.netAfterMarginsFlexible(
          originalPrice: highestBid,
          priceDiscovery: priceDiscovery,
          fixedMargin: fixedMargin,
          variableMargin: variableMargin,
        );

    final offerAmount =
        'Rs. ${NumberFormat.decimalPattern('en_IN').format(highestBidAfterMarginAdjustment)}/-';
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
                'You accept the offer of $offerAmount?',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppColors.black),
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
                              carId: auctionDetailsController
                                  .auctionDetails
                                  .value
                                  .carId,
                              soldTo: auctionDetailsController
                                  .auctionDetails
                                  .value
                                  .liveBids
                                  .first
                                  .offerBy,
                              soldAt: auctionDetailsController
                                  .auctionDetails
                                  .value
                                  .liveBids
                                  .first
                                  .amount,
                            );
                        if (ok) {
                          Get.back();
                          Get.back();
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

  // Accept offer congratulations dialog
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

  //  Run Re-Auction Dialog
  void _showRunReAuctionDialog() {
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
                'Has the car had any damages post last inspection?',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppColors.black),
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
                      onTap: () {
                        Get.back();
                        _showNoDamagesInReAuctionDialog();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ButtonWidget(
                      text: 'Yes',
                      isLoading: auctionDetailsController
                          .isSubmitReInspectionRequestLoading,
                      width: double.infinity,
                      height: 35,
                      backgroundColor: AppColors.green,
                      fontSize: 14,
                      onTap: () async {
                        final bool ok = await auctionDetailsController
                            .submitReInspectionRequest(
                              appointmentId: appointmentId,
                            );
                        if (ok) {
                          Get.back();
                          _showReInspectionRequestRecievedDialog();
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

  //  No Damages in Re-Auction Dialog
  void _showNoDamagesInReAuctionDialog() {
    final TextEditingController odometerController = TextEditingController();
    final Rx<File?> pickedImage = Rx<File?>(null);

    final ImagePicker picker = ImagePicker();

    Future<void> pickFromCamera() async {
      final XFile? x = await picker.pickImage(source: ImageSource.camera);
      if (x != null) pickedImage.value = File(x.path);
    }

    Future<void> pickFromGallery() async {
      final XFile? x = await picker.pickImage(source: ImageSource.gallery);
      if (x != null) pickedImage.value = File(x.path);
    }

    void showPickOptions() {
      Get.bottomSheet(
        SafeArea(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take photo'),
                  onTap: () async {
                    Get.back();
                    await pickFromCamera();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from gallery'),
                  onTap: () async {
                    Get.back();
                    await pickFromGallery();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(
            () => SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'What is the current odometer reading?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Odometer input (numeric only)
                  TextFormField(
                    controller: odometerController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: 'e.g. 45230',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Upload image
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Upload odometer image (proof)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  InkWell(
                    onTap: showPickOptions,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade500),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.upload_file),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              pickedImage.value == null
                                  ? 'Tap to upload image'
                                  : 'Image selected',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          if (pickedImage.value != null)
                            IconButton(
                              onPressed: () => pickedImage.value = null,
                              icon: const Icon(Icons.close),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Preview
                  if (pickedImage.value != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        pickedImage.value!,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
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
                          text: 'Submit',
                          isLoading: auctionDetailsController
                              .isSubmitReAuctionRequestLoading,
                          width: double.infinity,
                          height: 35,
                          backgroundColor: AppColors.green,
                          fontSize: 14,
                          onTap: () async {
                            final odoText = odometerController.text.trim();

                            if (odoText.isEmpty) {
                              ToastWidget.show(
                                context: Get.context!,
                                title: 'Required',
                                subtitle: 'Please enter odometer reading',
                                type: ToastType.error,
                              );
                              return;
                            }
                            if (pickedImage.value == null) {
                              ToastWidget.show(
                                context: Get.context!,
                                title: 'Required',
                                subtitle: 'Please upload odometer image',
                                type: ToastType.error,
                              );
                              return;
                            }

                            final bool ok = await auctionDetailsController
                                .submitReAuctionRequest(
                                  appointmentId: appointmentId,
                                  odometerReading: int.parse(odoText),
                                  otometerProofImage: pickedImage.value!,
                                );
                            if (ok) {
                              Get.back();
                              _showReAuctionRequestRecievedDialog();
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
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Show re auction request received dialog on submitting re run auction request
  void _showReAuctionRequestRecievedDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.celebration, color: AppColors.yellow, size: 40),
              SizedBox(height: 15),
              Text(
                'Re-Auction Request Received!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.green,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Request for re-auction has been received. Please note that offers received during this auction will be subjective and subject to final re-inspection if the offer is accepted. You indemnify that the information provided is true and correct to the best of your knowledge.',
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

  //  Run Re-Inspection Dialog
  void _showRunReInspectionDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Request for Re-Inspection',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Do you want to request for re-inspection of this vehicle?',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppColors.black),
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
                      onTap: () {
                        Get.back();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ButtonWidget(
                      text: 'Yes',
                      isLoading: auctionDetailsController
                          .isSubmitReInspectionRequestLoading,
                      width: double.infinity,
                      height: 35,
                      backgroundColor: AppColors.green,
                      fontSize: 14,
                      onTap: () async {
                        final bool ok = await auctionDetailsController
                            .submitReInspectionRequest(
                              appointmentId: appointmentId,
                            );
                        if (ok) {
                          Get.back();
                          _showReInspectionRequestRecievedDialog();
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

  // Show re inspection request received dialog
  void _showReInspectionRequestRecievedDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.celebration, color: AppColors.yellow, size: 40),
              SizedBox(height: 15),
              Text(
                'Re-Inspection Request Received!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.green,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Request for re-inspection has been received. Please note that offers received during this auction will be subjective and subject to final re-inspection if the offer is accepted. You indemnify that the information provided is true and correct to the best of your knowledge.',
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

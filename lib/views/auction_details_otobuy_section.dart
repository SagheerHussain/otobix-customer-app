import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/utils/app_images.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';

class AuctionDetailsOtobuySection extends StatelessWidget {
  final String appointmentId;
  const AuctionDetailsOtobuySection({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    // final MyAuctionsController myAuctionsController =
    //     Get.find<MyAuctionsController>();

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
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/1/13/Mahindra_Thar_Photoshoot_At_Perupalem_Beach_%28West_Godavari_District%2CAP%2CIndia_%29_Djdavid.jpg',

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
    return Text(
      'WB********, Mahindra Scorpio [2014 - 2015]',
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
        Text(
          'Rs. 9,50,000/-',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.green,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
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
                onTap: () => _showReviseOtobuyPriceDialog(),
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

  // Bids List
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
          _buildBidsHeader(),
          _buildBidRow(
            timestamp: '04 Nov 2025 11:05 AM',
            offer: '950000',
            showActions: true,
          ),
          const Divider(height: 1, color: AppColors.grayWithOpacity1),
          _buildBidRow(timestamp: '04 Nov 2025 10:55 AM', offer: '940000'),
          const Divider(height: 1, color: AppColors.grayWithOpacity1),
          _buildBidRow(timestamp: '04 Nov 2025 10:53 AM', offer: '935000'),
          const Divider(height: 1, color: AppColors.grayWithOpacity1),
          _buildBidRow(timestamp: '04 Nov 2025 10:45 AM', offer: '920000'),
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

  // Bid Row
  Widget _buildBidRow({
    required String timestamp,
    required String offer,
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
                NumberFormat.decimalPattern().format(int.parse(offer)),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (showActions) ...[
                const SizedBox(width: 10),
                InkWell(
                  onTap: () => _showAcceptOfferDialog(),
                  child: const Icon(
                    Icons.check_circle,
                    color: AppColors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _showReviseOtobuyPriceDialog(),
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

  void _showAcceptOfferDialog() {
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
                'You accept the offer of Rs. 3,000/-',
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
                        _showCongratulationsDialog();
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

  void _showReviseOtobuyPriceDialog() {
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
                'Set OtoBuy Price',
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
    final RxString selectedReason = "reason1".obs;
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
                  value: "reason1",
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
                  value: "reason2",
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
                  value: "reason3",
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
                  isLoading: false.obs,
                  width: double.infinity,
                  height: 35,
                  backgroundColor: AppColors.green,
                  fontSize: 14,
                  onTap: () {
                    // You can access selectedReason.value here if you want to handle the selected reason.
                    Get.back();
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

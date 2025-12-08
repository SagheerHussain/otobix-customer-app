import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/controllers/my_auctions_controller.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/utils/app_images.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';

class AuctionDetailsAuctionCompletedSection extends StatelessWidget {
  final String appointmentId;
  const AuctionDetailsAuctionCompletedSection({
    super.key,
    required this.appointmentId,
  });

  @override
  Widget build(BuildContext context) {
    final MyAuctionsController myAuctionsController =
        Get.find<MyAuctionsController>();

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
              _buildInfoText(controller: myAuctionsController),
              _buildRunOtobuyAndRemoveCarButtons(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Info Text
  Widget _buildInfoText({required MyAuctionsController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Text(
          'The Live Auction did not fetch your expected price',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 20),
      ],
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

  // Run Otobuy and Remove Car Buttons
  Widget _buildRunOtobuyAndRemoveCarButtons() {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ButtonWidget(
            text: 'Run OtoBuy',
            isLoading: false.obs,
            width: 200,
            backgroundColor: AppColors.green,
            elevation: 5,
            fontSize: 12,
            onTap: () => _showSetOtobuyPriceDialog(),
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
    );
  }

  void _showSetOtobuyPriceDialog() {
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

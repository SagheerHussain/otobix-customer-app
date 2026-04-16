import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/controllers/service_history_controller.dart';
import 'package:otobix_customer_app/utils/app_colors.dart';
import 'package:otobix_customer_app/utils/app_icons.dart';
import 'package:otobix_customer_app/utils/app_images.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';
import 'package:otobix_customer_app/widgets/button_widget.dart';

class ServiceHistoryPage extends StatelessWidget {
  ServiceHistoryPage({super.key});

  final ServiceHistoryController serviceHistoryController = Get.put(
    ServiceHistoryController(),
  );

  // Simple colors to match the screenshot look
  static const Color _lightBlueBg = Color(0xFFEAF2FF);
  static const Color _border = Color(0xFFCED7E6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Service History'),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildTopBanner(
                  context: context,
                  bannerPath: AppImages.pdiScreenBanner,
                ),
                const SizedBox(height: 12),
                _buildRegistrationCard(),
                const SizedBox(height: 20),
                _buildSampleReportSection(),
                const SizedBox(height: 20),
                _buildReportsSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===== BANNER =====
  Widget _buildTopBanner({
    required BuildContext context,
    required String bannerPath,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: _lightBlueBg,
        child: Image.asset(
          bannerPath,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTopBanner1() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0xff103b7a), Color(0xff6f88aa)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SERVICE HISTORY',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              height: 1,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Check Service History, Challans\n& View Important Dates',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xff8fa4c1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: 'Enter Your ',
                  style: TextStyle(color: Colors.black87),
                ),
                TextSpan(
                  text: 'Car Registration Number*',
                  style: TextStyle(color: AppColors.red),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xffb8c6d8)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: serviceHistoryController.registrationController,
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(color: Colors.black87, fontSize: 13),
                    decoration: const InputDecoration(
                      isDense: true,
                      hintText: '(e.g. WB02ANXXXX)',
                      hintStyle: TextStyle(color: AppColors.grey, fontSize: 13),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 1,
                      ),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      serviceHistoryController.registrationController.value =
                          TextEditingValue(
                            text: value.toUpperCase(),
                            selection: TextSelection.collapsed(
                              offset: value.length,
                            ),
                          );
                    },
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  child: const Icon(
                    CupertinoIcons.search,
                    color: Color(0xff1b3f78),
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: ButtonWidget(
              text: 'Get Service History',
              isLoading: false.obs,
              onTap: serviceHistoryController.onGetServiceHistory,
              height: 34,
              width: 175,
              elevation: 2,
              borderRadius: 20,
              fontSize: 13,
              backgroundColor: AppColors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSampleReportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Not sure what a Car Service History looks like ?',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xff143d79),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xffe4e7eb),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xffd0d8e4),
                  borderRadius: BorderRadius.circular(6),
                ),
                // child: const Icon(
                //   Icons.assignment_outlined,
                //   color: Color(0xff3d5f92),
                //   size: 28,
                // ),
                child: SvgPicture.asset(
                  AppIcons.warranty,
                  height: 20,
                  width: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'View A Sample Report',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff143d79),
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Before You Buy',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xff51657d),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 26,
                child: ButtonWidget(
                  text: 'VIEW',
                  isLoading: false.obs,
                  onTap: serviceHistoryController.onViewSampleReport,
                  width: 70,
                  fontSize: 11,
                  borderRadius: 4,
                  elevation: 1,
                  backgroundColor: const Color(0xff153d79),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReportsSection() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Reports',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xff143d79),
            ),
          ),
          const SizedBox(height: 8),
          ListView.separated(
            itemCount: serviceHistoryController.reports.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final report = serviceHistoryController.reports[index];
              return _buildReportCard(report);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xff8fa4c1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 78,
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xffeef2f7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.directions_car_filled_rounded,
                      size: 40,
                      color: Color(0xff4a5e78),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    report['registrationNumber'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff143d79),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            report['carName'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xff143d79),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffd6ffd9),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xff7ed58c)),
                          ),
                          child: Text(
                            report['status'],
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Color(0xff1e9f39),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Transmission - ${report['transmission']}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Year - ${report['year']}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fuel Type - ${report['fuelType']}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Ownership - ${report['ownership']}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transaction ID',
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    report['transactionId'],
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Colors.black87,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Date - ',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                          text: report['date'],
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // const SizedBox(width: 10),
              Row(
                children: [
                  ButtonWidget(
                    text: 'VIEW',
                    isLoading: false.obs,
                    onTap: () => serviceHistoryController.onViewReport(report),
                    width: 60,
                    height: 26,
                    fontSize: 11,
                    borderRadius: 4,
                    elevation: 1,
                    backgroundColor: const Color(0xff153d79),
                  ),
                  const SizedBox(width: 6),
                  ButtonWidget(
                    text: 'DOWNLOAD REPORT',
                    isLoading: false.obs,
                    onTap: () =>
                        serviceHistoryController.onDownloadReport(report),
                    height: 26,
                    width: 120,
                    fontSize: 10,
                    borderRadius: 4,
                    elevation: 1,
                    backgroundColor: const Color(0xff153d79),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

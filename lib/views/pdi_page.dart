
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/controllers/pdi_controller.dart';
import 'package:otobix_customer_app/utils/app_images.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';

class PdiPage extends StatelessWidget {
  PdiPage({super.key});

  final PdiController pdiController = Get.put(PdiController());

  // Simple colors to match the screenshot look
  static const Color _lightBlueBg = Color(0xFFEAF2FF);
  static const Color _border = Color(0xFFCED7E6);

  @override
  Widget build(BuildContext context) {
    return
    //  1 == 1
    //     ? const UnderDevelopmentPage(
    //         screenName: "PDI",
    //         icon: CupertinoIcons.car,
    //         color: AppColors.red,
    //         completedPercentage: 50,
    //       )
    //     : 
        Scaffold(
            appBar: AppBarWidget(title: 'Pre Delivery Inspection'),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _buildBanner(
                      context: context,
                      bannerPath: AppImages.pdiBanner,
                    ),
                    const SizedBox(height: 14),
                    _buildServiceCategoriesSection(context),
                    const SizedBox(height: 16),
                    _buildCoverageSection(context),
                    const SizedBox(height: 16),
                    _buildBanner(
                      context: context,
                      bannerPath: AppImages.pdiBanner2,
                    ),
                    const SizedBox(height: 16),
                    _buildHowItWorksSection(context),
                    const SizedBox(height: 16),
                    _buildFaqSection(context),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
  }

  // ===== BANNER =====
  Widget _buildBanner({
    required BuildContext context,
    required String bannerPath,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          color: _lightBlueBg,
          child: Image.asset(
            bannerPath,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // ===== SERVICE CATEGORIES SECTION =====
  Widget _buildServiceCategoriesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Service Categories',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0D2B55),
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => Row(
                children: [
                  Expanded(child: _buildCategoryCard(0)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildCategoryCard(1)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(int index) {
    final item = pdiController.serviceCategories[index];
    // final bool isSelected = (item['isSelected'] == true);

    return InkWell(
      onTap: () => pdiController.selectCategory(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            // color: isSelected ? const Color(0xFF6FA2FF) : _border,
            color: _border,
            // width: isSelected ? 2 : 1,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 72,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _lightBlueBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: _buildCategoryImageOrPlaceholder(item['imageAsset']),
            ),
            const SizedBox(height: 8),
            Text(
              (item['title'] ?? '').toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0D2B55),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryImageOrPlaceholder(String? asset) {
    if (asset == null || asset.trim().isEmpty) {
      return const Center(
        child: Icon(
          Icons.directions_car_rounded,
          size: 42,
          color: Color(0xFF0B3A73),
        ),
      );
    }

    return Image.asset(
      asset,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) {
        return const Center(
          child: Icon(
            Icons.directions_car_rounded,
            size: 42,
            color: Color(0xFF0B3A73),
          ),
        );
      },
    );
  }

  // ===== COVERAGE SECTION =====
  Widget _buildCoverageSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What we cover in Pre-Delivery Inspection',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0D2B55),
              ),
            ),
            const SizedBox(height: 10),
            Obx(() => _buildCoverageGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverageGrid() {
    final items = pdiController.coverageItems;

    // 2-column layout like the screenshot
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.6,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        final IconData icon = (item['icon'] as IconData?) ?? Icons.check_circle;
        final String title = (item['title'] ?? '').toString();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _border),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _lightBlueBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF0B3A73), size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D2B55),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHowItWorksSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE0E6F1)),
        ),
        child: Column(
          children: [
            const Text(
              'How it Works',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0D2B55),
              ),
            ),
            const SizedBox(height: 10),

            Obx(
              () => Column(
                children: List.generate(pdiController.howItWorksSteps.length, (
                  index,
                ) {
                  final s = pdiController.howItWorksSteps[index];
                  final title = s['title'].toString();
                  final desc = s['desc'].toString();
                  final icon = (s['icon'] as IconData?) ?? Icons.info_rounded;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFCED7E6)),
                          ),
                          child: Icon(icon, color: const Color(0xFF0B3A73)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 12,
                                height: 1.35,
                                color: Color(0xFF0D2B55),
                              ),
                              children: [
                                TextSpan(
                                  text: '$title  ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                TextSpan(
                                  text: '– $desc',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF4B5D7A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFCED7E6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0D2B55),
              ),
            ),
            const SizedBox(height: 12),

            Obx(
              () => Column(
                children: List.generate(pdiController.faqs.length, (index) {
                  final item = pdiController.faqs[index];
                  final q = item['question'].toString();
                  final a = item['answer'].toString();
                  final bool expanded =
                      pdiController.expandedFaqIndex.value == index;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FB),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE0E6F1)),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => pdiController.toggleFaq(index),
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    q,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF0B3A73),
                                    ),
                                  ),
                                ),
                                Icon(
                                  expanded
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  color: const Color(0xFF0B3A73),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // expanded body
                        AnimatedCrossFade(
                          firstChild: const SizedBox.shrink(),
                          secondChild: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                            child: Text(
                              a,
                              style: const TextStyle(
                                fontSize: 12,
                                height: 1.4,
                                color: Color(0xFF3E4E6B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          crossFadeState: expanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 200),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

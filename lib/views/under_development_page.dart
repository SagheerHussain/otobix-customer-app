import 'package:flutter/material.dart';
import 'package:otobix_customer_app/widgets/app_bar_widget.dart';

class UnderDevelopmentPage extends StatelessWidget {
  final String screenName;
  final IconData icon;
  final Color color;
  final int? completedPercentage;
  final Widget? actionButton;
  final bool showAppBar;

  const UnderDevelopmentPage({
    super.key,
    required this.screenName,
    required this.icon,
    required this.color,
    this.completedPercentage,
    this.actionButton,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? AppBarWidget(title: screenName) : null,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 50, color: color),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                screenName,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Subtitle
              Text(
                // 'Under Development',
                'Coming Soon',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                'This feature is currently under development and will be available soon.',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Progress Indicator
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  value: completedPercentage != null
                      ? completedPercentage! / 100
                      : 0,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),

              // Progress Text
              Text(
                completedPercentage != null
                    ? '$completedPercentage% Complete'
                    : '0% Complete',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),

              actionButton ?? SizedBox.shrink(),

              // // Back to Home Button
              // ElevatedButton.icon(
              //   onPressed: () {
              //     Get.find<HomepageController>().currentIndex.value = 0;
              //   },
              //   icon: const Icon(Icons.home, size: 18),
              //   label: const Text('Back to Home'),
              //   style: ElevatedButton.styleFrom(
              //     foregroundColor: Colors.white,
              //     backgroundColor: color,
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 24,
              //       vertical: 12,
              //     ),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(25),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

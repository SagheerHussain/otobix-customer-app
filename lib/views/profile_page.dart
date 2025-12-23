import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/controllers/profile_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Obx(() {
                          final imageUrl = profileController
                              .imageUrl
                              .value; // make sure `user` is reactive

                          return CircleAvatar(
                            radius: 55,
                            backgroundImage:
                                // ignore: unnecessary_null_comparison
                                imageUrl != null && imageUrl.isNotEmpty
                                ? NetworkImage(
                                    imageUrl.startsWith('http')
                                        ? imageUrl
                                        : imageUrl,
                                  )
                                : null,
                            child:
                                // ignore: unnecessary_null_comparison
                                imageUrl == null || imageUrl.isEmpty
                                ? const Icon(Icons.person, size: 55)
                                : null,
                          );
                        }),

                        SizedBox(height: 12),
                        Text(
                          profileController.username.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profileController.useremail.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ProfileOption(
                  //   icon: Icons.description,
                  //   color: AppColors.green,
                  //   title: "Terms and Conditions",
                  //   description: "View terms and conditions.",
                  //   onTap: () {
                  //     Get.to(TermsAndConditionsPage());
                  //   },
                  // ),
                  // ProfileOption(
                  //   icon: Icons.lock,
                  //   color: AppColors.grey,
                  //   title: "Privacy Policy",
                  //   description: "View privacy policy.",
                  //   onTap: () {
                  //     Get.to(PrivacyPolicyPage());
                  //   },
                  // ),
                  // ProfileOption(
                  //   icon: Icons.menu_book,
                  //   color: AppColors.blue,
                  //   title: "Dealer Guide",
                  //   description: "View dealer guide.",
                  //   onTap: () {
                  //     Get.to(DealerGuidePage());
                  //   },
                  // ),
                  // ProfileOption(
                  //   icon: Icons.delete,
                  //   color: Colors.red,
                  //   title: "Delete Account",
                  //   description: "Delete your account securely.",
                  //   onTap: () {
                  //     Get.to(DeleteAccountPage());
                  //   },
                  // ),
                  ProfileOption(
                    icon: Icons.logout,
                    color: Colors.red,
                    title: "Logout",
                    description: "Sign out of your account securely.",
                    onTap: () {
                      profileController.logout();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String? description;
  final VoidCallback onTap;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withValues(alpha: .5),
                width: 1.2,
              ),
            ),
            child: Row(
              crossAxisAlignment: description != null
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      if (description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          description!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

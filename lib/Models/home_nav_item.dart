import 'package:flutter/widgets.dart';

class HomeNavItem {
  final String icon;
  final String title;
  final String subtitle;

  /// Use this for navigation / async checks / dialogs.
  final Future<void> Function(BuildContext context) onTap;

  HomeNavItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

// import 'package:flutter/widgets.dart';

// class HomeNavItem {
//   final String icon; // svg asset path
//   final String title;
//   final String subtitle;
//   final Widget Function() pageBuilder;

//   const HomeNavItem({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.pageBuilder,
//   });
// }

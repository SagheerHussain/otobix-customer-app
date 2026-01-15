import 'package:flutter/widgets.dart';

class HomeNavItem {
  final String icon; // svg asset path
  final String title;
  final String subtitle;
  final Widget Function() pageBuilder;

  const HomeNavItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.pageBuilder,
  });
}

import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  static const double mobileBreakpoint = 650;
  static const double tabletBreakpoint = 900;

  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static bool isMobile(BuildContext context) =>
      width(context) < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      width(context) >= mobileBreakpoint &&
          width(context) < tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      width(context) >= tabletBreakpoint;

  @override
  Widget build(BuildContext context) {
    final w = width(context);

    if (w >= tabletBreakpoint) {
      return desktop ?? tablet ?? mobile;
    } else if (w >= mobileBreakpoint) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }
}
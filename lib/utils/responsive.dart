import 'package:flutter/material.dart';

class Responsive {
  // Breakpoint checks
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  // Screen dimensions
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  // Dock icon sizes
  static double dockIconSize(BuildContext context) =>
      isMobile(context) ? 50.0 : 60.0;

  static double dockIconHoverSize(BuildContext context) =>
      isMobile(context) ? 60.0 : 80.0;

  // Dock spacing
  static double dockSpacing(BuildContext context) =>
      isMobile(context) ? 4.0 : 8.0;

  static double dockPadding(BuildContext context) =>
      isMobile(context) ? 8.0 : 12.0;

  static double dockMargin(BuildContext context) =>
      isMobile(context) ? 8.0 : 0.0;

  static double dockDividerHeight(BuildContext context) =>
      isMobile(context) ? 40.0 : 50.0;

  static double dockBorderRadius(BuildContext context) =>
      isMobile(context) ? 10.0 : 12.0;

  // Splash screen sizes
  static double splashLogoSize(BuildContext context) =>
      isMobile(context) ? 48.0 : 64.0;

  static double splashProgressWidth(BuildContext context) =>
      isMobile(context) ? 160.0 : 200.0;

  // Font sizes
  static double fontSizeSmall(BuildContext context) =>
      isMobile(context) ? 9 : 12.0;

  static double fontSizeMedium(BuildContext context) =>
      isMobile(context) ? 14.0 : 16.0;

  static double fontSizeLarge(BuildContext context) =>
      isMobile(context) ? 20.0 : 24.0;

  static double fontSizeXLarge(BuildContext context) =>
      isMobile(context) ? 28.0 : 32.0;

  // Generic responsive value helper
  static T responsiveValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet ?? desktop;
    return mobile;
  }
}

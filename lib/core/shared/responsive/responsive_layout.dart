import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    // Desktop layout
    if (size.width >= 1200) {
      return desktop ?? tablet ?? mobile;
    }
    // Tablet layout
    else if (size.width >= 600) {
      return tablet ?? mobile;
    }
    // Mobile layout
    else {
      return mobile;
    }
  }
}

// Extension to provide responsive sizing throughout the app
extension ResponsiveSize on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;

  // Returns a percentage of the screen width
  double widthPct(double percentage) => width * percentage;

  // Returns a percentage of the screen height
  double heightPct(double percentage) => height * percentage;

  // Returns adaptive padding based on screen size
  EdgeInsets get paddingDefault => EdgeInsets.symmetric(
        horizontal: ResponsiveLayout.isMobile(this) ? 16.0 : 24.0,
        vertical: ResponsiveLayout.isMobile(this) ? 12.0 : 16.0,
      );

  // Font size scaling based on device size
  double get bodyText => ResponsiveLayout.isMobile(this) ? 14.0 : 16.0;
  double get headlineText => ResponsiveLayout.isMobile(this) ? 20.0 : 24.0;
  double get titleText => ResponsiveLayout.isMobile(this) ? 16.0 : 18.0;
}

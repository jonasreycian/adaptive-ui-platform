import 'package:flutter/foundation.dart';

/// Responsive breakpoint constants (logical pixels).
///
/// mobile      < 600
/// tablet      600 – 1023
/// desktop     1024 – 1439
/// largeDesktop ≥ 1440
@immutable
class Breakpoints {
  const Breakpoints._();

  static const double mobileMax = 599;
  static const double tabletMin = 600;
  static const double tabletMax = 1023;
  static const double desktopMin = 1024;
  static const double desktopMax = 1439;
  static const double largeDesktopMin = 1440;

  static bool isMobile(double width) => width <= mobileMax;
  static bool isTablet(double width) => width >= tabletMin && width <= tabletMax;
  static bool isDesktop(double width) =>
      width >= desktopMin && width <= desktopMax;
  static bool isLargeDesktop(double width) => width >= largeDesktopMin;
}

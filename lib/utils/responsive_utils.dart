import 'package:flutter/material.dart';

/// Centralized responsive utilities for breakpoint detection and responsive values.
///
/// Three layout modes:
///   Mobile  : width < 700   — single column
///   Tablet  : 700–1099      — split adaptive
///   Desktop : 1100+         — full widescreen workbench
///   TV      : 1600+         — full bleed, larger targets
class ResponsiveUtils {
  static const double mobileBreakpoint = 700.0;
  static const double tabletBreakpoint = 1100.0;
  static const double tvBreakpoint = 1600.0;

  // Legacy alias — kept so existing isMobile() call-sites still compile
  static const double workbenchBreakpoint = tabletBreakpoint;
  static const double minViewportWidth = 320.0;
  // No hard cap on content width — TV/monitor should use full width
  static const double maxContentWidth = 1920.0;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= mobileBreakpoint && w < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  static bool isTV(BuildContext context) =>
      MediaQuery.of(context).size.width >= tvBreakpoint;

  /// Returns true if the current viewport width is 600 pixels or greater.
  /// Kept for backward compatibility — prefer isDesktop() for new code.
  static bool isDesktopLegacy(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600.0;

  /// Returns true if the viewport is very small (< 320px)
  static bool isVerySmallScreen(BuildContext context) =>
      MediaQuery.of(context).size.width < minViewportWidth;

  /// Returns the full viewport width for TV/monitor; caps at 1920 only for
  /// very large desktop monitors where you still want centred content.
  static double getContentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // TV and large monitors: use full width — no boxing
    if (isTV(context)) return width;
    // Standard desktop/tablet: unconstrained up to 1920
    return width;
  }

  /// Legacy name — now returns full width (no constraint) so TV is not boxed.
  static double getConstrainedWidth(BuildContext context) =>
      getContentWidth(context);

  /// Returns a responsive value based on the current viewport size.
  static double getResponsiveValue(
    BuildContext context, {
    required double mobile,
    required double desktop,
    double? tv,
  }) {
    if (tv != null && isTV(context)) return tv;
    return isMobile(context) ? mobile : desktop;
  }

  /// Returns a responsive value of any type based on the current viewport size.
  static T getResponsiveValueGeneric<T>(
    BuildContext context, {
    required T mobile,
    required T desktop,
    T? tv,
  }) {
    if (tv != null && isTV(context)) return tv;
    return isMobile(context) ? mobile : desktop;
  }
}

/// Spacing constants — TV mode uses larger values throughout.
class AppSpacing {
  // Mobile spacing
  static const double mobileScreenPadding = 12.0;
  static const double mobileCardSpacing = 8.0;
  static const double mobileFormFieldSpacing = 16.0;
  static const double mobileSectionSpacing = 24.0;
  static const double mobileFilterSpacing = 12.0;

  // Desktop spacing
  static const double desktopScreenPadding = 16.0;
  static const double desktopCardSpacing = 12.0;
  static const double desktopFormFieldSpacing = 16.0;
  static const double desktopSectionSpacing = 24.0;

  // TV / large monitor spacing
  static const double tvScreenPadding = 24.0;
  static const double tvCardSpacing = 16.0;
  static const double tvFormFieldSpacing = 20.0;
  static const double tvSectionSpacing = 32.0;

  // Touch targets
  static const double minTouchTarget = 44.0;
  static const double minButtonHeight = 48.0;
  static const double tvMinTouchTarget = 56.0;
  static const double tvMinButtonHeight = 60.0;

  // FAB positioning
  static const double fabMargin = 16.0;
  static const double fabSpacing = 12.0;

  static double getScreenPadding(BuildContext context) {
    if (ResponsiveUtils.isTV(context)) return tvScreenPadding;
    return ResponsiveUtils.isMobile(context)
        ? mobileScreenPadding
        : desktopScreenPadding;
  }

  static double getCardSpacing(BuildContext context) {
    if (ResponsiveUtils.isTV(context)) return tvCardSpacing;
    return ResponsiveUtils.isMobile(context)
        ? mobileCardSpacing
        : desktopCardSpacing;
  }

  static double getFormFieldSpacing(BuildContext context) {
    if (ResponsiveUtils.isTV(context)) return tvFormFieldSpacing;
    return ResponsiveUtils.isMobile(context)
        ? mobileFormFieldSpacing
        : desktopFormFieldSpacing;
  }

  static double getSectionSpacing(BuildContext context) {
    if (ResponsiveUtils.isTV(context)) return tvSectionSpacing;
    return ResponsiveUtils.isMobile(context)
        ? mobileSectionSpacing
        : desktopSectionSpacing;
  }
}

/// Typography scale — TV mode uses larger sizes for 10-foot viewing distance.
class AppTypography {
  // Mobile typography
  static const double mobileBodyText = 14.0;
  static const double mobileLabel = 12.0;
  static const double mobileHeading1 = 24.0;
  static const double mobileHeading2 = 20.0;
  static const double mobileHeading3 = 16.0;

  // Desktop typography
  static const double desktopBodyText = 14.0;
  static const double desktopLabel = 13.0;
  static const double desktopHeading1 = 32.0;
  static const double desktopHeading2 = 24.0;
  static const double desktopHeading3 = 18.0;

  // TV typography (10-foot UI)
  static const double tvBodyText = 18.0;
  static const double tvLabel = 15.0;
  static const double tvHeading1 = 40.0;
  static const double tvHeading2 = 30.0;
  static const double tvHeading3 = 22.0;

  static const double lineHeight = 1.4;

  static double getBodyTextSize(BuildContext context) {
    if (ResponsiveUtils.isTV(context)) return tvBodyText;
    return ResponsiveUtils.isMobile(context) ? mobileBodyText : desktopBodyText;
  }

  static double getLabelSize(BuildContext context) {
    if (ResponsiveUtils.isTV(context)) return tvLabel;
    return ResponsiveUtils.isMobile(context) ? mobileLabel : desktopLabel;
  }

  static double getHeading1Size(BuildContext context) {
    if (ResponsiveUtils.isTV(context)) return tvHeading1;
    return ResponsiveUtils.isMobile(context) ? mobileHeading1 : desktopHeading1;
  }

  static double getHeading2Size(BuildContext context) {
    if (ResponsiveUtils.isTV(context)) return tvHeading2;
    return ResponsiveUtils.isMobile(context) ? mobileHeading2 : desktopHeading2;
  }

  static double getHeading3Size(BuildContext context) {
    if (ResponsiveUtils.isTV(context)) return tvHeading3;
    return ResponsiveUtils.isMobile(context) ? mobileHeading3 : desktopHeading3;
  }

  static TextStyle getBodyTextStyle(BuildContext context,
      {FontWeight? fontWeight, Color? color}) {
    return TextStyle(
      fontSize: getBodyTextSize(context),
      height: lineHeight,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle getLabelStyle(BuildContext context,
      {FontWeight? fontWeight, Color? color}) {
    return TextStyle(
      fontSize: getLabelSize(context),
      height: lineHeight,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle getHeading1Style(BuildContext context,
      {FontWeight? fontWeight, Color? color}) {
    return TextStyle(
      fontSize: getHeading1Size(context),
      height: lineHeight,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color,
    );
  }

  static TextStyle getHeading2Style(BuildContext context,
      {FontWeight? fontWeight, Color? color}) {
    return TextStyle(
      fontSize: getHeading2Size(context),
      height: lineHeight,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color,
    );
  }

  static TextStyle getHeading3Style(BuildContext context,
      {FontWeight? fontWeight, Color? color}) {
    return TextStyle(
      fontSize: getHeading3Size(context),
      height: lineHeight,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color,
    );
  }
}

/// Icon size constants.
class AppIconSizes {
  static const double listItem = 24.0;
  static const double button = 20.0;
  static const double appBar = 24.0;
  static const double fab = 24.0;
  static const double cardDecorative = 28.0;
  static const double cardDecorativeLarge = 36.0;
  static const double tvListItem = 32.0;
  static const double tvButton = 28.0;

  static double getCardDecorativeSize(BuildContext context) {
    if (ResponsiveUtils.isTV(context)) return tvListItem;
    return ResponsiveUtils.isMobile(context)
        ? cardDecorative
        : cardDecorativeLarge;
  }
}

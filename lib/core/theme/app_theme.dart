import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade package to version 8.0.2.
///
/// Use in [MaterialApp] like this:
///
/// MaterialApp(
///  theme: AppTheme.light,
///  darkTheme: AppTheme.dark,
///  :
/// );
sealed class AppTheme {
  // The defined light theme.
  static ThemeData light = FlexThemeData.light(
    scaffoldBackground: const Color.fromRGBO(241, 243, 248, 1),
    textTheme: GoogleFonts.promptTextTheme(),
    colors: const FlexSchemeColor(
      // Custom colors
      primary: Color(0xFFCF1C24),
      primaryContainer: Color(0xFFFFFFFF),
      primaryLightRef: Color(0xFFCF1C24),
      secondary: Color(0xFFCF1C24),
      secondaryContainer: Color(0xFFCF1C24),
      secondaryLightRef: Color(0xFFCF1C24),
      tertiary: Color(0xFFCF1C24),
      tertiaryContainer: Color(0xFFFFFFFF),
      tertiaryLightRef: Color(0xFFCF1C24),
      appBarColor: Color(0xFFCF1C24),
      error: Color(0xFFBA1A1A),
      errorContainer: Color(0xFFFFDAD6),
    ),
    lightIsWhite: true,
    surfaceTint: const Color(0xFFCF1C24),
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      splashType: FlexSplashType.inkSplash,
      defaultRadius: 8.0,
      textButtonRadius: 40.0,
      filledButtonRadius: 40.0,
      filledButtonSchemeColor: SchemeColor.secondaryContainer,
      elevatedButtonRadius: 40.0,
      outlinedButtonRadius: 40.0,
      outlinedButtonOutlineSchemeColor: SchemeColor.primary,
      toggleButtonsRadius: 8.0,
      segmentedButtonRadius: 40.0,
      segmentedButtonSchemeColor: SchemeColor.primary,
      switchSchemeColor: SchemeColor.tertiary,
      switchThumbFixedSize: true,
      inputDecoratorBorderSchemeColor: SchemeColor.surfaceTint,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorRadius: 10.0,
      inputSelectionSchemeColor: SchemeColor.primary,
      chipSchemeColor: SchemeColor.onPrimary,
      cardRadius: 18.0,
      popupMenuRadius: 10.0,
      dialogBackgroundSchemeColor: SchemeColor.tertiaryFixed,
      appBarScrolledUnderElevation: 0.0,
      bottomNavigationBarMutedUnselectedLabel: false,
      bottomNavigationBarMutedUnselectedIcon: false,
      bottomNavigationBarUnselectedLabelSize: 14,
      navigationBarUnselectedLabelSchemeColor: SchemeColor.onPrimaryContainer,
      navigationBarUnselectedIconSchemeColor: SchemeColor.onPrimaryContainer,
      navigationBarIndicatorSchemeColor: SchemeColor.onPrimary,
      navigationBarBackgroundSchemeColor: SchemeColor.onSecondary,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    keyColors: const FlexKeyColors(
      useSecondary: true,
      useTertiary: true,
      useError: true,
      keepPrimary: true,
      keepSecondary: true,
      keepTertiary: true,
      keepPrimaryContainer: true,
      keepSecondaryContainer: true,
    ),
    tones: FlexSchemeVariant.vividBackground.tones(Brightness.light),
    visualDensity: VisualDensity.standard,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
    swapLegacyOnMaterial3: true,
  );
  // The defined dark theme.
  static ThemeData dark = FlexThemeData.dark(
    scaffoldBackground: const Color.fromRGBO(241, 243, 248, 1),
    textTheme: GoogleFonts.promptTextTheme(),
    colors: const FlexSchemeColor(
      // Custom colors
      primary: Color(0xFF9FC9FF),
      primaryContainer: Color(0xFF00325B),
      primaryLightRef: Color(0xFFCF1C24),
      secondary: Color(0xFFFFB59D),
      secondaryContainer: Color(0xFF872100),
      secondaryLightRef: Color(0xFFCF1C24),
      tertiary: Color(0xFF86D2E1),
      tertiaryContainer: Color(0xFF004E59),
      tertiaryLightRef: Color(0xFFCF1C24),
      appBarColor: Color(0xFFCF1C24),
      error: Color(0xFFFFB4AB),
      errorContainer: Color(0xFF93000A),
    ),
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      splashType: FlexSplashType.inkSplash,
      defaultRadius: 8.0,
      textButtonRadius: 40.0,
      filledButtonRadius: 40.0,
      filledButtonSchemeColor: SchemeColor.secondaryContainer,
      elevatedButtonRadius: 40.0,
      outlinedButtonRadius: 40.0,
      outlinedButtonOutlineSchemeColor: SchemeColor.primary,
      toggleButtonsRadius: 8.0,
      segmentedButtonRadius: 40.0,
      segmentedButtonSchemeColor: SchemeColor.primary,
      switchSchemeColor: SchemeColor.tertiary,
      switchThumbFixedSize: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorRadius: 10.0,
      chipSchemeColor: SchemeColor.onPrimary,
      cardRadius: 18.0,
      popupMenuRadius: 10.0,
      bottomNavigationBarMutedUnselectedLabel: false,
      bottomNavigationBarMutedUnselectedIcon: false,
      bottomNavigationBarUnselectedLabelSize: 14,
      navigationBarUnselectedLabelSchemeColor: SchemeColor.onPrimaryContainer,
      navigationBarUnselectedIconSchemeColor: SchemeColor.onPrimaryContainer,
      navigationBarIndicatorSchemeColor: SchemeColor.onPrimary,
      navigationBarBackgroundSchemeColor: SchemeColor.onSecondary,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    keyColors: const FlexKeyColors(useSecondary: true, useTertiary: true, useError: true),
    tones: FlexSchemeVariant.vividBackground.tones(Brightness.dark),
    visualDensity: VisualDensity.standard,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
    swapLegacyOnMaterial3: true,
  );
}

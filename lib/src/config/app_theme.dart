import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AppTheme {
  // Core Brand Colors
  static const Color primaryColor = Color(0xFF3366FF); // Vibrant blue
  static const Color secondaryColor = Color(0xFFFF3B30); // Vibrant red
  static const Color accentColor = Color(0xFF00C851); // Vibrant green
  static const Color midToneColor = Color(
    0xFF6E7F80,
  ); // Sophisticated slate blue-gray

  // Light Theme Colors
  static const Color _lightBackground = Color(0xFFFFFFFF); // Pure white
  static const Color _lightSurface = Color(0xFFF8F9FA); // Slightly off-white
  static const Color _lightCard = Color(0xFFFFFFFF); // Pure white cards
  static const Color _lightInput = Color(
    0xFFF1F3F5,
  ); // Very light gray for inputs
  static const Color _lightDivider = Color(0xFFE9ECEF); // Light divider
  static const Color _lightDisabled = Color(0xFFCED4DA); // Disabled elements

  // Dark Theme Colors (OLED optimized)
  static const Color _darkBackground = Color(0xFF000000); // True black for OLED
  static const Color _darkSurface = Color(
    0xFF121212,
  ); // Slightly elevated surfaces
  static const Color _darkCard = Color(0xFF1E1E1E); // Cards
  static const Color _darkInput = Color(0xFF242424); // Input fields
  static const Color _darkDivider = Color(0xFF333333); // Dividers
  static const Color _darkDisabled = Color(0xFF424242); // Disabled elements

  // Text Colors
  static const Color _lightPrimaryText = Color(0xFF212529); // Almost black
  static const Color _lightSecondaryText = Color(0xFF495057); // Dark gray
  static const Color _lightHintText = Color(0xFF868E96); // Medium gray

  static const Color _darkPrimaryText = Color(0xFFFFFFFF); // Pure white
  static const Color _darkSecondaryText = Color(0xFFE9ECEF); // Off-white
  static const Color _darkHintText = Color(0xFFADB5BD); // Light gray

  // Font Families
  static String getFontFamily(String locale, {bool isBold = false}) {
    if (locale == 'ckb') {
      return 'NRT'; // Kurdish uses NRT for both regular and bold
    } else if (locale == 'ar') {
      return 'Tajawal'; // Arabic uses Tajawal
    } else {
      return 'RobotoCustom'; // Default to Roboto for other languages
    }
  }

  // Main Theme Getter
  static ThemeData getTheme({required bool isDark, required String locale}) {
    final isRTL = locale == 'ckb' || locale == 'ar';

    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      useMaterial3: true,
      applyElevationOverlayColor: isDark,

      // Color Scheme
      colorScheme: isDark ? _darkColorScheme : _lightColorScheme,

      // Scaffold
      scaffoldBackgroundColor: isDark ? _darkBackground : _lightBackground,
      canvasColor: isDark ? _darkBackground : _lightBackground,

      // Typography
      fontFamily: getFontFamily(locale),
      textTheme: _buildTextTheme(locale, isDark),
      primaryTextTheme: _buildTextTheme(locale, isDark),

      // App Bar
      appBarTheme: _buildAppBarTheme(locale, isDark),

      // Cards
      cardTheme: _buildCardTheme(isDark),

      // Input Decoration
      inputDecorationTheme: _buildInputTheme(locale, isDark),

      // Buttons
      elevatedButtonTheme: _buildElevatedButtonTheme(locale),
      filledButtonTheme: _buildFilledButtonTheme(locale),
      outlinedButtonTheme: _buildOutlinedButtonTheme(locale, isDark),
      textButtonTheme: _buildTextButtonTheme(locale, isDark),

      // Bottom Navigation
      bottomNavigationBarTheme: _buildBottomNavTheme(isDark),

      // Navigation Bar (Material 3)
      navigationBarTheme: _buildNavigationBarTheme(isDark),

      // Icons
      iconTheme: _buildIconTheme(isDark),
      primaryIconTheme: _buildIconTheme(isDark),

      // Floating Action Button
      floatingActionButtonTheme: _buildFABTheme(isDark),

      // Dividers
      dividerTheme: _buildDividerTheme(isDark),

      // Chips
      chipTheme: _buildChipTheme(isDark, locale),

      // Dialogs
      dialogTheme: _buildDialogTheme(locale, isDark),

      // SnackBar
      snackBarTheme: _buildSnackBarTheme(isDark),

      // Bottom Sheet
      bottomSheetTheme: _buildBottomSheetTheme(isDark),

      // Progress Indicators
      progressIndicatorTheme: _buildProgressIndicatorTheme(isDark),

      // Tooltips
      tooltipTheme: _buildTooltipTheme(isDark, locale),

      // Popup Menu
      popupMenuTheme: _buildPopupMenuTheme(isDark, locale),

      // Tab Bar
      tabBarTheme: _buildTabBarTheme(isDark, locale),

      // Switch
      switchTheme: _buildSwitchTheme(isDark),

      // Slider
      sliderTheme: _buildSliderTheme(isDark),

      // Radio
      radioTheme: _buildRadioTheme(isDark),

      // Checkbox
      checkboxTheme: _buildCheckboxTheme(isDark),

      // Data Table
      dataTableTheme: _buildDataTableTheme(isDark, locale),
    );
  }

  // Color Schemes
  static final ColorScheme _lightColorScheme = ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryColor,
    tertiary: accentColor,
    surface: _lightSurface,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: _lightPrimaryText,
    error: secondaryColor,
    onError: Colors.white,
    outline: _lightDivider,
    outlineVariant: _lightHintText.withOpacity(0.3),
    scrim: Colors.black.withOpacity(0.5),
    inverseSurface: _darkPrimaryText,
    onInverseSurface: _darkBackground,
    surfaceContainerHighest: _lightInput,
    onSurfaceVariant: _lightSecondaryText,
  );

  static final ColorScheme _darkColorScheme = ColorScheme.dark(
    primary: primaryColor,
    secondary: secondaryColor,
    tertiary: accentColor,
    surface: _darkSurface,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: _darkPrimaryText,
    error: secondaryColor,
    onError: Colors.white,
    outline: _darkDivider,
    outlineVariant: _darkHintText.withOpacity(0.3),
    scrim: Colors.black.withOpacity(0.8),
    inverseSurface: _lightPrimaryText,
    onInverseSurface: _lightBackground,
    surfaceContainerHighest: _darkInput,
    onSurfaceVariant: _darkSecondaryText,
  );

  // Text Theme Builder
  static TextTheme _buildTextTheme(String locale, bool isDark) {
    final primaryTextColor = isDark ? _darkPrimaryText : _lightPrimaryText;
    final secondaryTextColor = isDark
        ? _darkSecondaryText
        : _lightSecondaryText;
    final hintTextColor = isDark ? _darkHintText : _lightHintText;

    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: getFontFamily(locale, isBold: true),
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
        fontSize: 57,
        height: 1.12,
        letterSpacing: -0.25,
      ),
      displayMedium: TextStyle(
        fontFamily: getFontFamily(locale, isBold: true),
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
        fontSize: 45,
        height: 1.16,
      ),
      displaySmall: TextStyle(
        fontFamily: getFontFamily(locale, isBold: true),
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
        fontSize: 36,
        height: 1.22,
      ),
      headlineLarge: TextStyle(
        fontFamily: getFontFamily(locale, isBold: true),
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
        fontSize: 32,
        height: 1.25,
      ),
      headlineMedium: TextStyle(
        fontFamily: getFontFamily(locale, isBold: true),
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
        fontSize: 28,
        height: 1.29,
      ),
      headlineSmall: TextStyle(
        fontFamily: getFontFamily(locale, isBold: true),
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
        fontSize: 24,
        height: 1.33,
      ),
      titleLarge: TextStyle(
        fontFamily: getFontFamily(locale, isBold: true),
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
        fontSize: 22,
        height: 1.27,
      ),
      titleMedium: TextStyle(
        fontFamily: getFontFamily(locale),
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
        fontSize: 16,
        height: 1.5,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        fontFamily: getFontFamily(locale),
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
        fontSize: 14,
        height: 1.43,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(
        fontFamily: getFontFamily(locale),
        color: secondaryTextColor,
        fontSize: 16,
        height: 1.5,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: getFontFamily(locale),
        color: secondaryTextColor,
        fontSize: 14,
        height: 1.43,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontFamily: getFontFamily(locale),
        color: hintTextColor,
        fontSize: 12,
        height: 1.33,
        letterSpacing: 0.4,
      ),
      labelLarge: TextStyle(
        fontFamily: getFontFamily(locale),
        fontWeight: FontWeight.w500,
        color: primaryTextColor,
        fontSize: 14,
        height: 1.43,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontFamily: getFontFamily(locale),
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
        fontSize: 12,
        height: 1.33,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontFamily: getFontFamily(locale),
        fontWeight: FontWeight.w500,
        color: hintTextColor,
        fontSize: 11,
        height: 1.45,
        letterSpacing: 0.5,
      ),
    );
  }

  // App Bar Theme
  static AppBarTheme _buildAppBarTheme(String locale, bool isDark) {
    return AppBarTheme(
      backgroundColor: isDark ? _darkSurface : _lightSurface,
      foregroundColor: isDark ? _darkPrimaryText : _lightPrimaryText,
      elevation: 0,
      scrolledUnderElevation: 2,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: getFontFamily(locale, isBold: true),
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: isDark ? _darkPrimaryText : _lightPrimaryText,
      ),
      iconTheme: IconThemeData(
        color: isDark ? _darkPrimaryText : _lightPrimaryText,
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: isDark ? _darkPrimaryText : _lightPrimaryText,
        size: 24,
      ),
    );
  }

  // Card Theme
  static CardThemeData _buildCardTheme(bool isDark) {
    return CardThemeData(
      color: isDark ? _darkCard : _lightCard,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(isDark ? 0.5 : 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? _darkDivider : _lightDivider,
          width: 0.5,
        ),
      ),
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
    );
  }

  // Input Decoration Theme
  static InputDecorationTheme _buildInputTheme(String locale, bool isDark) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? _darkInput : _lightInput,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: secondaryColor.withOpacity(0.8),
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: secondaryColor, width: 2),
      ),
      hintStyle: TextStyle(
        fontFamily: getFontFamily(locale),
        color: isDark ? _darkHintText : _lightHintText,
        fontSize: 16,
      ),
      labelStyle: TextStyle(
        fontFamily: getFontFamily(locale),
        color: isDark ? _darkSecondaryText : _lightSecondaryText,
        fontSize: 16,
      ),
      errorStyle: TextStyle(
        fontFamily: getFontFamily(locale),
        color: secondaryColor,
        fontSize: 12,
      ),
      prefixIconColor: isDark ? _darkHintText : _lightHintText,
      suffixIconColor: isDark ? _darkHintText : _lightHintText,
    );
  }

  // Button Themes
  static ElevatedButtonThemeData _buildElevatedButtonTheme(String locale) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: TextStyle(
          fontFamily: getFontFamily(locale, isBold: true),
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
    );
  }

  static FilledButtonThemeData _buildFilledButtonTheme(String locale) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: TextStyle(
          fontFamily: getFontFamily(locale, isBold: true),
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(
    String locale,
    bool isDark,
  ) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: isDark ? _darkPrimaryText : _lightPrimaryText,
        side: BorderSide(
          color: isDark ? _darkDivider : _lightDivider,
          width: 1,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: TextStyle(
          fontFamily: getFontFamily(locale, isBold: true),
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme(String locale, bool isDark) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: TextStyle(
          fontFamily: getFontFamily(locale, isBold: true),
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  // Bottom Navigation Theme
  static BottomNavigationBarThemeData _buildBottomNavTheme(bool isDark) {
    return BottomNavigationBarThemeData(
      backgroundColor: isDark ? _darkCard : _lightCard,
      selectedItemColor: primaryColor,
      unselectedItemColor: isDark ? _darkHintText : _lightHintText,
      showUnselectedLabels: true,
      elevation: 4,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Navigation Bar Theme (Material 3)
  static NavigationBarThemeData _buildNavigationBarTheme(bool isDark) {
    return NavigationBarThemeData(
      backgroundColor: isDark ? _darkCard : _lightCard,
      indicatorColor: primaryColor.withOpacity(0.2),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      elevation: 2,
      height: 64,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(fontSize: 12, fontWeight: FontWeight.w600);
        }
        return const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
      }),
    );
  }

  // Icon Theme
  static IconThemeData _buildIconTheme(bool isDark) {
    return IconThemeData(
      color: isDark ? _darkPrimaryText : _lightPrimaryText,
      size: 24,
    );
  }

  // Floating Action Button Theme
  static FloatingActionButtonThemeData _buildFABTheme(bool isDark) {
    return FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      extendedPadding: const EdgeInsets.symmetric(horizontal: 24),
      extendedTextStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }

  // Divider Theme
  static DividerThemeData _buildDividerTheme(bool isDark) {
    return DividerThemeData(
      color: isDark ? _darkDivider : _lightDivider,
      thickness: 1,
      space: 1,
      indent: 16,
      endIndent: 16,
    );
  }

  // Chip Theme
  static ChipThemeData _buildChipTheme(bool isDark, String locale) {
    return ChipThemeData(
      backgroundColor: isDark ? _darkInput : _lightInput,
      selectedColor: primaryColor.withOpacity(0.2),
      disabledColor: isDark ? _darkDisabled : _lightDisabled,
      labelPadding: const EdgeInsets.symmetric(horizontal: 12),
      labelStyle: TextStyle(
        fontFamily: getFontFamily(locale),
        color: isDark ? _darkPrimaryText : _lightPrimaryText,
        fontSize: 14,
      ),
      secondaryLabelStyle: TextStyle(
        fontFamily: getFontFamily(locale),
        color: isDark ? _darkPrimaryText : _lightPrimaryText,
        fontSize: 14,
      ),
      padding: const EdgeInsets.all(4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isDark ? _darkDivider : _lightDivider,
          width: 0.5,
        ),
      ),
      side: BorderSide.none,
    );
  }

  // Dialog Theme
  static DialogThemeData _buildDialogTheme(String locale, bool isDark) {
    return DialogThemeData(
      backgroundColor: isDark ? _darkCard : _lightCard,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? _darkDivider : _lightDivider,
          width: 0.5,
        ),
      ),
      titleTextStyle: TextStyle(
        fontFamily: getFontFamily(locale, isBold: true),
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: isDark ? _darkPrimaryText : _lightPrimaryText,
      ),
      contentTextStyle: TextStyle(
        fontFamily: getFontFamily(locale),
        fontSize: 16,
        color: isDark ? _darkSecondaryText : _lightSecondaryText,
      ),
      alignment: Alignment.center,
      actionsPadding: const EdgeInsets.all(16),
    );
  }

  // SnackBar Theme
  static SnackBarThemeData _buildSnackBarTheme(bool isDark) {
    return SnackBarThemeData(
      backgroundColor: isDark ? _darkCard : _lightCard,
      actionTextColor: primaryColor,
      contentTextStyle: TextStyle(
        color: isDark ? _darkPrimaryText : _lightPrimaryText,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isDark ? _darkDivider : _lightDivider,
          width: 0.5,
        ),
      ),
      elevation: 4,
      behavior: SnackBarBehavior.floating,
      insetPadding: const EdgeInsets.all(16),
    );
  }

  // Bottom Sheet Theme
  static BottomSheetThemeData _buildBottomSheetTheme(bool isDark) {
    return BottomSheetThemeData(
      backgroundColor: isDark ? _darkCard : _lightCard,
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  // Progress Indicator Theme
  static ProgressIndicatorThemeData _buildProgressIndicatorTheme(bool isDark) {
    return ProgressIndicatorThemeData(
      color: primaryColor,
      linearTrackColor: isDark ? _darkDivider : _lightDivider,
      circularTrackColor: isDark ? _darkDivider : _lightDivider,
      refreshBackgroundColor: isDark ? _darkCard : _lightCard,
    );
  }

  // Tooltip Theme
  static TooltipThemeData _buildTooltipTheme(bool isDark, String locale) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: isDark ? _darkSurface : _lightSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? _darkDivider : _lightDivider,
          width: 0.5,
        ),
      ),
      textStyle: TextStyle(
        fontFamily: getFontFamily(locale),
        color: isDark ? _darkPrimaryText : _lightPrimaryText,
        fontSize: 12,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      waitDuration: const Duration(milliseconds: 500),
      showDuration: const Duration(seconds: 3),
    );
  }

  // Popup Menu Theme
  static PopupMenuThemeData _buildPopupMenuTheme(bool isDark, String locale) {
    return PopupMenuThemeData(
      color: isDark ? _darkCard : _lightCard,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isDark ? _darkDivider : _lightDivider,
          width: 0.5,
        ),
      ),
      textStyle: TextStyle(
        fontFamily: getFontFamily(locale),
        color: isDark ? _darkPrimaryText : _lightPrimaryText,
        fontSize: 14,
      ),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            fontFamily: getFontFamily(locale, isBold: true),
            color: primaryColor,
            fontSize: 14,
          );
        }
        return TextStyle(
          fontFamily: getFontFamily(locale),
          color: isDark ? _darkPrimaryText : _lightPrimaryText,
          fontSize: 14,
        );
      }),
    );
  }

  // Tab Bar Theme
  static TabBarThemeData _buildTabBarTheme(bool isDark, String locale) {
    return TabBarThemeData(
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: primaryColor,
      unselectedLabelColor: isDark ? _darkHintText : _lightHintText,
      labelStyle: TextStyle(
        fontFamily: getFontFamily(locale, isBold: true),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: getFontFamily(locale),
        fontSize: 14,
      ),
    );
  }

  // Switch Theme
  static SwitchThemeData _buildSwitchTheme(bool isDark) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return isDark ? _darkHintText : _lightHintText;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor.withOpacity(0.5);
        }
        return isDark ? _darkDivider : _lightDivider;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor.withOpacity(0.5);
        }
        return isDark ? _darkDivider : _lightDivider;
      }),
    );
  }

  // Slider Theme
  static SliderThemeData _buildSliderTheme(bool isDark) {
    return SliderThemeData(
      activeTrackColor: primaryColor,
      inactiveTrackColor: isDark ? _darkDivider : _lightDivider,
      thumbColor: primaryColor,
      overlayColor: primaryColor.withOpacity(0.2),
      valueIndicatorColor: primaryColor,
      activeTickMarkColor: primaryColor.withOpacity(0.8),
      inactiveTickMarkColor: isDark ? _darkHintText : _lightHintText,
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    );
  }

  // Radio Theme
  static RadioThemeData _buildRadioTheme(bool isDark) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return isDark ? _darkHintText : _lightHintText;
      }),
    );
  }

  // Checkbox Theme
  static CheckboxThemeData _buildCheckboxTheme(bool isDark) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return isDark ? _darkHintText : _lightHintText;
      }),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: BorderSide(
        color: isDark ? _darkDivider : _lightDivider,
        width: 1.5,
      ),
    );
  }

  // Data Table Theme
  static DataTableThemeData _buildDataTableTheme(bool isDark, String locale) {
    return DataTableThemeData(
      dataRowColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor.withOpacity(0.2);
        }
        return Colors.transparent;
      }),
      headingRowColor: WidgetStateProperty.resolveWith((states) {
        return isDark ? _darkInput : _lightInput;
      }),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? _darkDivider : _lightDivider,
            width: 0.5,
          ),
        ),
      ),
      dataTextStyle: TextStyle(
        fontFamily: getFontFamily(locale),
        color: isDark ? _darkPrimaryText : _lightPrimaryText,
        fontSize: 14,
      ),
      headingTextStyle: TextStyle(
        fontFamily: getFontFamily(locale, isBold: true),
        color: isDark ? _darkPrimaryText : _lightPrimaryText,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      dividerThickness: 0.5,
      horizontalMargin: 16,
      columnSpacing: 24,
    );
  }

  // Convenience methods
  static ThemeData light(String locale) =>
      getTheme(isDark: false, locale: locale);
  static ThemeData dark(String locale) =>
      getTheme(isDark: true, locale: locale);
}

import 'package:flutter/material.dart'

class AppTheme {
  // ==================== Colors ====================
  static const Color primaryColor = Color(0xFF3B82F6); // أزرق فاتح
  static const Color primaryDarkColor = Color(0xFF1E3A8A); // أزرق داكن
  static const Color secondaryColor = Color(0xFF10B981); // أخضر
  static const Color accentColor = Color(0xFF8B5CF6); // بنفسجي
  
  static const Color backgroundColor = Color(0xFFF9FAFB); // أبيض
  static const Color surfaceColor = Color(0xFFFFFFFF); // أبيض نقي
  static const Color cardColor = Color(0xFFF3F4F6); // رمادي فاتح
  
  static const Color textPrimaryColor = Color(0xFF1F2937); // أسود رمادي
  static const Color textSecondaryColor = Color(0xFF6B7280); // رمادي
  static const Color greyColor = Color(0xFF9CA3AF); // رمادي فاتح
  
  static const Color successColor = Color(0xFF10B981); // أخضر
  static const Color warningColor = Color(0xFFF59E0B); // برتقالي
  static const Color errorColor = Color(0xFFEF4444); // أحمر
  static const Color infoColor = Color(0xFF3B82F6); // أزرق
  
  // ==================== Padding ====================
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // ==================== Border Radius ====================
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  
  // ==================== Font Sizes ====================
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeHeading = 24.0;
  
  // ==================== Theme Data ====================
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: fontSizeXLarge,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: const BorderSide(color: greyColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: const BorderSide(color: greyColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: paddingMedium,
        vertical: paddingMedium,
      ),
      hintStyle: const TextStyle(color: textSecondaryColor),
    ),
    
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: paddingLarge,
          vertical: paddingMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
        textStyle: const TextStyle(
          fontSize: fontSizeLarge,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        padding: const EdgeInsets.symmetric(
          horizontal: paddingLarge,
          vertical: paddingMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
      ),
    ),
    
    cardTheme: CardTheme(
      color: surfaceColor,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusLarge),
      ),
    ),
    
    chipTheme: ChipThemeData(
      backgroundColor: cardColor,
      selectedColor: primaryColor,
      labelStyle: const TextStyle(
        color: textPrimaryColor,
        fontSize: fontSizeMedium,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusSmall),
      ),
    ),
  );
}

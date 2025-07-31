import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  // Material 3 Color Scheme
  static final ColorScheme _colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
    primary: AppColors.primary,
    secondary: AppColors.accent,
    background: AppColors.background,
    surface: AppColors.background,
    onPrimary: AppColors.textLight,
    onSecondary: AppColors.textLight,
    onBackground: AppColors.text,
    onSurface: AppColors.text,
    error: AppColors.error,
  );

  // Основная тема Material 3
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: _colorScheme,
    
    // AppBar Theme - используем дефолтные Material настройки
    appBarTheme: const AppBarTheme(
      elevation: 4,
      centerTitle: false,
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(8),
    ),

    // ElevatedButton Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // TextButton Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // OutlinedButton Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    // FloatingActionButton Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryLight,
      foregroundColor: AppColors.textLight,
      elevation: 6,
      focusElevation: 8,
      hoverElevation: 8,
      highlightElevation: 8,
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.grey.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.grey.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.primary,
      selectedItemColor: AppColors.accent,
      unselectedItemColor: AppColors.textLight,
      type: BottomNavigationBarType.fixed,
    ),

    // Bottom App Bar Theme
    bottomAppBarTheme: const BottomAppBarTheme(
      color: AppColors.primary,
      elevation: 8,
    ),

    // List Tile Theme
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.grey.withOpacity(0.1),
      selectedColor: AppColors.primary,
      labelStyle: const TextStyle(color: AppColors.text),
      secondaryLabelStyle: const TextStyle(color: AppColors.textLight),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.background,
      elevation: 16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
    ),

    // Snack Bar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.primary,
      contentTextStyle: const TextStyle(color: AppColors.textLight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      behavior: SnackBarBehavior.floating,
    ),

    // Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.grey.withOpacity(0.3),
      thumbColor: AppColors.accent,
      overlayColor: AppColors.primary.withOpacity(0.1),
      valueIndicatorColor: AppColors.primary,
      valueIndicatorTextStyle: const TextStyle(color: AppColors.textLight),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.text,
      size: 24,
    ),

    // Text Theme
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.text,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.text,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.text,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
    ),
  );

  // Статус цвета для дней недели
  static Color getDayStatusColor(String date, bool isToday, bool isPast, bool hasTraining) {
    if (isToday) {
      return AppColors.completedGreen;
    } else if (isPast) {
      return AppColors.pastGrey;
    } else if (hasTraining) {
      return AppColors.background;
    } else {
      return AppColors.background;
    }
  }

  // Цвет для иконки статуса дня
  static Color getDayIconColor(bool hasTraining) {
    return hasTraining ? AppColors.accent : AppColors.grey;
  }

  // Цвет границы для контейнера дня
  static Color getDayBorderColor(bool hasTraining) {
    return hasTraining ? AppColors.primary : AppColors.grey.withOpacity(0.3);
  }
}

// Устаревшие стили для совместимости (будут удалены после полной миграции)
class LegacyAppTheme {
  static final containerDecoration = BoxDecoration(
    boxShadow: const [
      BoxShadow(
        color: AppColors.grey,
        spreadRadius: 2,
        blurRadius: 5,
        offset: Offset(3, 7),
      ),
    ],
    color: AppColors.background,
    border: Border.all(
      width: 3.0,
      color: AppColors.primary,
    ),
    borderRadius: BorderRadius.circular(16),
  );

  static const inputDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
    filled: true,
    fillColor: AppColors.background,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
    ),
  );

  static const roundInputDecoration = InputDecoration(
    filled: true,
    fillColor: AppColors.background,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
    ),
  );

  static final elevatedButtonStyle = ElevatedButton.styleFrom(
    elevation: 8,
    backgroundColor: AppColors.primary,
    fixedSize: const Size(200, 50),
  );

  static final fabStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) {
        return AppColors.grey;
      }
      return AppColors.primaryLight;
    }),
    foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.disabled)) {
        return AppColors.grey;
      }
      return AppColors.textLight;
    }),
    elevation: MaterialStateProperty.resolveWith<double>((states) {
      if (states.contains(MaterialState.pressed)) {
        return 8;
      }
      return 6;
    }),
  );

  static final sliderThemeData = SliderThemeData(
    trackHeight: 15.0,
    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15.0),
    overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
    activeTrackColor: AppColors.primary,
    inactiveTrackColor: AppColors.grey.withOpacity(0.5),
    overlayColor: AppColors.success.withAlpha(52),
    thumbColor: AppColors.accent,
  );
} 
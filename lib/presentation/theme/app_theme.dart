import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
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
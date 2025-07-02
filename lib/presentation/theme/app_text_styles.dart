import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const heading1 = TextStyle(
    fontSize: 30,
    color: AppColors.textLight,
    fontWeight: FontWeight.bold,
  );

  static const heading2 = TextStyle(
    fontSize: 24,
    color: AppColors.textLight,
    fontWeight: FontWeight.bold,
  );

  static const heading3 = TextStyle(
    fontSize: 20,
    color: AppColors.text,
    fontWeight: FontWeight.bold,
  );

  static const body1 = TextStyle(
    fontSize: 16,
    color: AppColors.text,
    fontWeight: FontWeight.w600,
  );

  static const body2 = TextStyle(
    fontSize: 14,
    color: AppColors.text,
  );

  static const button = TextStyle(
    fontSize: 24,
    color: AppColors.textLight,
    fontWeight: FontWeight.normal,
  );

  static const input = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
} 
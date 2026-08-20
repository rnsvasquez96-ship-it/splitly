import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const heading = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const subtitle = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
  );

  static const body = TextStyle(fontSize: 15, color: AppColors.textPrimary);

  static const caption = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );
}

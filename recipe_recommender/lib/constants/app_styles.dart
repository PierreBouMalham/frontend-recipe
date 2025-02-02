import 'package:flutter/material.dart';
import 'app_colors.dart';
 
class AppStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
 
  static const TextStyle heading2 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
 
  static const TextStyle bodyText = TextStyle(
    fontSize: 16.0,
    color: AppColors.textSecondary,
  );
 
  static const TextStyle buttonText = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
 
  static const TextStyle errorText = TextStyle(
    fontSize: 14.0,
    color: AppColors.error,
  );
}
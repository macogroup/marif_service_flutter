import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF0A0F1C);
  static const Color card = Color(0xFF121826);
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFF9AA5B1);
  static const Color accentBlue = Color(0xFF1E90FF);
  static const Color currencyYellow = Color(0xFFFFD54F);
}

class AppInsets {
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
}

class AppRadius {
  static const double r12 = 12;
}

class AssetPaths {
  static const String avatars = 'assets/images/avatars';
  static const String data = 'assets/data';

  static String avatar(String name) => '$avatars/$name';
  static String json(String name) => '$data/$name';
}

enum IdealTypeFilter { all, cute, sexy, funny }

enum RecommendTab { all, women, men }



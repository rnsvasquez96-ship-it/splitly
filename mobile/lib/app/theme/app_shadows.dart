import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static List<BoxShadow> small = [
    BoxShadow(
      color: Colors.black.withValues(alpha: .04),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.black.withValues(alpha: .06),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> large = [
    BoxShadow(
      color: Colors.black.withValues(alpha: .08),
      blurRadius: 28,
      offset: const Offset(0, 12),
    ),
  ];
}

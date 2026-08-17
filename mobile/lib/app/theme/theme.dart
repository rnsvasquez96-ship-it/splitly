
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
AppTheme._();

static const Color primary = Color(0xFF5B5FEF);
static const Color background = Color(0xFFF7F7FB);
static const Color surface = Colors.white;
static const Color textPrimary = Color(0xFF17181C);
static const Color textSecondary = Color(0xFF6B6D76);
static const Color success = Color(0xFF22A06B);
static const Color danger = Color(0xFFE5484D);

static ThemeData lightTheme = ThemeData(
useMaterial3: true,
scaffoldBackgroundColor: background,
colorScheme: ColorScheme.fromSeed(
seedColor: primary,
brightness: Brightness.light,
),
textTheme: GoogleFonts.interTextTheme().apply(
bodyColor: textPrimary,
displayColor: textPrimary,
),
appBarTheme: const AppBarTheme(
backgroundColor: background,
foregroundColor: textPrimary,
elevation: 0,
),
inputDecorationTheme: const InputDecorationTheme(
filled: true,
fillColor: surface,
border: OutlineInputBorder(
borderRadius: BorderRadius.all(
Radius.circular(16),
),
borderSide: BorderSide.none,
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.all(
Radius.circular(16),
),
borderSide: BorderSide.none,
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.all(
Radius.circular(16),
),
borderSide: BorderSide(
color: primary,
width: 1.5,
),
),
),
cardTheme: CardThemeData(
color: surface,
elevation: 0,
margin: EdgeInsets.zero,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.all(
Radius.circular(20),
),
),
),
);

static ThemeData darkTheme = ThemeData(
useMaterial3: true,
scaffoldBackgroundColor: const Color(0xFF121318),
colorScheme: ColorScheme.fromSeed(
seedColor: primary,
brightness: Brightness.dark,
),
textTheme: GoogleFonts.interTextTheme(
ThemeData.dark().textTheme,
),
);
}


import 'package:flutter/material.dart';

import 'app/theme/app_theme.dart';
import 'features/auth/presentation/splash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const SplitlyApp());
}

class SplitlyApp extends StatelessWidget {
  const SplitlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Splitly',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashPage(),
    );
  }
}
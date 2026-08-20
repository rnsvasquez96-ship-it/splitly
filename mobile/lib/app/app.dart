import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'main_shell.dart';

class SplitlyApp extends StatelessWidget {
  const SplitlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splitly',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      home: const MainShell(),
    );
  }
}

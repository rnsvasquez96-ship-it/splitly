
import 'package:flutter/material.dart';

import 'theme/theme.dart';
import '../screens/home/home_screen.dart';

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
home: const HomeScreen(),
);
}
}


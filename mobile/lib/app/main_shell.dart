import 'package:flutter/material.dart';

import '../features/analytics/presentation/analytics_screen.dart';
import '../features/budget/presentation/budget_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/groups/presentation/groups_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import 'widgets/app_bottom_navbar.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    const DashboardScreen(),
    const GroupsScreen(),
    const BudgetScreen(),
    const AnalyticsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == _currentIndex) {
            return;
          }

          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

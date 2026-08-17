import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning ☀";
    }

    if (hour < 18) {
      return "Good Afternoon 🌤";
    }

    return "Good Evening 🌙";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _greeting(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Splitly",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Smart Expense Manager",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
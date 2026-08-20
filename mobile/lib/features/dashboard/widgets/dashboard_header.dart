import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  final double totalExpenses;

  const DashboardHeader({super.key, required this.totalExpenses});

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good morning";
    }

    if (hour < 18) {
      return "Good afternoon";
    }

    return "Good evening";
  }

  String _displayName() {
    final user = FirebaseAuth.instance.currentUser;

    final displayName = user?.displayName?.trim();

    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }

    final email = user?.email;

    if (email == null || email.isEmpty) {
      return "Guest";
    }

    final username = email.split("@").first;

    if (username.isEmpty) {
      return "Guest";
    }

    return username
        .split(RegExp(r'[._-]'))
        .where((part) => part.isNotEmpty)
        .map((part) => "${part[0].toUpperCase()}${part.substring(1)}")
        .join(" ");
  }

  String _initial() {
    final name = _displayName();

    if (name.isEmpty) {
      return "?";
    }

    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final name = _displayName();
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    _greeting(),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text("👋", style: TextStyle(fontSize: 16)),
                ],
              ),

              const SizedBox(height: 5),

              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.7,
                ),
              ),

              const SizedBox(height: 5),

              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(width: 7),

                  Text(
                    totalExpenses > 0
                        ? "Your expenses are up to date"
                        : "Ready to split some expenses?",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: .10),
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: .15),
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            _initial(),
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

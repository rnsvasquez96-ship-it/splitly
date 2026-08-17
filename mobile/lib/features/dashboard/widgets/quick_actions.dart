import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback onCreateGroup;
  final VoidCallback onAddExpense;
  final VoidCallback onAddMember;

  const QuickActions({
    super.key,
    required this.onCreateGroup,
    required this.onAddExpense,
    required this.onAddMember,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.groups_rounded,
                title: "New Group",
                color: const Color(0xFF5B5FEF),
                onTap: onCreateGroup,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ActionCard(
                icon: Icons.receipt_long_rounded,
                title: "Expense",
                color: Colors.green,
                onTap: onAddExpense,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          child: _ActionCard(
            icon: Icons.person_add_alt_1_rounded,
            title: "Add Member",
            color: Colors.orange,
            onTap: onAddMember,
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../../expenses/models/expense.dart';

class RecentExpenses extends StatelessWidget {
  final List<Expense> expenses;

  const RecentExpenses({
    super.key,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const SizedBox();
    }

    final recent = expenses.reversed.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Expenses",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        ...recent.map(
              (expense) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _ExpenseCard(
              expense: expense,
            ),
          ),
        ),
      ],
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  final Expense expense;

  const _ExpenseCard({
    required this.expense,
  });

  IconData _icon() {
    final title = expense.title.toLowerCase();

    if (title.contains("food") ||
        title.contains("dinner") ||
        title.contains("lunch")) {
      return Icons.restaurant;
    }

    if (title.contains("gas")) {
      return Icons.local_gas_station;
    }

    if (title.contains("hotel")) {
      return Icons.hotel;
    }

    if (title.contains("coffee")) {
      return Icons.local_cafe;
    }

    if (title.contains("movie")) {
      return Icons.movie;
    }

    return Icons.receipt_long;
  }

  Color _color() {
    final title = expense.title.toLowerCase();

    if (title.contains("food")) return Colors.orange;
    if (title.contains("gas")) return Colors.blue;
    if (title.contains("hotel")) return Colors.purple;
    if (title.contains("coffee")) return Colors.brown;
    if (title.contains("movie")) return Colors.red;

    return const Color(0xFF5B5FEF);
  }

  String _timeAgo() {
    final diff = DateTime.now().difference(expense.createdAt);

    if (diff.inMinutes < 1) {
      return "Just now";
    }

    if (diff.inHours < 1) {
      return "${diff.inMinutes} min ago";
    }

    if (diff.inDays < 1) {
      return "${diff.inHours} hr ago";
    }

    if (diff.inDays == 1) {
      return "Yesterday";
    }

    return "${diff.inDays} days ago";
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _icon(),
              color: color,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "Paid by ${expense.paidBy}",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  _timeAgo(),
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Text(
            "₱${expense.amount.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
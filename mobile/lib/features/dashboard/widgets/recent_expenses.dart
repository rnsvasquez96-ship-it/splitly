import 'package:flutter/material.dart';

import '../../expenses/models/expense.dart';

class RecentExpenses extends StatelessWidget {
  final List<Expense> expenses;

  const RecentExpenses({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const SizedBox.shrink();
    }

    final recent = expenses.reversed.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recent Expenses",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.3,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "Your latest transactions",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary
                    .withValues(alpha: .08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.history_rounded,
                size: 19,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.grey.withValues(alpha: .10)),
          ),
          child: Column(
            children: List.generate(recent.length, (index) {
              final expense = recent[index];

              return Column(
                children: [
                  _ExpenseItem(expense: expense),
                  if (index != recent.length - 1)
                    Padding(
                      padding: const EdgeInsets.only(left: 78, right: 18),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.withValues(alpha: .10),
                      ),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _ExpenseItem extends StatelessWidget {
  final Expense expense;

  const _ExpenseItem({required this.expense});

  IconData _icon() {
    final label = expense.category.label.toLowerCase();

    if (label.contains("food")) {
      return Icons.restaurant_rounded;
    }

    if (label.contains("transport")) {
      return Icons.directions_car_rounded;
    }

    if (label.contains("shopping")) {
      return Icons.shopping_bag_rounded;
    }

    if (label.contains("entertainment")) {
      return Icons.movie_rounded;
    }

    if (label.contains("travel")) {
      return Icons.flight_rounded;
    }

    if (label.contains("utilities")) {
      return Icons.lightbulb_rounded;
    }

    return Icons.receipt_long_rounded;
  }

  Color _color() {
    final label = expense.category.label.toLowerCase();

    if (label.contains("food")) {
      return Colors.orange;
    }

    if (label.contains("transport")) {
      return Colors.blue;
    }

    if (label.contains("shopping")) {
      return Colors.purple;
    }

    if (label.contains("entertainment")) {
      return Colors.red;
    }

    if (label.contains("travel")) {
      return Colors.teal;
    }

    if (label.contains("utilities")) {
      return Colors.amber.shade700;
    }

    return const Color(0xFF5B5FEF);
  }

  String _timeAgo() {
    final now = DateTime.now();
    final difference = now.difference(expense.createdAt);

    if (difference.isNegative) {
      return "Just now";
    }

    if (difference.inMinutes < 1) {
      return "Just now";
    }

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    }

    if (difference.inHours < 24) {
      return "${difference.inHours} hr ago";
    }

    if (difference.inDays == 1) {
      return "Yesterday";
    }

    if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    }

    return _formatDate(expense.createdAt);
  }

  String _formatDate(DateTime date) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(_icon(), color: color, size: 22),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Flexible(
                      child: Text(
                        "Paid by ${expense.paidBy}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        "•",
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                    ),

                    Text(
                      _timeAgo(),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  "${expense.category.emoji} "
                  "${expense.category.label}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₱${expense.amount.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 5),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Text(
                  "PAID",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

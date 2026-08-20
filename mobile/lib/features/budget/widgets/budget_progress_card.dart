import 'package:flutter/material.dart';

class BudgetProgressCard extends StatelessWidget {
  final String title;
  final double spent;
  final double limit;

  const BudgetProgressCard({
    super.key,
    required this.title,
    required this.spent,
    required this.limit,
  });

  @override
  Widget build(BuildContext context) {
    final progress = limit == 0 ? 0.0 : spent / limit;

    final percentage = (progress * 100).clamp(0, 100);

    Color color;

    if (progress < 0.7) {
      color = Colors.green;
    } else if (progress < 0.9) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title + Percentage
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${percentage.toStringAsFixed(0)}%",
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 16),

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                color: color,
                backgroundColor: Colors.grey.shade300,
                minHeight: 10,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Spent",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      "₱${spent.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Budget",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      "₱${limit.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

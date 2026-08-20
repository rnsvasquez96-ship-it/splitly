import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../expenses/models/expense_category.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<ExpenseCategory, double> data;

  const CategoryPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Card(
        child: SizedBox(
          height: 250,
          child: Center(child: Text("No category data")),
        ),
      );
    }

    final entries = data.entries.toList();

    final total = data.values.fold(0.0, (sum, value) => sum + value);

    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.amber,
      Colors.pink,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.pie_chart),
                SizedBox(width: 8),
                Text(
                  "Expense Categories",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 220,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: 45,
                    sectionsSpace: 3,
                    sections: List.generate(entries.length, (index) {
                      final item = entries[index];

                      return PieChartSectionData(
                        value: item.value,
                        color: colors[index % colors.length],

                        title:
                            "${(item.value / total * 100).toStringAsFixed(0)}%",
                        radius: 78,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            ...List.generate(entries.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: colors[index % colors.length],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "${entries[index].key.emoji} ${entries[index].key.label}",
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "₱${entries[index].value.toStringAsFixed(2)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${(entries[index].value / total * 100).toStringAsFixed(1)}%",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

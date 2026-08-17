import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyChart extends StatelessWidget {
  final Map<String, double> data;

  const MonthlyChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Card(
        child: SizedBox(
          height: 220,
          child: Center(
            child: Text("No monthly data"),
          ),
        ),
      );
    }

    final entries = data.entries.toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Text(
              "Monthly Spending",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  alignment:
                  BarChartAlignment.spaceAround,

                  borderData:
                  FlBorderData(show: false),

                  gridData:
                  const FlGridData(show: false),

                  titlesData: FlTitlesData(
                    topTitles:
                    const AxisTitles(
                      sideTitles:
                      SideTitles(
                        showTitles: false,
                      ),
                    ),
                    rightTitles:
                    const AxisTitles(
                      sideTitles:
                      SideTitles(
                        showTitles: false,
                      ),
                    ),
                    leftTitles:
                    const AxisTitles(
                      sideTitles:
                      SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles:
                    AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget:
                            (value, meta) {
                          final index =
                          value.toInt();

                          if (index >=
                              entries.length) {
                            return const SizedBox();
                          }

                          return Padding(
                            padding:
                            const EdgeInsets.only(
                              top: 8,
                            ),
                            child: Text(
                              entries[index].key,
                              style:
                              const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  barGroups:
                  List.generate(
                    entries.length,
                        (index) {
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: entries[index].value,
                            width: 22,
                            borderRadius:
                            BorderRadius.circular(6),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
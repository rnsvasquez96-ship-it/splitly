import 'package:flutter/material.dart';

import '../../expenses/models/expense.dart';
import '../../groups/models/group.dart';
import '../../groups/repository/group_repository.dart';
import '../services/analytics_service.dart';
import '../widgets/monthly_chart.dart';
import '../widgets/category_pie_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final GroupRepository _repository = GroupRepository.instance;

  List<Group> get groups => _repository.getGroups();

  List<Expense> get expenses =>
      groups.expand((group) => group.expenses).toList();

  @override
  Widget build(BuildContext context) {
    final largestExpense =
    AnalyticsService.largestExpense(expenses);

    final topSpender =
    AnalyticsService.topSpender(expenses);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Analytics",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SummaryTile(
            title: "Total Spent",
            value:
            "₱${AnalyticsService.totalSpent(expenses).toStringAsFixed(2)}",
            icon: Icons.payments,
            color: Colors.green,
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _SummaryTile(
                  title: "Groups",
                  value: AnalyticsService
                      .totalGroups(groups)
                      .toString(),
                  icon: Icons.groups,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryTile(
                  title: "Members",
                  value: AnalyticsService
                      .totalMembers(groups)
                      .toString(),
                  icon: Icons.people,
                  color: Colors.teal,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _SummaryTile(
                  title: "Transactions",
                  value: AnalyticsService
                      .totalTransactions(expenses)
                      .toString(),
                  icon: Icons.receipt_long,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryTile(
                  title: "Average",
                  value:
                  "₱${AnalyticsService.averageExpense(expenses).toStringAsFixed(2)}",
                  icon: Icons.bar_chart,
                  color: Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: largestExpense == null
                  ? const Text("No expenses yet.")
                  : Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Largest Expense",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    largestExpense.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Paid by ${largestExpense.paidBy}",
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "₱${largestExpense.amount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.emoji_events),
              ),
              title: const Text(
                "Top Spender",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                topSpender ?? "No data",
              ),
            ),
          ),

          const SizedBox(height: 32),

          const Text(
            "Charts",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          MonthlyChart(
            data: AnalyticsService.monthlyTotals(
              expenses,
            ),
          ),

          const SizedBox(height: 16),

          CategoryPieChart(
            data: AnalyticsService.categoryTotals(
              expenses,
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
              color.withValues(alpha: .15),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../../expenses/models/expense.dart';
import '../../groups/models/group.dart';
import '../../groups/repository/group_repository.dart';
import '../services/analytics_service.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final _repository = GroupRepository.instance;

  List<Group> get groups => _repository.getGroups();

  List<Expense> get expenses =>
      groups.expand((g) => g.expenses).toList();

  @override
  Widget build(BuildContext context) {
    final largest =
    AnalyticsService.largestExpense(expenses);

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

          _SummaryTile(
            title: "Average Expense",
            value:
            "₱${AnalyticsService.averageExpense(expenses).toStringAsFixed(2)}",
            icon: Icons.analytics,
            color: Colors.orange,
          ),

          const SizedBox(height: 16),

          _SummaryTile(
            title: "Transactions",
            value: AnalyticsService.totalTransactions(expenses)
                .toString(),
            icon: Icons.receipt_long,
            color: Colors.blue,
          ),

          const SizedBox(height: 16),

          _SummaryTile(
            title: "Groups",
            value:
            AnalyticsService.totalGroups(groups).toString(),
            icon: Icons.groups,
            color: Colors.purple,
          ),

          const SizedBox(height: 16),

          _SummaryTile(
            title: "Members",
            value:
            AnalyticsService.totalMembers(groups).toString(),
            icon: Icons.people,
            color: Colors.teal,
          ),

          const SizedBox(height: 24),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: largest == null
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
                  const SizedBox(height: 12),
                  Text(
                    largest.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Paid by ${largest.paidBy}",
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "₱${largest.amount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.emoji_events),
              ),
              title: const Text("Top Spender"),
              subtitle: Text(
                AnalyticsService.topSpender(expenses) ??
                    "No data",
              ),
            ),
          ),
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
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: .15),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../../expenses/models/expense.dart';
import '../../groups/models/group.dart';
import '../../groups/repository/group_repository.dart';
import '../services/analytics_service.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/monthly_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final GroupRepository _repository = GroupRepository.instance;

  bool _loading = true;

  List<Group> get groups => _repository.getGroups();

  List<Expense> get expenses =>
      groups.expand((group) => group.expenses).toList();

  double get totalSpent => AnalyticsService.totalSpent(expenses);

  double get averageExpense => AnalyticsService.averageExpense(expenses);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await _repository.loadGroups();
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _refreshData() async {
    await _repository.loadGroups();

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final largestExpense = AnalyticsService.largestExpense(expenses);

    final topSpender = AnalyticsService.topSpender(expenses);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7FB),
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Analytics",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : expenses.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
                children: [
                  _buildOverviewCard(),

                  const SizedBox(height: 22),

                  _buildStatistics(),

                  const SizedBox(height: 30),

                  _buildSectionHeader(
                    icon: Icons.insights_rounded,
                    title: "Highlights",
                    subtitle: "Key insights from your spending",
                  ),

                  const SizedBox(height: 14),

                  _buildLargestExpenseCard(largestExpense),

                  const SizedBox(height: 12),

                  _buildTopSpenderCard(topSpender),

                  const SizedBox(height: 30),

                  _buildSectionHeader(
                    icon: Icons.show_chart_rounded,
                    title: "Spending Trends",
                    subtitle: "Track your expenses over time",
                  ),

                  const SizedBox(height: 14),

                  MonthlyChart(data: AnalyticsService.monthlyTotals(expenses)),

                  const SizedBox(height: 24),

                  _buildSectionHeader(
                    icon: Icons.donut_large_rounded,
                    title: "Category Breakdown",
                    subtitle: "See where your money goes",
                  ),

                  const SizedBox(height: 14),

                  CategoryPieChart(
                    data: AnalyticsService.categoryTotals(expenses),
                  ),

                  const SizedBox(height: 30),

                  _buildInsightCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildOverviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: .18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.analytics_rounded,
                  color: Colors.white,
                  size: 27,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${expenses.length} "
                  "${expenses.length == 1 ? "transaction" : "transactions"}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            "Total Spent",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),

          const SizedBox(height: 4),

          Text(
            "₱${totalSpent.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 31,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _HeaderStat(
                  label: "Average",
                  value: "₱${averageExpense.toStringAsFixed(2)}",
                ),
              ),
              Container(
                width: 1,
                height: 38,
                color: Colors.white.withValues(alpha: .20),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18),
                  child: _HeaderStat(
                    label: "Groups",
                    value: AnalyticsService.totalGroups(groups).toString(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return Row(
      children: [
        Expanded(
          child: _SummaryTile(
            title: "Groups",
            value: AnalyticsService.totalGroups(groups).toString(),
            icon: Icons.groups_rounded,
            color: const Color(0xFF5B5FEF),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _SummaryTile(
            title: "Members",
            value: AnalyticsService.totalMembers(groups).toString(),
            icon: Icons.people_rounded,
            color: Colors.orange,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _SummaryTile(
            title: "Expenses",
            value: AnalyticsService.totalTransactions(expenses).toString(),
            icon: Icons.receipt_long_rounded,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildLargestExpenseCard(Expense? expense) {
    if (expense == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: .10)),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              expense.category.emoji,
              style: const TextStyle(fontSize: 25),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Largest Expense",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  expense.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  "${expense.category.label} • "
                  "Paid by ${expense.paidBy}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Text(
            "₱${expense.amount.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.green,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSpenderCard(String? topSpender) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: .10)),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: Colors.orange,
              size: 27,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Top Spender",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),

                const SizedBox(height: 4),

                Text(
                  topSpender ?? "No data",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  "Highest total contribution",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: .10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCard() {
    final categoryTotals = AnalyticsService.categoryTotals(expenses);

    if (categoryTotals.isEmpty) {
      return const SizedBox.shrink();
    }

    final entries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topCategory = entries.first;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: .10),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary
                  .withValues(alpha: .10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.lightbulb_outline_rounded),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Spending Insight",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 5),

                Text(
                  "${topCategory.key.emoji} "
                  "${topCategory.key.label} is your "
                  "highest spending category at "
                  "₱${topCategory.value.toStringAsFixed(2)}.",
                  style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(30, 90, 30, 110),
        children: [
          Container(
            width: 110,
            height: 110,
            margin: const EdgeInsets.symmetric(horizontal: 80),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary
                  .withValues(alpha: .10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.analytics_outlined,
              size: 55,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          const SizedBox(height: 26),

          const Text(
            "No Analytics Yet",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Text(
            "Add expenses to your groups and "
            "Splitly will automatically generate "
            "spending insights and charts.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String label;
  final String value;

  const _HeaderStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
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
    return Container(
      height: 105,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.withValues(alpha: .10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                maxLines: 1,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

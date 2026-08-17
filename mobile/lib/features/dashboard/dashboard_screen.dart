import 'package:flutter/material.dart';

import '../../app/widgets/fade_slide.dart';
import '../expenses/models/expense.dart';
import '../groups/models/group.dart';
import '../groups/repository/group_repository.dart';
import 'widgets/balance_card.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/quick_actions.dart';
import 'widgets/recent_expenses.dart';
import 'widgets/recent_groups.dart';
import 'widgets/stat_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {
  final _repository = GroupRepository.instance;

  List<Group> get groups => _repository.getGroups();

  List<Expense> get expenses =>
      groups.expand((group) => group.expenses).toList();

  double get totalExpenses => expenses.fold(
    0,
        (sum, expense) => sum + expense.amount,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _repository.loadGroups();

            if (!mounted) return;

            setState(() {});
          },
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              /// Header
              const FadeSlide(
                child: DashboardHeader(),
              ),

              const SizedBox(height: 28),

              /// Balance Card
              FadeSlide(
                delay: const Duration(milliseconds: 100),
                child: BalanceCard(
                  totalBalance: totalExpenses,
                  totalExpenses: expenses.length,
                ),
              ),

              const SizedBox(height: 24),

              /// Statistics
              FadeSlide(
                delay: const Duration(milliseconds: 200),
                child: GridView.count(
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.95,
                  children: [
                    StatCard(
                      icon: Icons.groups,
                      color: const Color(0xFF5B5FEF),
                      title: "Groups",
                      value: groups.length.toString(),
                    ),
                    StatCard(
                      icon: Icons.receipt_long,
                      color: Colors.green,
                      title: "Expenses",
                      value:
                      "₱${totalExpenses.toStringAsFixed(0)}",
                    ),
                    StatCard(
                      icon: Icons.people,
                      color: Colors.orange,
                      title: "Members",
                      value: groups
                          .fold<int>(
                        0,
                            (sum, group) =>
                        sum + group.members.length,
                      )
                          .toString(),
                    ),
                    StatCard(
                      icon: Icons.bar_chart,
                      color: Colors.red,
                      title: "Transactions",
                      value: expenses.length.toString(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// Quick Actions
              FadeSlide(
                delay: const Duration(milliseconds: 300),
                child: QuickActions(
                  onCreateGroup: () {},
                  onAddExpense: () {},
                  onAddMember: () {},
                ),
              ),

              const SizedBox(height: 30),

              /// Recent Groups
              FadeSlide(
                delay: const Duration(milliseconds: 400),
                child: RecentGroups(
                  groups: groups,
                  onTap: (group) {},
                ),
              ),

              const SizedBox(height: 30),

              /// Recent Expenses
              FadeSlide(
                delay: const Duration(milliseconds: 500),
                child: RecentExpenses(
                  expenses: expenses,
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
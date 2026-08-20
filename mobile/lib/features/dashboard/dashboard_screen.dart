import 'package:flutter/material.dart';

import '../../app/widgets/fade_slide.dart';
import '../expenses/models/expense.dart';
import '../groups/models/group.dart';
import '../groups/presentation/group_details_screen.dart';
import '../groups/repository/group_repository.dart';
import '../groups/screens/group_form_screen.dart';
import 'widgets/balance_card.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/quick_actions.dart';
import 'widgets/recent_expenses.dart';
import 'widgets/recent_groups.dart';
import 'widgets/stat_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GroupRepository _repository = GroupRepository.instance;

  List<Group> get groups => _repository.getGroups();

  List<Expense> get expenses =>
      groups.expand((group) => group.expenses).toList();

  double get totalExpenses {
    return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  int get totalMembers {
    return groups.fold(0, (sum, group) => sum + group.members.length);
  }

  double get averageExpense {
    if (expenses.isEmpty) {
      return 0;
    }

    return totalExpenses / expenses.length;
  }

  Future<void> _refreshDashboard() async {
    final messenger = ScaffoldMessenger.of(context);

    await _repository.loadGroups();

    if (!mounted) {
      return;
    }

    setState(() {});

    messenger.showSnackBar(
      const SnackBar(
        content: Text("Dashboard updated"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _createGroup() async {
    final Group? group = await Navigator.of(context).push<Group>(
      MaterialPageRoute(builder: (context) => const GroupFormScreen()),
    );

    if (group == null) {
      return;
    }

    await _repository.addGroup(group);

    if (!mounted) {
      return;
    }

    setState(() {});

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("${group.name} created")));
  }

  Future<void> _openGroup(Group group) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => GroupDetailsScreen(group: group)),
    );

    await _repository.loadGroups();

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> _chooseGroup({
    required String title,
    required String description,
  }) async {
    if (groups.isEmpty) {
      await _showNoGroupsDialog();
      return;
    }

    final Group? selectedGroup = await showModalBottomSheet<Group>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: groups.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 8);
                    },
                    itemBuilder: (context, index) {
                      final group = groups[index];

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        tileColor: const Color(0xFFF6F7FB),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primaryContainer,
                          child: const Icon(Icons.groups_rounded),
                        ),
                        title: Text(
                          group.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          "${group.members.length} "
                          "${group.members.length == 1 ? "member" : "members"}",
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () {
                          Navigator.of(sheetContext).pop(group);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedGroup == null || !mounted) {
      return;
    }

    await _openGroup(selectedGroup);
  }

  Future<void> _showNoGroupsDialog() async {
    final bool? createGroup = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Create a group first"),
          content: const Text(
            "Expenses and members belong to a group. "
            "Create your first group to continue.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text("Cancel"),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text("Create Group"),
            ),
          ],
        );
      },
    );

    if (createGroup == true && mounted) {
      await _createGroup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshDashboard,
          child: groups.isEmpty
              ? _buildEmptyState()
              : ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
                  children: [
                    FadeSlide(
                      child: DashboardHeader(totalExpenses: totalExpenses),
                    ),
                    const SizedBox(height: 28),

                    FadeSlide(
                      delay: const Duration(milliseconds: 100),
                      child: BalanceCard(
                        totalBalance: totalExpenses,
                        totalExpenses: expenses.length,
                      ),
                    ),
                    const SizedBox(height: 24),

                    FadeSlide(
                      delay: const Duration(milliseconds: 200),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.95,
                        children: [
                          StatCard(
                            icon: Icons.groups_rounded,
                            color: const Color(0xFF5B5FEF),
                            title: "Groups",
                            value: groups.length.toString(),
                          ),
                          StatCard(
                            icon: Icons.receipt_long_rounded,
                            color: Colors.green,
                            title: "Expenses",
                            value: "₱${totalExpenses.toStringAsFixed(0)}",
                          ),
                          StatCard(
                            icon: Icons.people_rounded,
                            color: Colors.orange,
                            title: "Members",
                            value: totalMembers.toString(),
                          ),
                          StatCard(
                            icon: Icons.analytics_rounded,
                            color: Colors.indigo,
                            title: "Average",
                            value: "₱${averageExpense.toStringAsFixed(0)}",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    FadeSlide(
                      delay: const Duration(milliseconds: 300),
                      child: QuickActions(
                        onCreateGroup: _createGroup,
                        onAddExpense: () async {
                          await _chooseGroup(
                            title: "Add Expense",
                            description: "Choose the group where you want to add an expense.",
                          );
                        },
                        onAddMember: () async {
                          await _chooseGroup(
                            title: "Add Member",
                            description: "Choose the group where you want to add a member.",
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),

                    FadeSlide(
                      delay: const Duration(milliseconds: 400),
                      child: RecentGroups(groups: groups, onTap: _openGroup),
                    ),
                    const SizedBox(height: 30),

                    FadeSlide(
                      delay: const Duration(milliseconds: 500),
                      child: RecentExpenses(expenses: expenses),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      "Splitly v1.0.0",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 70, 24, 110),
      children: [
        Container(
          width: 110,
          height: 110,
          margin: const EdgeInsets.symmetric(horizontal: 90),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: .10),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.groups_2_outlined,
            size: 58,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          "Welcome to Splitly 👋",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          "Create your first group to start splitting expenses "
          "with friends, family, or coworkers.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 36),
        SizedBox(
          height: 54,
          child: FilledButton.icon(
            onPressed: _createGroup,
            icon: const Icon(Icons.add_rounded),
            label: const Text("Create Your First Group"),
          ),
        ),
      ],
    );
  }
}

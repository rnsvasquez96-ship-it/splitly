import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../expenses/models/expense.dart';
import '../../expenses/models/expense_category.dart';
import '../../groups/models/group.dart';
import '../../groups/repository/group_repository.dart';
import '../models/budget.dart';
import '../repository/budget_repository.dart';
import '../services/budget_service.dart';
import '../widgets/budget_progress_card.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final BudgetRepository _budgetRepository = BudgetRepository.instance;

  final GroupRepository _groupRepository = GroupRepository.instance;

  bool _loading = true;

  List<Budget> get budgets => _budgetRepository.getBudgets();

  List<Group> get groups => _groupRepository.getGroups();

  List<Expense> get expenses =>
      groups.expand((group) => group.expenses).toList();

  double get totalBudget {
    return budgets.fold(0.0, (sum, budget) => sum + budget.limit);
  }

  double get totalSpent {
    return budgets.fold(
      0.0,
      (sum, budget) => sum + BudgetService.spentForCategory(budget, expenses),
    );
  }

  double get remainingBudget {
    return totalBudget - totalSpent;
  }

  double get overallProgress {
    if (totalBudget <= 0) {
      return 0;
    }

    return (totalSpent / totalBudget).clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await Future.wait([
        _budgetRepository.loadBudgets(),
        _groupRepository.loadGroups(),
      ]);
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<bool> _confirmDeleteBudget(Budget budget) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Delete Budget?"),
          content: Text(
            "Delete your ${budget.category.label} "
            "budget of "
            "₱${budget.limit.toStringAsFixed(2)}?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text("Cancel"),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> _deleteBudget(Budget budget) async {
    await _budgetRepository.deleteBudget(budget.id);

    if (!mounted) {
      return;
    }

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${budget.category.label} budget deleted")),
    );
  }

  Future<void> _showAddBudgetDialog() async {
    ExpenseCategory selectedCategory = ExpenseCategory.food;

    final limitController = TextEditingController();

    final Budget? newBudget = await showDialog<Budget>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.account_balance_wallet_outlined),
                  SizedBox(width: 10),
                  Text("Create Budget"),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<ExpenseCategory>(
                    initialValue: selectedCategory,
                    decoration: InputDecoration(
                      labelText: "Category",
                      prefixIcon: const Icon(Icons.category_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    items: ExpenseCategory.values.map((category) {
                      return DropdownMenuItem<ExpenseCategory>(
                        value: category,
                        child: Text(
                          "${category.emoji} "
                          "${category.label}",
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setDialogState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: limitController,
                    autofocus: false,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: "Budget Amount",
                      prefixText: "₱ ",
                      hintText: "5000",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text("Cancel"),
                ),
                FilledButton(
                  onPressed: () {
                    final limit = double.tryParse(limitController.text.trim());

                    if (limit == null || limit <= 0) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(
                          content: Text("Enter a valid budget amount."),
                        ),
                      );

                      return;
                    }

                    final budget = Budget(
                      id: const Uuid().v4(),
                      category: selectedCategory,
                      limit: limit,
                    );

                    Navigator.of(dialogContext).pop(budget);
                  },
                  child: const Text("Create"),
                ),
              ],
            );
          },
        );
      },
    );

    limitController.dispose();

    if (newBudget == null) {
      return;
    }

    await _budgetRepository.addBudget(newBudget);

    if (!mounted) {
      return;
    }

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${newBudget.category.label} "
          "budget created",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7FB),
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Budgets",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddBudgetDialog,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          "Budget",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : budgets.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
                children: [
                  _buildOverviewCard(),

                  const SizedBox(height: 28),

                  _buildSectionHeader(),

                  const SizedBox(height: 14),

                  ...budgets.map((budget) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _buildBudgetItem(budget),
                    );
                  }),
                ],
              ),
            ),
    );
  }

  Widget _buildOverviewCard() {
    final isOverBudget = totalSpent > totalBudget;

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
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
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
                  "${budgets.length} "
                  "${budgets.length == 1 ? "budget" : "budgets"}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          const Text(
            "Total Budget",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),

          const SizedBox(height: 4),

          Text(
            "₱${totalBudget.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 22),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: overallProgress,
              minHeight: 9,
              backgroundColor: Colors.white.withValues(alpha: .20),
              color: isOverBudget ? Colors.red.shade200 : Colors.white,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _OverviewValue(
                  label: "Spent",
                  value: "₱${totalSpent.toStringAsFixed(2)}",
                ),
              ),
              Container(
                width: 1,
                height: 36,
                color: Colors.white.withValues(alpha: .20),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18),
                  child: _OverviewValue(
                    label: isOverBudget ? "Over budget" : "Remaining",
                    value: "₱${remainingBudget.abs().toStringAsFixed(2)}",
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Category Budgets",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 3),
              Text(
                "Track spending by category",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ),
        TextButton.icon(
          onPressed: _showAddBudgetDialog,
          icon: const Icon(Icons.add_rounded),
          label: const Text("Add"),
        ),
      ],
    );
  }

  Widget _buildBudgetItem(Budget budget) {
    final spent = BudgetService.spentForCategory(budget, expenses);

    return Dismissible(
      key: ValueKey(budget.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return _confirmDeleteBudget(budget);
      },
      onDismissed: (direction) {
        _deleteBudget(budget);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.white),
            SizedBox(height: 4),
            Text(
              "Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      child: BudgetProgressCard(
        title:
            "${budget.category.emoji} "
            "${budget.category.label}",
        spent: spent,
        limit: budget.limit,
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(30, 90, 30, 120),
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
              Icons.account_balance_wallet_outlined,
              size: 54,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          const SizedBox(height: 26),

          const Text(
            "No Budgets Yet",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Text(
            "Set category spending limits "
            "and keep your expenses under control.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 15,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: _showAddBudgetDialog,
              icon: const Icon(Icons.add_rounded),
              label: const Text("Create Your First Budget"),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewValue extends StatelessWidget {
  final String label;
  final String value;

  const _OverviewValue({required this.label, required this.value});

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
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

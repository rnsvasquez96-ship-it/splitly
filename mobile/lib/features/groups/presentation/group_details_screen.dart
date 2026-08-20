import 'package:flutter/material.dart';

import '../models/group.dart';
import '../models/member.dart';
import '../repository/group_repository.dart';

import '../../expenses/models/expense.dart';
import '../../expenses/presentation/screens/expense_form_screen.dart';

import '../screens/member_form_screen.dart';

import '../../reports/services/pdf_service.dart';

import '../../settlements/presentation/balance_section.dart';
import '../../settlements/presentation/settlement_section.dart';
import '../../settlements/services/settlement_service.dart';

import 'add_member_dialog.dart';

class GroupDetailsScreen extends StatefulWidget {
  final Group group;

  const GroupDetailsScreen({super.key, required this.group});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  late List<Member> _members;
  late List<Expense> _expenses;

  final GroupRepository _repository = GroupRepository.instance;

  @override
  void initState() {
    super.initState();

    _members = List<Member>.from(widget.group.members);

    _expenses = List<Expense>.from(widget.group.expenses);
  }

  String get _groupName => widget.group.name;

  String get _description => widget.group.description;

  double get _totalExpenses {
    return _expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double get _averageExpense {
    if (_expenses.isEmpty) {
      return 0;
    }

    return _totalExpenses / _expenses.length;
  }

  Future<void> _saveGroup() async {
    await _repository.updateGroup(widget.group);
  }

  Future<void> _exportPdf() async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      final settlements = SettlementService.calculate(_expenses);

      await PdfService.generateReport(
        group: widget.group,
        settlements: settlements,
      );

      if (!mounted) {
        return;
      }

      messenger.showSnackBar(
        const SnackBar(content: Text("PDF report generated")),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      messenger.showSnackBar(
        SnackBar(content: Text("Unable to generate PDF: $error")),
      );
    }
  }

  Future<void> _addMember() async {
    final Member? member = await showDialog<Member>(
      context: context,
      builder: (dialogContext) => const AddMemberDialog(),
    );

    if (member == null) {
      return;
    }

    setState(() {
      _members.add(member);
      widget.group.members.add(member);
    });

    await _saveGroup();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("${member.name} added")));
  }

  Future<void> _editMember(int index) async {
    final Member? updatedMember = await Navigator.of(context).push<Member>(
      MaterialPageRoute(
        builder: (context) => MemberFormScreen(member: _members[index]),
      ),
    );

    if (updatedMember == null) {
      return;
    }

    setState(() {
      _members[index] = updatedMember;
      widget.group.members[index] = updatedMember;
    });

    await _saveGroup();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Member updated")));
  }

  Future<void> _confirmDeleteMember(int index) async {
    final member = _members[index];

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Remove Member?"),
          content: Text(
            "Remove ${member.name} from "
            "this group?",
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
              child: const Text("Remove"),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      _members.removeAt(index);
      widget.group.members.remove(member);
    });

    await _saveGroup();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("${member.name} removed")));
  }

  Future<void> _addExpense() async {
    final Expense? expense = await Navigator.of(context).push<Expense>(
      MaterialPageRoute(
        builder: (context) => ExpenseFormScreen(group: widget.group),
      ),
    );

    if (expense == null) {
      return;
    }

    setState(() {
      _expenses.add(expense);
      widget.group.expenses.add(expense);
    });

    await _saveGroup();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("${expense.title} added")));
  }

  Future<void> _editExpense(int index) async {
    final Expense? updatedExpense = await Navigator.of(context).push<Expense>(
      MaterialPageRoute(
        builder: (context) =>
            ExpenseFormScreen(group: widget.group, expense: _expenses[index]),
      ),
    );

    if (updatedExpense == null) {
      return;
    }

    setState(() {
      _expenses[index] = updatedExpense;
      widget.group.expenses[index] = updatedExpense;
    });

    await _saveGroup();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Expense updated")));
  }

  Future<void> _deleteExpense(int index) async {
    final expense = _expenses[index];

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Delete Expense?"),
          content: Text("Delete \"${expense.title}\"?"),
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

    if (confirmed != true) {
      return;
    }

    setState(() {
      _expenses.removeAt(index);
      widget.group.expenses.remove(expense);
    });

    await _saveGroup();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("${expense.title} deleted")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7FB),
        surfaceTintColor: Colors.transparent,
        title: Text(
          _groupName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 130),
          children: [
            _buildGroupHeader(),

            const SizedBox(height: 20),

            _buildStats(),

            const SizedBox(height: 30),

            _buildMembersSection(),

            const SizedBox(height: 30),

            _buildExpensesSection(),

            if (_expenses.isNotEmpty) ...[
              const SizedBox(height: 30),

              _buildSectionHeader(
                icon: Icons.account_balance_wallet_outlined,
                title: "Balances",
                subtitle: "See how expenses are distributed.",
              ),

              const SizedBox(height: 12),

              BalanceSection(expenses: _expenses),

              const SizedBox(height: 30),

              _buildSectionHeader(
                icon: Icons.handshake_outlined,
                title: "Settlements",
                subtitle: "Simplified payments between members.",
              ),

              const SizedBox(height: 12),

              SettlementSection(expenses: _expenses),

              const SizedBox(height: 30),

              _buildPdfCard(),
            ],
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActions(),
    );
  }

  Widget _buildGroupHeader() {
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
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.groups_rounded,
                  color: Colors.white,
                  size: 30,
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
                  "${_members.length} "
                  "${_members.length == 1 ? "member" : "members"}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            _groupName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (_description.isNotEmpty) ...[
            const SizedBox(height: 7),
            Text(
              _description,
              style: const TextStyle(color: Colors.white70, height: 1.4),
            ),
          ],
          const SizedBox(height: 22),
          Row(
            children: [
              const Icon(
                Icons.payments_outlined,
                color: Colors.white70,
                size: 19,
              ),
              const SizedBox(width: 7),
              const Text(
                "Total spent",
                style: TextStyle(color: Colors.white70),
              ),
              const Spacer(),
              Text(
                "₱${_totalExpenses.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(
          child: _MiniStatCard(
            icon: Icons.people_outline_rounded,
            label: "Members",
            value: _members.length.toString(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MiniStatCard(
            icon: Icons.receipt_long_outlined,
            label: "Expenses",
            value: _expenses.length.toString(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MiniStatCard(
            icon: Icons.calculate_outlined,
            label: "Average",
            value: "₱${_averageExpense.toStringAsFixed(0)}",
          ),
        ),
      ],
    );
  }

  Widget _buildMembersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.people_outline_rounded,
          title: "Members",
          subtitle: "${_members.length} in this group",
          actionLabel: "Add",
          onAction: _addMember,
        ),
        const SizedBox(height: 14),
        if (_members.isEmpty)
          _EmptyCard(
            icon: Icons.people_outline_rounded,
            title: "No members yet",
            description: "Add members to begin splitting expenses.",
            buttonLabel: "Add Member",
            onPressed: _addMember,
          )
        else
          ..._members.asMap().entries.map((entry) {
            return _MemberCard(
              member: entry.value,
              onEdit: () {
                _editMember(entry.key);
              },
              onDelete: () {
                _confirmDeleteMember(entry.key);
              },
            );
          }),
      ],
    );
  }

  Widget _buildExpensesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.receipt_long_outlined,
          title: "Expenses",
          subtitle: "${_expenses.length} recorded",
          actionLabel: "Add",
          onAction: _addExpense,
        ),
        const SizedBox(height: 14),
        if (_expenses.isEmpty)
          _EmptyCard(
            icon: Icons.receipt_long_outlined,
            title: "No expenses yet",
            description: "Record your first shared expense.",
            buttonLabel: "Add Expense",
            onPressed: _addExpense,
          )
        else
          ..._expenses.asMap().entries.map((entry) {
            final index = entry.key;
            final expense = entry.value;

            return _ExpenseCard(
              expense: expense,
              onEdit: () {
                _editExpense(index);
              },
              onDelete: () {
                _deleteExpense(index);
              },
            );
          }),
      ],
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
        if (actionLabel != null && onAction != null)
          TextButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.add_rounded, size: 19),
            label: Text(actionLabel),
          ),
      ],
    );
  }

  Widget _buildPdfCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.withValues(alpha: .10)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.picture_as_pdf_outlined,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Expense Report",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "Export balances and settlements",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: _exportPdf,
              icon: const Icon(Icons.download_rounded),
              label: const Text("Export PDF Report"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.small(
          heroTag: "member",
          tooltip: "Add member",
          onPressed: _addMember,
          child: const Icon(Icons.person_add_alt_1_rounded),
        ),
        const SizedBox(height: 10),
        FloatingActionButton.extended(
          heroTag: "expense",
          onPressed: _addExpense,
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            "Expense",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MiniStatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.withValues(alpha: .10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              Text(
                label,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final Member member;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MemberCard({
    required this.member,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = member.name.isEmpty ? "?" : member.name[0].toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.withValues(alpha: .10)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary
              .withValues(alpha: .10),
          foregroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            avatar,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          member.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: const Text("Group member"),
        trailing: PopupMenuButton<String>(
          tooltip: "Member options",
          icon: const Icon(Icons.more_horiz_rounded),
          onSelected: (value) {
            if (value == "edit") {
              onEdit();
            }

            if (value == "delete") {
              onDelete();
            }
          },
          itemBuilder: (context) {
            return const [
              PopupMenuItem(
                value: "edit",
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 20),
                    SizedBox(width: 12),
                    Text("Edit"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "delete",
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red, size: 20),
                    SizedBox(width: 12),
                    Text("Remove", style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ];
          },
        ),
      ),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ExpenseCard({
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.withValues(alpha: .10)),
      ),
      child: ListTile(
        onTap: onEdit,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        leading: Container(
          width: 46,
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: .08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            expense.category.emoji,
            style: const TextStyle(fontSize: 21),
          ),
        ),
        title: Text(
          expense.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            "${expense.category.label} • "
            "Paid by ${expense.paidBy}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "₱${expense.amount.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w700,
              ),
            ),
            PopupMenuButton<String>(
              tooltip: "Expense options",
              icon: const Icon(Icons.more_vert_rounded, size: 20),
              onSelected: (value) {
                if (value == "edit") {
                  onEdit();
                }

                if (value == "delete") {
                  onDelete();
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(
                    value: "edit",
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 20),
                        SizedBox(width: 12),
                        Text("Edit"),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: "delete",
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 20, color: Colors.red),
                        SizedBox(width: 12),
                        Text("Delete", style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback onPressed;

  const _EmptyCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: .10)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 42, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.add_rounded),
            label: Text(buttonLabel),
          ),
        ],
      ),
    );
  }
}

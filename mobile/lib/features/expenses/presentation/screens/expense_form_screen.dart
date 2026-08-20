import 'package:flutter/material.dart';

import '../../../groups/models/group.dart';
import '../../models/expense.dart';
import '../../models/expense_category.dart';

class ExpenseFormScreen extends StatefulWidget {
  final Group group;
  final Expense? expense;

  const ExpenseFormScreen({super.key, required this.group, this.expense});

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  String? _paidBy;
  ExpenseCategory _category = ExpenseCategory.food;

  final List<String> _selectedMembers = [];

  @override
  void initState() {
    super.initState();

    if (widget.expense != null) {
      final expense = widget.expense!;

      _titleController.text = expense.title;
      _amountController.text = expense.amount.toString();
      _paidBy = expense.paidBy;
      _category = expense.category;

      _selectedMembers.addAll(expense.splitBetween);
      return;
    }

    if (widget.group.members.isNotEmpty) {
      _paidBy = widget.group.members.first.name;

      _selectedMembers.addAll(widget.group.members.map((e) => e.name));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveExpense() {
    final title = _titleController.text.trim();

    final amount = double.tryParse(_amountController.text);

    if (title.isEmpty ||
        amount == null ||
        amount <= 0 ||
        _paidBy == null ||
        _selectedMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields.")),
      );
      return;
    }

    final expense = Expense(
      id:
          widget.expense?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      paidBy: _paidBy!,
      splitBetween: _selectedMembers,
      createdAt: widget.expense?.createdAt ?? DateTime.now(),
      category: _category,
    );

    Navigator.pop(context, expense);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expense == null ? "Add Expense" : "Edit Expense"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: "Expense Name"),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: "Amount",
              prefixText: "₱ ",
            ),
          ),

          const SizedBox(height: 20),

          DropdownButtonFormField<ExpenseCategory>(
            initialValue: _category,
            decoration: const InputDecoration(labelText: "Category"),
            items: ExpenseCategory.values.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text("${category.emoji} ${category.label}"),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                _category = value;
              });
            },
          ),

          const SizedBox(height: 25),

          DropdownButtonFormField<String>(
            initialValue: _paidBy,
            decoration: const InputDecoration(labelText: "Paid By"),
            items: widget.group.members
                .map(
                  (member) => DropdownMenuItem(
                    value: member.name,
                    child: Text(member.name),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _paidBy = value;
              });
            },
          ),

          const SizedBox(height: 25),

          const Text(
            "Split Between",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          ...widget.group.members.map((member) {
            final selected = _selectedMembers.contains(member.name);

            return CheckboxListTile(
              title: Text(member.name),
              value: selected,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    if (!_selectedMembers.contains(member.name)) {
                      _selectedMembers.add(member.name);
                    }
                  } else {
                    if (_selectedMembers.length > 1) {
                      _selectedMembers.remove(member.name);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "At least one member must share the expense.",
                          ),
                        ),
                      );
                    }
                  }
                });
              },
            );
          }),

          const SizedBox(height: 30),

          SizedBox(
            height: 56,
            child: FilledButton(
              onPressed: _saveExpense,
              child: Text(
                widget.expense == null ? "Add Expense" : "Save Changes",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

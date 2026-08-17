import 'package:flutter/material.dart';

import '../../../groups/models/group.dart';
import '../../models/expense.dart';

class AddGroupExpenseScreen extends StatefulWidget {
  final Group group;

  const AddGroupExpenseScreen({
    super.key,
    required this.group,
  });

  @override
  State<AddGroupExpenseScreen> createState() =>
      _AddGroupExpenseScreenState();
}

class _AddGroupExpenseScreenState
    extends State<AddGroupExpenseScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  String? _paidBy;
  final List<String> _selectedMembers = [];

  @override
  void initState() {
    super.initState();

    if (widget.group.members.isNotEmpty) {
      _paidBy = widget.group.members.first.name;

      _selectedMembers.addAll(
        widget.group.members.map((e) => e.name),
      );
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

    final amount = double.tryParse(
      _amountController.text,
    );

    if (title.isEmpty ||
        amount == null ||
        amount <= 0 ||
        _paidBy == null ||
        _selectedMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please complete all fields.',
          ),
        ),
      );
      return;
    }

    final expense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      paidBy: _paidBy!,
      splitBetween: _selectedMembers,
      createdAt: DateTime.now(),
    );

    Navigator.pop(context, expense);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expense"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: "Expense Name",
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: _amountController,
            keyboardType:
            const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              labelText: "Amount",
              prefixText: "₱ ",
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Paid By",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          DropdownButton<String>(
            value: _paidBy,
            isExpanded: true,
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          ...widget.group.members.map(
                (member) {
              final selected =
              _selectedMembers.contains(member.name);

              return CheckboxListTile(
                title: Text(member.name),
                value: selected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedMembers.add(member.name);
                    } else {
                      _selectedMembers.remove(member.name);
                    }
                  });
                },
              );
            },
          ),

          const SizedBox(height: 30),

          FilledButton(
            onPressed: _saveExpense,
            child: const Text(
              "Save Expense",
            ),
          ),
        ],
      ),
    );
  }
}
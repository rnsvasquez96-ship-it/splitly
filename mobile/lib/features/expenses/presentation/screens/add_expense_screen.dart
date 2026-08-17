
import 'package:flutter/material.dart';

class AddExpenseScreen extends StatefulWidget {
const AddExpenseScreen({super.key});

@override
State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
final _formKey = GlobalKey<FormState>();

final _nameController = TextEditingController();
final _amountController = TextEditingController();
final _descriptionController = TextEditingController();

String _paidBy = 'Me';

@override
void dispose() {
_nameController.dispose();
_amountController.dispose();
_descriptionController.dispose();
super.dispose();
}

void _saveExpense() {
if (!_formKey.currentState!.validate()) {
return;
}

final amount = double.tryParse(
_amountController.text.trim().replaceAll(',', ''),
);

if (amount == null || amount <= 0) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Please enter a valid amount.'),
),
);
return;
}

final expense = <String, dynamic>{
'name': _nameController.text.trim(),
'amount': amount,
'description': _descriptionController.text.trim(),
'paidBy': _paidBy,
'createdAt': DateTime.now().toIso8601String(),
};

Navigator.pop(context, expense);
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text(
'Add Expense',
style: TextStyle(
fontWeight: FontWeight.w800,
),
),
),
body: SafeArea(
child: Form(
key: _formKey,
child: SingleChildScrollView(
padding: const EdgeInsets.all(20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
'Expense Details',
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.w800,
),
),

const SizedBox(height: 8),

const Text(
'Add the details of your expense.',
style: TextStyle(
color: Colors.grey,
fontSize: 15,
),
),

const SizedBox(height: 28),

const Text(
'Expense Name',
style: TextStyle(
fontWeight: FontWeight.w700,
),
),

const SizedBox(height: 8),

TextFormField(
controller: _nameController,
textInputAction: TextInputAction.next,
decoration: const InputDecoration(
hintText: 'e.g. Team Dinner',
prefixIcon: Icon(Icons.receipt_long_outlined),
),
validator: (value) {
if (value == null || value.trim().isEmpty) {
return 'Please enter an expense name.';
}

return null;
},
),

const SizedBox(height: 20),

const Text(
'Amount',
style: TextStyle(
fontWeight: FontWeight.w700,
),
),

const SizedBox(height: 8),

TextFormField(
controller: _amountController,
keyboardType: const TextInputType.numberWithOptions(
decimal: true,
),
textInputAction: TextInputAction.next,
decoration: const InputDecoration(
hintText: '0.00',
prefixText: '₱ ',
prefixIcon: Icon(Icons.payments_outlined),
),
validator: (value) {
if (value == null || value.trim().isEmpty) {
return 'Please enter an amount.';
}

final amount = double.tryParse(
value.trim().replaceAll(',', ''),
);

if (amount == null || amount <= 0) {
return 'Enter a valid amount.';
}

return null;
},
),

const SizedBox(height: 20),

const Text(
'Paid By',
style: TextStyle(
fontWeight: FontWeight.w700,
),
),

const SizedBox(height: 8),

DropdownButtonFormField<String>(
initialValue: _paidBy,
decoration: const InputDecoration(
prefixIcon: Icon(Icons.person_outline),
),
items: const [
DropdownMenuItem(
value: 'Me',
child: Text('Me'),
),
DropdownMenuItem(
value: 'John',
child: Text('John'),
),
DropdownMenuItem(
value: 'Maria',
child: Text('Maria'),
),
],
onChanged: (value) {
if (value == null) return;

setState(() {
_paidBy = value;
});
},
),

const SizedBox(height: 20),

const Text(
'Description',
style: TextStyle(
fontWeight: FontWeight.w700,
),
),

const SizedBox(height: 8),

TextFormField(
controller: _descriptionController,
maxLines: 3,
textInputAction: TextInputAction.done,
decoration: const InputDecoration(
hintText: 'Optional description',
prefixIcon: Icon(Icons.notes_outlined),
alignLabelWithHint: true,
),
),

const SizedBox(height: 32),

SizedBox(
width: double.infinity,
height: 56,
child: FilledButton.icon(
onPressed: _saveExpense,
icon: const Icon(Icons.check),
label: const Text(
'Add Expense',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.w700,
),
),
),
),

const SizedBox(height: 16),

SizedBox(
width: double.infinity,
height: 52,
child: OutlinedButton(
onPressed: () {
Navigator.pop(context);
},
child: const Text('Cancel'),
),
),
],
),
),
),
),
);
}
}


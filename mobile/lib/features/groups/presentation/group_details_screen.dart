
import 'package:flutter/material.dart';

import '../screens/add_member_screen.dart';
import '../../expenses/presentation/screens/add_group_expense_screen.dart';
import '../../expenses/models/expense.dart';

class GroupDetailsScreen extends StatefulWidget {
final Map<String, dynamic> group;

const GroupDetailsScreen({
super.key,
required this.group,
});

@override
State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  Future<void> _addExpense() async {
    final Expense? expense = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(
        builder: (_) => AddGroupExpenseScreen(
          group: widget.group,
        ),
      ),
    );

    if (expense == null) {
      return;
    }

    setState(() {
      _expenses.add(expense.toMap());
    });

    widget.group['expenses'] = _expenses;

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${expense.title} added'),
      ),
    );
  }
List<Map<String, dynamic>> _members = [];
List<Map<String, dynamic>> _expenses = [];

@override
void initState() {
super.initState();
_loadGroupData();
}

void _loadGroupData() {
final dynamic savedMembers = widget.group['members'];

if (savedMembers is List) {
_members = savedMembers
    .where((item) => item is Map)
    .map<Map<String, dynamic>>(
(item) => Map<String, dynamic>.from(
item as Map,
),
)
    .toList();
}

final dynamic savedExpenses = widget.group['expenses'];

if (savedExpenses is List) {
_expenses = savedExpenses
    .where((item) => item is Map)
    .map<Map<String, dynamic>>(
(item) => Map<String, dynamic>.from(
item as Map,
),
)
    .toList();
}
}

String get _groupName {
return widget.group['name']?.toString() ?? 'Unnamed Group';
}

String get _description {
return widget.group['description']?.toString() ?? '';
}

double get _totalExpenses {
double total = 0;

for (final expense in _expenses) {
final dynamic value = expense['amount'];

if (value is num) {
total += value.toDouble();
}
}

return total;
}

Future<void> _addMember() async {
final Map<String, dynamic>? result =
await Navigator.push<Map<String, dynamic>>(
context,
MaterialPageRoute(
builder: (_) => const AddMemberScreen(),
),
);

if (!mounted || result == null) {
return;
}

final String name = result['name']?.toString().trim() ?? '';

if (name.isEmpty) {
return;
}

final Map<String, dynamic> member = {
'name': name,
'avatar': name.substring(0, 1).toUpperCase(),
};

setState(() {
_members.add(member);
});

widget.group['members'] = List<Map<String, dynamic>>.from(_members);

if (!mounted) {
return;
}

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('$name added to the group'),
duration: const Duration(seconds: 2),
),
);
}

void _deleteMember(int index) {
if (index < 0 || index >= _members.length) {
return;
}

final String name =
_members[index]['name']?.toString() ?? 'Member';

setState(() {
_members.removeAt(index);
});

widget.group['members'] = List<Map<String, dynamic>>.from(_members);

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('$name removed from the group'),
duration: const Duration(seconds: 2),
),
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text(
_groupName,
style: const TextStyle(
fontWeight: FontWeight.w800,
),
),
),
body: SafeArea(
child: ListView(
padding: const EdgeInsets.all(20),
children: [
_buildGroupHeader(),
const SizedBox(height: 24),
_buildTotalCard(),
const SizedBox(height: 28),
_buildMembersSection(),
const SizedBox(height: 28),
_buildExpensesSection(),
const SizedBox(height: 40),
],
),
),
  floatingActionButton: Column(
    mainAxisSize: MainAxisSize.min,
    children: [

      FloatingActionButton.extended(
        heroTag: "member",
        onPressed: _addMember,
        icon: const Icon(Icons.person_add),
        label: const Text("Member"),
      ),

      const SizedBox(height: 12),

      FloatingActionButton.extended(
        heroTag: "expense",
        onPressed: _addExpense,
        icon: const Icon(Icons.receipt_long),
        label: const Text("Expense"),
      ),
    ],
  ),
icon: const Icon(Icons.person_add_alt_1),
label: const Text('Add Member'),
),
);
}

Widget _buildGroupHeader() {
return Container(
width: double.infinity,
padding: const EdgeInsets.all(22),
decoration: BoxDecoration(
color: Theme.of(context).colorScheme.primary,
borderRadius: BorderRadius.circular(24),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Container(
width: 60,
height: 60,
decoration: BoxDecoration(
color: Colors.white.withValues(alpha: 0.16),
borderRadius: BorderRadius.circular(18),
),
child: const Icon(
Icons.groups_rounded,
color: Colors.white,
size: 32,
),
),
const SizedBox(height: 18),
Text(
_groupName,
style: const TextStyle(
color: Colors.white,
fontSize: 25,
fontWeight: FontWeight.w800,
),
),
if (_description.isNotEmpty) ...[
const SizedBox(height: 7),
Text(
_description,
style: const TextStyle(
color: Colors.white70,
fontSize: 14,
height: 1.4,
),
),
],
const SizedBox(height: 18),
Text(
'${_members.length} ${_members.length == 1 ? 'member' : 'members'}',
style: const TextStyle(
color: Colors.white70,
fontWeight: FontWeight.w600,
),
),
],
),
);
}

Widget _buildTotalCard() {
return Container(
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(
color: Theme.of(context).colorScheme.surface,
borderRadius: BorderRadius.circular(20),
border: Border.all(
color: Colors.grey.withValues(alpha: 0.12),
),
),
child: Row(
children: [
Container(
width: 52,
height: 52,
decoration: BoxDecoration(
color: const Color(0xFF5B5FEF).withValues(alpha: 0.1),
borderRadius: BorderRadius.circular(16),
),
child: const Icon(
Icons.payments_outlined,
color: Color(0xFF5B5FEF),
),
),
const SizedBox(width: 16),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
'Total Expenses',
style: TextStyle(
color: Colors.grey,
fontSize: 14,
),
),
const SizedBox(height: 4),
Text(
'₱${_totalExpenses.toStringAsFixed(2)}',
style: const TextStyle(
fontSize: 22,
fontWeight: FontWeight.w800,
),
),
],
),
),
],
),
);
}

Widget _buildMembersSection() {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
const Expanded(
child: Text(
'Members',
style: TextStyle(
fontSize: 21,
fontWeight: FontWeight.w800,
),
),
),
TextButton.icon(
onPressed: _addMember,
icon: const Icon(Icons.add),
label: const Text('Add'),
),
],
),
const SizedBox(height: 12),
if (_members.isEmpty)
_buildEmptyMembers()
else
..._members.asMap().entries.map(
(entry) {
final int index = entry.key;
final Map<String, dynamic> member = entry.value;

return _MemberCard(
member: member,
onDelete: () => _confirmDeleteMember(index),
);
},
),
],
);
}

Widget _buildEmptyMembers() {
return Container(
width: double.infinity,
padding: const EdgeInsets.all(24),
decoration: BoxDecoration(
color: Theme.of(context).colorScheme.surface,
borderRadius: BorderRadius.circular(20),
border: Border.all(
color: Colors.grey.withValues(alpha: 0.12),
),
),
child: const Column(
children: [
Icon(
Icons.people_outline,
size: 42,
color: Colors.grey,
),
SizedBox(height: 10),
Text(
'No members yet',
style: TextStyle(
fontWeight: FontWeight.w700,
),
),
SizedBox(height: 4),
Text(
'Add people to start splitting expenses.',
textAlign: TextAlign.center,
style: TextStyle(
color: Colors.grey,
),
),
],
),
);
}

Future<void> _confirmDeleteMember(int index) async {
if (index < 0 || index >= _members.length) {
return;
}

final String name =
_members[index]['name']?.toString() ?? 'this member';

final bool? confirmed = await showDialog<bool>(
context: context,
builder: (dialogContext) {
return AlertDialog(
title: const Text('Remove member?'),
content: Text(
'Remove $name from the group?',
),
actions: [
TextButton(
onPressed: () {
Navigator.of(dialogContext).pop(false);
},
child: const Text('Cancel'),
),
FilledButton(
onPressed: () {
Navigator.of(dialogContext).pop(true);
},
child: const Text('Remove'),
),
],
);
},
);

if (confirmed == true && mounted) {
_deleteMember(index);
}
}

Widget _buildExpensesSection() {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
const Expanded(
child: Text(
  'Expenses',
  style: TextStyle(
    fontSize: 21,
    fontWeight: FontWeight.w800,
  ),
),
  ),
  TextButton.icon(
  onPressed: _addExpense,
  icon: const Icon(Icons.add),
  label: const Text('Add'),
  ),
  ],
  ),
style: TextStyle(
fontSize: 21,
fontWeight: FontWeight.w800,
),
),
const SizedBox(height: 12),
if (_expenses.isEmpty)
Container(
width: double.infinity,
padding: const EdgeInsets.all(24),
decoration: BoxDecoration(
color: Theme.of(context).colorScheme.surface,
borderRadius: BorderRadius.circular(20),
border: Border.all(
color: Colors.grey.withValues(alpha: 0.12),
),
),
child: const Column(
children: [
Icon(
Icons.receipt_long_outlined,
size: 42,
color: Colors.grey,
),
SizedBox(height: 10),
Text(
'No expenses yet',
style: TextStyle(
fontWeight: FontWeight.w700,
),
),
SizedBox(height: 4),
Text(
'Expenses for this group will appear here.',
textAlign: TextAlign.center,
style: TextStyle(
color: Colors.grey,
),
),
],
),
)
else
..._expenses.map(
(expense) {
final String name =
expense['name']?.toString() ?? 'Expense';

final dynamic amountValue = expense['amount'];

final double amount = amountValue is num
? amountValue.toDouble()
    : 0.0;

final String paidBy =
expense['paidBy']?.toString() ?? 'Me';

return Card(
margin: const EdgeInsets.only(bottom: 10),
child: ListTile(
leading: const CircleAvatar(
child: Icon(Icons.receipt_long),
),
title: Text(
name,
style: const TextStyle(
fontWeight: FontWeight.w700,
),
),
subtitle: Text(
'Paid by $paidBy',
),
trailing: Text(
'₱${amount.toStringAsFixed(2)}',
style: const TextStyle(
fontWeight: FontWeight.w800,
),
),
),
);
},
),
],
);
}
}

class _MemberCard extends StatelessWidget {
final Map<String, dynamic> member;
final VoidCallback onDelete;

const _MemberCard({
required this.member,
required this.onDelete,
});

@override
Widget build(BuildContext context) {
final String name =
member['name']?.toString().trim() ?? 'Unknown';

final String avatarLetter = name.isEmpty
? '?'
    : name.substring(0, 1).toUpperCase();

return Card(
margin: const EdgeInsets.only(bottom: 10),
child: ListTile(
contentPadding: const EdgeInsets.symmetric(
horizontal: 14,
vertical: 5,
),
leading: CircleAvatar(
radius: 24,
backgroundColor:
const Color(0xFF5B5FEF).withValues(alpha: 0.12),
foregroundColor: const Color(0xFF5B5FEF),
child: Text(
avatarLetter,
style: const TextStyle(
fontWeight: FontWeight.w800,
fontSize: 17,
),
),
),
title: Text(
name,
style: const TextStyle(
fontWeight: FontWeight.w700,
),
),
subtitle: const Text('Member'),
trailing: IconButton(
tooltip: 'Remove member',
onPressed: onDelete,
icon: const Icon(
Icons.delete_outline,
color: Colors.red,
),
),
),
);
}
}


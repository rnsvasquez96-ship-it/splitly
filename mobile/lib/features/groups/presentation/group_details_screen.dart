
import 'package:flutter/material.dart';

import '../screens/add_member_screen.dart';

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
late List<Map<String, dynamic>> _members;
late List<Map<String, dynamic>> _expenses;

@override
void initState() {
super.initState();

final savedMembers = widget.group['members'];

if (savedMembers is List) {
_members = savedMembers
    .whereType<Map>()
    .map(
(member) => Map<String, dynamic>.from(member),
)
    .toList();
} else {
_members = [];
}

final savedExpenses = widget.group['expenses'];

if (savedExpenses is List) {
_expenses = savedExpenses
    .whereType<Map>()
    .map(
(expense) => Map<String, dynamic>.from(expense),
)
    .toList();
} else {
_expenses = [];
}
}

String get _groupName {
return widget.group['name']?.toString() ?? 'Unnamed Group';
}

String get _description {
return widget.group['description']?.toString() ?? '';
}

double get _totalExpenses {
return _expenses.fold(
0.0,
(total, expense) {
final value = expense['amount'];

if (value is num) {
return total + value.toDouble();
}

return total;
},
);
}

Future<void> _addMember() async {
final result = await Navigator.push<Map<String, dynamic>>(
context,
MaterialPageRoute(
builder: (_) => const AddMemberScreen(),
),
);

if (!mounted || result == null) {
return;
}

setState(() {
_members.add(result);
});

widget.group['members'] = _members;
}

void _deleteMember(int index) {
setState(() {
_members.removeAt(index);
});

widget.group['members'] = _members;
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
floatingActionButton: FloatingActionButton.extended(
onPressed: _addMember,
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
final index = entry.key;
final member = entry.value;

return _MemberCard(
member: member,
onDelete: () => _deleteMember(index),
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

Widget _buildExpensesSection() {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
'Expenses',
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
final name =
expense['name']?.toString() ?? 'Expense';

final amountValue = expense['amount'];

final amount = amountValue is num
? amountValue.toDouble()
    : 0.0;

final paidBy =
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
subtitle: Text('Paid by $paidBy'),
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
final name = member['name']?.toString() ?? 'Unknown';

final avatarLetter = name.trim().isEmpty
? '?'
    : name.trim()[0].toUpperCase();

return Card(
margin: const EdgeInsets.only(bottom: 10),
child: ListTile(
contentPadding: const EdgeInsets.symmetric(
horizontal: 14,
vertical: 5,
),
leading: CircleAvatar(
backgroundColor:
const Color(0xFF5B5FEF).withValues(alpha: 0.12),
foregroundColor: const Color(0xFF5B5FEF),
child: Text(
avatarLetter,
style: const TextStyle(
fontWeight: FontWeight.w800,
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
onPressed: () {
_confirmDelete(context);
},
icon: const Icon(
Icons.delete_outline,
color: Colors.red,
),
),
),
);
}

void _confirmDelete(BuildContext context) {
showDialog<void>(
context: context,
builder: (context) {
return AlertDialog(
title: const Text('Remove member?'),
content: Text(
'Remove ${member['name'] ?? 'this member'} from the group?',
),
actions: [
TextButton(
onPressed: () {
Navigator.pop(context);
},
child: const Text('Cancel'),
),
FilledButton(
onPressed: () {
Navigator.pop(context);
onDelete();
},
child: const Text('Remove'),
),
],
);
},
);
}
}

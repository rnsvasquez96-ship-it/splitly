import 'package:flutter/material.dart';

import '../models/group.dart';
import '../models/member.dart';
import '../../expenses/models/expense.dart';
import '../../expenses/presentation/screens/add_group_expense_screen.dart';
import '../screens/add_member_screen.dart';
import '../../settlements/presentation/balance_section.dart';
import '../../settlements/presentation/settlement_section.dart';


class GroupDetailsScreen extends StatefulWidget {
  final Group group;

  const GroupDetailsScreen({
    super.key,
    required this.group,
  });

  @override
  State<GroupDetailsScreen> createState() =>
      _GroupDetailsScreenState();
}

class _GroupDetailsScreenState
    extends State<GroupDetailsScreen> {
late List<Member> _members;
late List<Expense> _expenses;

@override
void initState() {
super.initState();

_members = List<Member>.from(widget.group.members);
_expenses = List<Expense>.from(widget.group.expenses);
}

String get _groupName => widget.group.name;

String get _description => widget.group.description;

double get _totalExpenses {
double total = 0;

for (final expense in _expenses) {
total += expense.amount;
}

return total;
}

Future<void> _addMember() async {
final Member? member =
await Navigator.push<Member>(
context,
MaterialPageRoute(
builder: (_) => const AddMemberScreen(),
),
);

if (member == null) {
return;
}

setState(() {
_members.add(member);
widget.group.members.add(member);
});

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text("${member.name} added"),
),
);
}

Future<void> _addExpense() async {
final Expense? expense =
await Navigator.push<Expense>(
context,
MaterialPageRoute(
builder: (_) =>
AddGroupExpenseScreen(
group: widget.group,
),
),
);

if (expense == null) {
return;
}

setState(() {
_expenses.add(expense);
widget.group.expenses.add(expense);
});

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(
"${expense.title} added",
),
),
);
}

void _deleteMember(int index) {
final member = _members[index];

setState(() {
_members.removeAt(index);
widget.group.members.remove(member);
});

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(
"${member.name} removed",
),
),
);
}

Future<void> _confirmDeleteMember(
int index) async {
final bool? result =
await showDialog<bool>(
context: context,
builder: (_) {
return AlertDialog(
title:
const Text("Remove member?"),
content: Text(
"Remove ${_members[index].name} from the group?",
),
actions: [
TextButton(
onPressed: () =>
Navigator.pop(
context,
false,
),
child:
const Text("Cancel"),
),
FilledButton(
onPressed: () =>
Navigator.pop(
context,
true,
),
child:
const Text("Remove"),
),
],
);
},
);

if (result == true) {
_deleteMember(index);
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text(
_groupName,
style: const TextStyle(
fontWeight:
FontWeight.bold,
),
),
),      body: SafeArea(
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

    // NEW
    const SizedBox(height: 28),

    BalanceSection(
      expenses: _expenses,
    ),

    const SizedBox(height: 28),

    SettlementSection(
      expenses: _expenses,
    ),

    const SizedBox(height: 80),
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
color: Colors.white.withValues(alpha: .15),
borderRadius: BorderRadius.circular(18),
),
child: const Icon(
Icons.groups,
color: Colors.white,
size: 30,
),
),
const SizedBox(height: 18),
Text(
_groupName,
style: const TextStyle(
color: Colors.white,
fontSize: 25,
fontWeight: FontWeight.bold,
),
),
if (_description.isNotEmpty) ...[
const SizedBox(height: 8),
Text(
_description,
style: const TextStyle(
color: Colors.white70,
),
),
],
const SizedBox(height: 18),
Text(
"${_members.length} ${_members.length == 1 ? "member" : "members"}",
style: const TextStyle(
color: Colors.white70,
),
),
],
),
);
}

Widget _buildTotalCard() {
return Card(
child: Padding(
padding: const EdgeInsets.all(18),
child: Row(
children: [
Container(
width: 54,
height: 54,
decoration: BoxDecoration(
color: const Color(0xFF5B5FEF).withValues(alpha: .10),
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
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
const Text(
"Total Expenses",
style: TextStyle(
color: Colors.grey,
),
),
const SizedBox(height: 4),
Text(
"₱${_totalExpenses.toStringAsFixed(2)}",
style: const TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
),
),
],
),
),
],
),
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
"Members",
style: TextStyle(
fontSize: 21,
fontWeight: FontWeight.bold,
),
),
),
TextButton.icon(
onPressed: _addMember,
icon: const Icon(Icons.add),
label: const Text("Add"),
),
],
),

const SizedBox(height: 12),

if (_members.isEmpty)
Card(
child: Padding(
padding: const EdgeInsets.all(24),
child: Column(
children: const [
Icon(
Icons.people_outline,
size: 42,
color: Colors.grey,
),
SizedBox(height: 10),
Text(
"No members yet",
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
SizedBox(height: 6),
Text(
"Add members to begin splitting expenses.",
textAlign: TextAlign.center,
),
],
),
),
)
else
..._members.asMap().entries.map(
(entry) {
return _MemberCard(
member: entry.value,
onDelete: () =>
_confirmDeleteMember(entry.key),
);
},
),
],
);
}

Widget _buildExpensesSection() {


return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
const Expanded(
child: Text(
"Expenses",
style: TextStyle(
fontSize: 21,
fontWeight: FontWeight.bold,
),
),
),
TextButton.icon(
onPressed: _addExpense,
icon: const Icon(Icons.add),
label: const Text("Add"),
),
],
),


const SizedBox(height: 12),

if (_expenses.isEmpty)
Card(
child: Padding(
padding: const EdgeInsets.all(24),
child: Column(
children: const [
Icon(
Icons.receipt_long_outlined,
size: 42,
color: Colors.grey,
),
SizedBox(height: 10),
Text(
"No expenses yet",
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
SizedBox(height: 6),
Text(
"Expenses will appear here.",
textAlign: TextAlign.center,
),
],
),
),
)
else
..._expenses.map(
(expense) {

return Card(
margin:
const EdgeInsets.only(bottom: 10),
child: ListTile(
leading: const CircleAvatar(
child: Icon(Icons.receipt_long),
),
title: Text(
expense.title,
style: const TextStyle(
fontWeight: FontWeight.bold,
),
),
subtitle: Text(
"Paid by ${expense.paidBy}",
),
trailing: Text(
"₱${expense.amount.toStringAsFixed(2)}",
style: const TextStyle(
fontWeight: FontWeight.bold,
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
  final Member member;
  final VoidCallback onDelete;

  const _MemberCard({
    required this.member,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = member.name.isEmpty
        ? '?'
        : member.name[0].toUpperCase();

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 6,
        ),
        leading: CircleAvatar(
          backgroundColor:
          const Color(0xFF5B5FEF).withValues(alpha: .12),
          foregroundColor: const Color(0xFF5B5FEF),
          child: Text(
            avatar,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          member.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text("Member"),
        trailing: IconButton(
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
import 'package:flutter/material.dart';

import '../models/member.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveMember() {
    final String name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a member name.'),
        ),
      );
      return;
    }

    final member = Member(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );

    Navigator.pop<Member>(
      context,
      member,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Member"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: "Member Name",
                hintText: "e.g. John",
                prefixIcon: Icon(Icons.person_outline),
              ),
              onSubmitted: (_) => _saveMember(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: FilledButton.icon(
                onPressed: _saveMember,
                icon: const Icon(Icons.person_add),
                label: const Text("Add Member"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
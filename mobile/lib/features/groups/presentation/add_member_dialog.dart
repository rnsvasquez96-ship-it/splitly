import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/member.dart';

class AddMemberDialog extends StatefulWidget {
  const AddMemberDialog({super.key});

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Member"),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(hintText: "Member name"),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: () {
            if (_controller.text.trim().isEmpty) {
              return;
            }

            Navigator.pop(
              context,
              Member(id: const Uuid().v4(), name: _controller.text.trim()),
            );
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}

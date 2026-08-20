import 'package:flutter/material.dart';

import '../models/group.dart';

class EditGroupScreen extends StatefulWidget {
  final Group group;

  const EditGroupScreen({super.key, required this.group});

  @override
  State<EditGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.group.name);

    _descriptionController = TextEditingController(
      text: widget.group.description,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    widget.group.name = _nameController.text.trim();
    widget.group.description = _descriptionController.text.trim();

    Navigator.pop(context, widget.group);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Group")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Group Name"),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Required";
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Description"),
            ),

            const SizedBox(height: 40),

            FilledButton(onPressed: _save, child: const Text("Save Changes")),
          ],
        ),
      ),
    );
  }
}

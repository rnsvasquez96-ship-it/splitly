import 'package:flutter/material.dart';

import '../models/group.dart';

class GroupFormScreen extends StatefulWidget {
  final Group? group;

  const GroupFormScreen({
    super.key,
    this.group,
  });

  @override
  State<GroupFormScreen> createState() =>
      _GroupFormScreenState();
}

class _GroupFormScreenState
    extends State<GroupFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.group != null) {
      _nameController.text = widget.group!.name;
      _descriptionController.text =
          widget.group!.description;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveGroup() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.group != null) {
      widget.group!.name =
          _nameController.text.trim();

      widget.group!.description =
          _descriptionController.text.trim();

      Navigator.pop(
        context,
        widget.group,
      );

      return;
    }

    final group = Group(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      name: _nameController.text.trim(),
      description:
      _descriptionController.text.trim(),
      members: [],
      expenses: [],
    );

    Navigator.pop<Group>(
      context,
      group,
    );
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.group != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editing
              ? "Edit Group"
              : "Create Group",
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                editing
                    ? "Edit Group"
                    : "Create a new group",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                editing
                    ? "Update your group information."
                    : "Create a group to split expenses with friends or family.",
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Group Name",
                  prefixIcon: Icon(Icons.groups),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Please enter a group name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller:
                _descriptionController,
                maxLines: 3,
                decoration:
                const InputDecoration(
                  labelText: "Description",
                  prefixIcon:
                  Icon(Icons.description),
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                height: 55,
                child: FilledButton(
                  onPressed: _saveGroup,
                  child: Text(
                    editing
                        ? "Save Changes"
                        : "Create Group",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
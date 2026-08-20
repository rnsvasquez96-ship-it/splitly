import 'package:flutter/material.dart';

import '../models/member.dart';

class MemberFormScreen extends StatefulWidget {
  final Member? member;

  const MemberFormScreen({super.key, this.member});

  @override
  State<MemberFormScreen> createState() => _MemberFormScreenState();
}

class _MemberFormScreenState extends State<MemberFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.member != null) {
      _nameController.text = widget.member!.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveMember() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();

    if (widget.member != null) {
      Navigator.pop(context, Member(id: widget.member!.id, name: name));
      return;
    }

    Navigator.pop(
      context,
      Member(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.member != null;

    return Scaffold(
      appBar: AppBar(title: Text(editing ? "Edit Member" : "Add Member")),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: "Member Name",
                    hintText: "e.g. John",
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a member name";
                    }

                    return null;
                  },
                  onFieldSubmitted: (_) => _saveMember(),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: FilledButton.icon(
                    onPressed: _saveMember,
                    icon: Icon(editing ? Icons.save : Icons.person_add),
                    label: Text(editing ? "Save Changes" : "Add Member"),
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

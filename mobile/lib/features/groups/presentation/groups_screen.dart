import 'package:flutter/material.dart';

import '../models/group.dart';
import '../screens/create_group_screen.dart';
import 'group_details_screen.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final List<Group> _groups = [];

  Future<void> _openCreateGroup() async {
    final Group? group = await Navigator.push<Group>(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateGroupScreen(),
      ),
    );

    if (group == null) return;

    setState(() {
      _groups.add(group);
    });
  }

  void _openGroup(Group group) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GroupDetailsScreen(
          group: group,
        ),
      ),
    );
  }

  void _deleteGroup(int index) {
    setState(() {
      _groups.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Groups",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateGroup,
        icon: const Icon(Icons.add),
        label: const Text("Create Group"),
      ),
      body: _groups.isEmpty
          ? const _EmptyState()
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _groups.length,
        itemBuilder: (context, index) {
          final group = _groups[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                Theme.of(context).colorScheme.primaryContainer,
                child: const Icon(Icons.groups),
              ),
              title: Text(
                group.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "${group.members.length} members",
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
                onPressed: () => _deleteGroup(index),
              ),
              onTap: () => _openGroup(group),
            ),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.groups_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            const Text(
              "No groups yet",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Create your first group to start splitting expenses.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
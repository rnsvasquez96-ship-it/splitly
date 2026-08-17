import 'package:flutter/material.dart';

import '../models/group.dart';
import '../repository/group_repository.dart';
import '../screens/group_form_screen.dart';
import 'group_details_screen.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final GroupRepository _repository =
      GroupRepository.instance;

  final TextEditingController _searchController =
  TextEditingController();

  String _search = "";


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _editGroup(Group group) async {
    final Group? updatedGroup =
    await Navigator.push<Group>(
      context,
      MaterialPageRoute(
        builder: (_) => GroupFormScreen(
          group: group,
        ),
      ),
    );

    if (updatedGroup == null) return;

    await _repository.saveGroups();

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _loadGroups() async {
    await _repository.loadGroups();

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _openCreateGroup() async {
    final Group? group = await Navigator.push<Group>(
      context,
      MaterialPageRoute(
        builder: (_) => const GroupFormScreen(),
      ),
    );

    if (group == null) return;

    await _repository.addGroup(group);

    if (!mounted) return;

    setState(() {});
  }

  void _openGroup(Group group) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GroupDetailsScreen(
          group: group,
        ),
      ),
    ).then((_) async {
      await _repository.saveGroups();

      if (!mounted) return;

      setState(() {});
    });
  }

  Future<void> _deleteGroup(Group group) async {
    await _repository.removeGroup(group);

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final groups = _repository
        .getGroups()
        .where(
          (group) =>
      group.name
          .toLowerCase()
          .contains(_search.toLowerCase()) ||
          group.description
              .toLowerCase()
              .contains(_search.toLowerCase()),
    )
        .toList();

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search groups...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _search = value;
                });
              },
            ),
          ),

          Expanded(
            child: groups.isEmpty
                ? const _EmptyState()
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _editGroup(group),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => _deleteGroup(group),
                        ),
                      ],
                    ),
                    onTap: () => _openGroup(group),
                  ),
                );
              },
            ),
          ),
        ],
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
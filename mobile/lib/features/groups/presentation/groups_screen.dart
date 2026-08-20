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
  final GroupRepository _repository = GroupRepository.instance;

  final TextEditingController _searchController = TextEditingController();

  String _search = "";
  bool _loading = true;

  List<Group> get _filteredGroups {
    final query = _search.trim().toLowerCase();

    if (query.isEmpty) {
      return _repository.getGroups();
    }

    return _repository.getGroups().where((group) {
      return group.name.toLowerCase().contains(query) ||
          group.description.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadGroups() async {
    try {
      await _repository.loadGroups();
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _refreshGroups() async {
    await _repository.loadGroups();

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> _openCreateGroup() async {
    final Group? group = await Navigator.of(context).push<Group>(
      MaterialPageRoute(builder: (context) => const GroupFormScreen()),
    );

    if (group == null) {
      return;
    }

    await _repository.addGroup(group);

    if (!mounted) {
      return;
    }

    setState(() {});

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("${group.name} created")));
  }

  Future<void> _editGroup(Group group) async {
    final Group? updatedGroup = await Navigator.of(context).push<Group>(
      MaterialPageRoute(builder: (context) => GroupFormScreen(group: group)),
    );

    if (updatedGroup == null) {
      return;
    }

    await _repository.updateGroup(updatedGroup);

    if (!mounted) {
      return;
    }

    setState(() {});

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Group updated")));
  }

  Future<void> _openGroup(Group group) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => GroupDetailsScreen(group: group)),
    );

    await _repository.loadGroups();

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> _confirmDeleteGroup(Group group) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Delete Group?"),
          content: Text(
            "Are you sure you want to delete "
            "\"${group.name}\"?\n\n"
            "Its members and expenses will also be removed.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text("Cancel"),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await _repository.removeGroup(group);

    if (!mounted) {
      return;
    }

    setState(() {});

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("${group.name} deleted")));
  }

  double _groupTotal(Group group) {
    return group.expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  @override
  Widget build(BuildContext context) {
    final groups = _filteredGroups;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7FB),
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Groups",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateGroup,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          "Create Group",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshGroups,
              child: Column(
                children: [
                  _buildHeader(groupCount: _repository.getGroups().length),
                  _buildSearchField(),
                  Expanded(
                    child: groups.isEmpty
                        ? _EmptyState(
                            searching: _search.isNotEmpty,
                            onCreateGroup: _openCreateGroup,
                          )
                        : _buildGroupList(groups),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader({required int groupCount}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              groupCount == 0
                  ? "Start splitting expenses"
                  : "$groupCount "
                        "${groupCount == 1 ? "group" : "groups"}",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),
          if (groupCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary
                    .withValues(alpha: .10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.groups_rounded,
                    size: 17,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    groupCount.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
      child: TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Search your groups",
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _search.isEmpty
              ? null
              : IconButton(
                  tooltip: "Clear",
                  onPressed: () {
                    _searchController.clear();

                    setState(() {
                      _search = "";
                    });
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Colors.grey.withValues(alpha: .12)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _search = value;
          });
        },
      ),
    );
  }

  Widget _buildGroupList(List<Group> groups) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      itemCount: groups.length,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },
      itemBuilder: (context, index) {
        final group = groups[index];

        return _GroupCard(
          group: group,
          totalExpenses: _groupTotal(group),
          onTap: () {
            _openGroup(group);
          },
          onEdit: () {
            _editGroup(group);
          },
          onDelete: () {
            _confirmDeleteGroup(group);
          },
        );
      },
    );
  }
}

class _GroupCard extends StatelessWidget {
  final Group group;
  final double totalExpenses;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _GroupCard({
    required this.group,
    required this.totalExpenses,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.grey.withValues(alpha: .10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .035),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary
                      .withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  Icons.groups_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 27,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            group.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          tooltip: "Group options",
                          icon: const Icon(Icons.more_horiz_rounded),
                          onSelected: (value) {
                            if (value == "edit") {
                              onEdit();
                            }

                            if (value == "delete") {
                              onDelete();
                            }
                          },
                          itemBuilder: (context) {
                            return const [
                              PopupMenuItem(
                                value: "edit",
                                child: Row(
                                  children: [
                                    Icon(Icons.edit_outlined, size: 20),
                                    SizedBox(width: 12),
                                    Text("Edit"),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: "delete",
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_outline,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ];
                          },
                        ),
                      ],
                    ),
                    if (group.description.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        group.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const SizedBox(height: 13),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _InfoChip(
                          icon: Icons.people_outline_rounded,
                          text:
                              "${group.members.length} "
                              "${group.members.length == 1 ? "member" : "members"}",
                        ),
                        _InfoChip(
                          icon: Icons.receipt_long_outlined,
                          text:
                              "${group.expenses.length} "
                              "${group.expenses.length == 1 ? "expense" : "expenses"}",
                        ),
                      ],
                    ),
                    if (group.expenses.isNotEmpty) ...[
                      const SizedBox(height: 13),
                      Row(
                        children: [
                          Text(
                            "Total spent",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "₱${totalExpenses.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.grey.shade600),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool searching;
  final VoidCallback onCreateGroup;

  const _EmptyState({required this.searching, required this.onCreateGroup});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(30, 70, 30, 120),
      children: [
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.symmetric(horizontal: 80),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: .10),
            shape: BoxShape.circle,
          ),
          child: Icon(
            searching ? Icons.search_off_rounded : Icons.groups_outlined,
            size: 50,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          searching ? "No groups found" : "No groups yet",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 9),
        Text(
          searching
              ? "Try searching for another group name."
              : "Create your first group and start "
                    "splitting expenses together.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600, height: 1.5),
        ),
        if (!searching) ...[
          const SizedBox(height: 28),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: onCreateGroup,
              icon: const Icon(Icons.add_rounded),
              label: const Text("Create Your First Group"),
            ),
          ),
        ],
      ],
    );
  }
}

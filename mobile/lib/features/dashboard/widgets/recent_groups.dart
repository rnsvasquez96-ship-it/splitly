import 'package:flutter/material.dart';

import '../../groups/models/group.dart';

class RecentGroups extends StatelessWidget {
  final List<Group> groups;
  final Function(Group group) onTap;

  const RecentGroups({
    super.key,
    required this.groups,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Groups",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        ...groups.take(3).map(
              (group) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _GroupTile(
              group: group,
              onTap: () => onTap(group),
            ),
          ),
        ),
      ],
    );
  }
}

class _GroupTile extends StatelessWidget {
  final Group group;
  final VoidCallback onTap;

  const _GroupTile({
    required this.group,
    required this.onTap,
  });

  Color _avatarColor() {
    final colors = [
      const Color(0xFF5B5FEF),
      const Color(0xFF00C896),
      const Color(0xFFFFB800),
      const Color(0xFFFF5A5F),
      const Color(0xFF3B82F6),
      const Color(0xFF8B5CF6),
    ];

    return colors[group.name.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final color = _avatarColor();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .04),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.groups_rounded,
                  color: color,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "${group.members.length} members",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₱${group.expenses.fold<double>(
                      0,
                          (sum, e) => sum + e.amount,
                    ).toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey.shade500,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
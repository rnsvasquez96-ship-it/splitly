import 'package:flutter/material.dart';

import '../../groups/models/group.dart';

class RecentGroups extends StatelessWidget {
  final List<Group> groups;
  final ValueChanged<Group> onTap;

  const RecentGroups({super.key, required this.groups, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return const SizedBox.shrink();
    }

    final recentGroups = groups.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recent Groups",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.3,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "Your active expense groups",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary
                    .withValues(alpha: .08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.groups_rounded,
                size: 19,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.grey.withValues(alpha: .10)),
          ),
          child: Column(
            children: List.generate(recentGroups.length, (index) {
              final group = recentGroups[index];

              return Column(
                children: [
                  _GroupTile(group: group, onTap: () => onTap(group)),
                  if (index != recentGroups.length - 1)
                    Padding(
                      padding: const EdgeInsets.only(left: 78, right: 18),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.withValues(alpha: .10),
                      ),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _GroupTile extends StatelessWidget {
  final Group group;
  final VoidCallback onTap;

  const _GroupTile({required this.group, required this.onTap});

  double get _totalExpenses {
    return group.expenses.fold<double>(
      0,
      (sum, expense) => sum + expense.amount,
    );
  }

  Color _groupColor() {
    const colors = [
      Color(0xFF5B5FEF),
      Color(0xFF00A67E),
      Color(0xFFE99B00),
      Color(0xFFE8525B),
      Color(0xFF3B82F6),
      Color(0xFF8B5CF6),
    ];

    return colors[group.name.hashCode.abs() % colors.length];
  }

  String _initials() {
    final words = group.name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    if (words.isEmpty) {
      return "?";
    }

    if (words.length == 1) {
      final word = words.first;

      if (word.length == 1) {
        return word.toUpperCase();
      }

      return word.substring(0, 2).toUpperCase();
    }

    return "${words[0][0]}${words[1][0]}".toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final color = _groupColor();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  _initials(),
                  style: TextStyle(
                    color: color,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -.3,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        Icon(
                          Icons.people_outline_rounded,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          "${group.members.length} "
                          "${group.members.length == 1 ? "member" : "members"}",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: Text(
                            "•",
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                        ),

                        Flexible(
                          child: Text(
                            "${group.expenses.length} "
                            "${group.expenses.length == 1 ? "expense" : "expenses"}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₱${_totalExpenses.toStringAsFixed(2)}",
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "View",
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(Icons.chevron_right_rounded, size: 17, color: color),
                    ],
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

import 'package:flutter/material.dart';

import '../../../app/widgets/animated_counter.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;

  const StatCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
  });

  bool get _isCurrency => value.startsWith("₱");

  double get _numericValue {
    return double.tryParse(
          value.replaceAll("₱", "").replaceAll(",", "").trim(),
        ) ??
        0;
  }

  String get _subtitle {
    switch (title.toLowerCase()) {
      case "groups":
        return "Active groups";

      case "expenses":
        return "Total spending";

      case "members":
        return "Across groups";

      case "transactions":
        return "Recorded";

      case "average":
        return "Per expense";

      default:
        return "Overview";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: .10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: color, size: 21),
              ),

              const Spacer(),

              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .07),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.north_east_rounded, color: color, size: 14),
              ),
            ],
          ),

          const Spacer(),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: AnimatedCounter(
              value: _numericValue,
              prefix: _isCurrency ? "₱" : "",
              decimals: _isCurrency ? 0 : 0,
              duration: 900,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
                letterSpacing: -.7,
                color: Color(0xFF202124),
              ),
            ),
          ),

          const SizedBox(height: 5),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 2),

          Text(
            _subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

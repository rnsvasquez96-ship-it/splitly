import 'package:flutter/material.dart';

import '../models/settlement.dart';

class SettlementCard extends StatelessWidget {
  final Settlement settlement;

  const SettlementCard({
    super.key,
    required this.settlement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.swap_horiz),
        ),
        title: Text(
          "${settlement.from} owes ${settlement.to}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text("Pending"),
        trailing: Text(
          "₱${settlement.amount.toStringAsFixed(2)}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
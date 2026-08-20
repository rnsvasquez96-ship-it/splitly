import 'package:flutter/material.dart';

import '../models/settlement.dart';

class SettlementCard extends StatelessWidget {
  final Settlement settlement;
  final VoidCallback onSettle;

  const SettlementCard({
    super.key,
    required this.settlement,
    required this.onSettle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.swap_horiz)),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${settlement.from} owes ${settlement.to}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 4),

                      const Text("Pending"),
                    ],
                  ),
                ),

                Text(
                  "₱${settlement.amount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onSettle,
                icon: const Icon(Icons.check_circle),
                label: const Text("Settle Up"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../expenses/models/expense.dart';
import '../services/settlement_service.dart';

class SettlementSection extends StatelessWidget {
  final List<Expense> expenses;

  const SettlementSection({
    super.key,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    final settlements = SettlementService.calculate(expenses);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Suggested Settlements",
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        if (settlements.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: const [
                  Icon(
                    Icons.handshake_outlined,
                    size: 42,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Everyone is settled",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "No payments are required.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ...settlements.map(
                (settlement) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.compare_arrows),
                  ),
                  title: Text(
                    "${settlement.from} → ${settlement.to}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    "Suggested payment",
                  ),
                  trailing: Text(
                    "₱${settlement.amount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
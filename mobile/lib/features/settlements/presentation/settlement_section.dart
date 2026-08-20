import 'package:flutter/material.dart';

import '../../expenses/models/expense.dart';
import '../services/settlement_service.dart';
import '../services/settlement_history_service.dart';
import '../widgets/settlement_card.dart';
import '../models/settlement.dart';

class SettlementSection extends StatelessWidget {
  final List<Expense> expenses;

  const SettlementSection({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final settlements = SettlementService.calculate(expenses);

    final pendingSettlements = settlements
        .where(
          (settlement) =>
              !SettlementHistoryService.instance.isSettled(settlement),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Suggested Settlements",
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        if (pendingSettlements.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: const [
                  Icon(Icons.handshake_outlined, size: 42, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "Everyone is settled",
                    style: TextStyle(fontWeight: FontWeight.bold),
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
          ...pendingSettlements.map((settlement) {
            return SettlementCard(
              settlement: settlement,
              onSettle: () {
                SettlementHistoryService.instance.settle(
                  Settlement(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    from: settlement.from,
                    to: settlement.to,
                    amount: settlement.amount,
                    settledAt: DateTime.now(),
                  ),
                );

                (context as Element).markNeedsBuild();
              },
            );
          }),
      ],
    );
  }
}

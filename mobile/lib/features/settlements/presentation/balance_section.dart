import 'package:flutter/material.dart';

import '../../expenses/models/expense.dart';

class BalanceSection extends StatelessWidget {
  final List<Expense> expenses;

  const BalanceSection({
    super.key,
    required this.expenses,
  });

  Map<String, double> _calculateBalances() {
    final Map<String, double> balances = {};

    for (final expense in expenses) {
      final share = expense.amount / expense.splitBetween.length;

      balances.putIfAbsent(expense.paidBy, () => 0);
      balances[expense.paidBy] =
          balances[expense.paidBy]! + expense.amount;

      for (final member in expense.splitBetween) {
        balances.putIfAbsent(member, () => 0);
        balances[member] = balances[member]! - share;
      }
    }

    return balances;
  }

  @override
  Widget build(BuildContext context) {
    final balances = _calculateBalances();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Balances",
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        if (balances.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: const [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 42,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "No balances yet",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Add expenses to calculate balances.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ...balances.entries.map(
                (entry) {
              final value = entry.value;

              Color color;
              String status;

              if (value > 0.01) {
                color = Colors.green;
                status = "Gets Back";
              } else if (value < -0.01) {
                color = Colors.red;
                status = "Owes";
              } else {
                color = Colors.grey;
                status = "Settled";
              }

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                    color.withValues(alpha: .15),
                    child: Icon(
                      Icons.person,
                      color: color,
                    ),
                  ),
                  title: Text(
                    entry.key,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(status),
                  trailing: Text(
                    "₱${value.abs().toStringAsFixed(2)}",
                    style: TextStyle(
                      color: color,
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
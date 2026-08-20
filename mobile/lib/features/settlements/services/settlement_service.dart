import '../../expenses/models/expense.dart';
import '../models/settlement.dart';

class SettlementService {
  static List<Settlement> calculate(List<Expense> expenses) {
    final balances = <String, double>{};

    for (final expense in expenses) {
      final share = expense.amount / expense.splitBetween.length;

      balances.update(
        expense.paidBy,
        (v) => v + expense.amount,
        ifAbsent: () => expense.amount,
      );

      for (final member in expense.splitBetween) {
        balances.update(member, (v) => v - share, ifAbsent: () => -share);
      }
    }

    final creditors = <MapEntry<String, double>>[];
    final debtors = <MapEntry<String, double>>[];

    balances.forEach((name, balance) {
      if (balance > 0.01) {
        creditors.add(MapEntry(name, balance));
      } else if (balance < -0.01) {
        debtors.add(MapEntry(name, balance));
      }
    });

    final settlements = <Settlement>[];

    int i = 0;
    int j = 0;

    while (i < debtors.length && j < creditors.length) {
      final debtor = debtors[i];
      final creditor = creditors[j];

      final double amount = (-debtor.value)
          .clamp(0.0, creditor.value)
          .toDouble();

      settlements.add(
        Settlement(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          from: debtor.key,
          to: creditor.key,
          amount: amount,
          settledAt: DateTime.now(),
        ),
      );

      debtors[i] = MapEntry(debtor.key, debtor.value + amount);

      creditors[j] = MapEntry(creditor.key, creditor.value - amount);

      if (debtors[i].value.abs() < 0.01) {
        i++;
      }

      if (creditors[j].value.abs() < 0.01) {
        j++;
      }
    }

    return settlements;
  }
}

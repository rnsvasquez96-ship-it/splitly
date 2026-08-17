import '../../expenses/models/expense.dart';

class Settlement {
  final String from;
  final String to;
  final double amount;

  Settlement({
    required this.from,
    required this.to,
    required this.amount,
  });
}

class SplitService {
  static List<Settlement> calculate(
      List<Expense> expenses,
      ) {
    final Map<String, double> balances = {};

    for (final expense in expenses) {
      final share =
          expense.amount / expense.splitBetween.length;

      balances.putIfAbsent(expense.paidBy, () => 0);

      balances[expense.paidBy] =
          balances[expense.paidBy]! + expense.amount;

      for (final member in expense.splitBetween) {
        balances.putIfAbsent(member, () => 0);

        balances[member] =
            balances[member]! - share;
      }
    }

    final creditors = <MapEntry<String, double>>[];
    final debtors = <MapEntry<String, double>>[];

    balances.forEach((name, value) {
      if (value > 0.01) {
        creditors.add(MapEntry(name, value));
      } else if (value < -0.01) {
        debtors.add(MapEntry(name, value));
      }
    });

    final settlements = <Settlement>[];

    int i = 0;
    int j = 0;

    while (i < debtors.length &&
        j < creditors.length) {
      final debtor = debtors[i];
      final creditor = creditors[j];

      final amount = (-debtor.value)
          .clamp(0, creditor.value);

      settlements.add(
        Settlement(
          from: debtor.key,
          to: creditor.key,
          amount: amount,
        ),
      );

      debtors[i] = MapEntry(
        debtor.key,
        debtor.value + amount,
      );

      creditors[j] = MapEntry(
        creditor.key,
        creditor.value - amount,
      );

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
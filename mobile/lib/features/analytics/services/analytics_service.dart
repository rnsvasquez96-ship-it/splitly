import '../../expenses/models/expense.dart';
import '../../expenses/models/expense_category.dart';
import '../../groups/models/group.dart';

class AnalyticsService {
  const AnalyticsService._();

  static double totalSpent(List<Expense> expenses) {
    return expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  static int totalTransactions(List<Expense> expenses) {
    return expenses.length;
  }

  static int totalGroups(List<Group> groups) {
    return groups.length;
  }

  static int totalMembers(List<Group> groups) {
    return groups.fold(0, (sum, group) => sum + group.members.length);
  }

  static double averageExpense(List<Expense> expenses) {
    if (expenses.isEmpty) return 0;

    return totalSpent(expenses) / expenses.length;
  }

  static Expense? largestExpense(List<Expense> expenses) {
    if (expenses.isEmpty) return null;

    Expense largest = expenses.first;

    for (final expense in expenses) {
      if (expense.amount > largest.amount) {
        largest = expense;
      }
    }

    return largest;
  }

  static Map<String, double> memberTotals(List<Expense> expenses) {
    final totals = <String, double>{};

    for (final expense in expenses) {
      totals.update(
        expense.paidBy,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    return totals;
  }

  static String? topSpender(List<Expense> expenses) {
    final totals = memberTotals(expenses);

    if (totals.isEmpty) return null;

    return totals.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  static Map<ExpenseCategory, double> categoryTotals(List<Expense> expenses) {
    final totals = <ExpenseCategory, double>{};

    for (final expense in expenses) {
      totals.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    return totals;
  }

  static Map<String, double> monthlyTotals(List<Expense> expenses) {
    final totals = <String, double>{};

    for (final expense in expenses) {
      final key = "${expense.createdAt.month}/${expense.createdAt.year}";

      totals.update(
        key,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    return totals;
  }
}

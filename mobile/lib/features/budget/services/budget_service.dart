import '../../expenses/models/expense.dart';
import '../models/budget.dart';

class BudgetService {
  static double spentForCategory(Budget budget, List<Expense> expenses) {
    return expenses
        .where((e) => e.category == budget.category)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  static double progress(Budget budget, List<Expense> expenses) {
    if (budget.limit == 0) return 0;

    return spentForCategory(budget, expenses) / budget.limit;
  }
}

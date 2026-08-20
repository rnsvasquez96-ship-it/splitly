import '../../expenses/models/expense_category.dart';

class Budget {
  final String id;
  final ExpenseCategory category;
  final double limit;

  Budget({required this.id, required this.category, required this.limit});

  Map<String, dynamic> toJson() {
    return {'id': id, 'category': category.name, 'limit': limit};
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      category: ExpenseCategory.values.firstWhere(
        (e) => e.name == json['category'],
      ),
      limit: (json['limit'] as num).toDouble(),
    );
  }
}

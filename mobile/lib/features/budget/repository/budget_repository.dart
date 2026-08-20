import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/budget.dart';

class BudgetRepository {
  BudgetRepository._();

  static final instance = BudgetRepository._();

  static const _key = "budgets";

  final List<Budget> _budgets = [];

  List<Budget> getBudgets() {
    return List.unmodifiable(_budgets);
  }

  Future<void> loadBudgets() async {
    final prefs = await SharedPreferences.getInstance();

    final saved = prefs.getStringList(_key);

    _budgets.clear();

    if (saved == null) return;

    for (final json in saved) {
      _budgets.add(
        Budget.fromJson(Map<String, dynamic>.from(jsonDecode(json))),
      );
    }
  }

  Future<void> saveBudgets() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      _key,
      _budgets.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  Future<void> addBudget(Budget budget) async {
    _budgets.add(budget);

    await saveBudgets();
  }

  Future<void> updateBudget(Budget budget) async {
    final index = _budgets.indexWhere((b) => b.id == budget.id);

    if (index == -1) return;

    _budgets[index] = budget;

    await saveBudgets();
  }

  Future<void> deleteBudget(String id) async {
    _budgets.removeWhere((b) => b.id == id);

    await saveBudgets();
  }
}

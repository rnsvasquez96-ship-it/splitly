import '../models/settlement.dart';

class SettlementRepository {
  SettlementRepository._();

  static final instance = SettlementRepository._();

  final List<Settlement> _history = [];

  List<Settlement> getHistory() => _history;

  void add(Settlement settlement) {
    _history.add(settlement);
  }
}
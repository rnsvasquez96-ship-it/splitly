import '../models/settlement.dart';

class SettlementHistoryService {
  SettlementHistoryService._();

  static final instance = SettlementHistoryService._();

  final List<Settlement> _history = [];

  List<Settlement> get history => _history;

  void settle(Settlement settlement) {
    _history.add(settlement);
  }

  bool isSettled(Settlement settlement) {
    return _history.any(
      (s) =>
          s.from == settlement.from &&
          s.to == settlement.to &&
          (s.amount - settlement.amount).abs() < 0.01,
    );
  }

  void clear() {
    _history.clear();
  }
}

class Settlement {
  final String id;
  final String from;
  final String to;
  final double amount;
  final DateTime settledAt;

  const Settlement({
    required this.id,
    required this.from,
    required this.to,
    required this.amount,
    required this.settledAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'from': from,
      'to': to,
      'amount': amount,
      'settledAt': settledAt.toIso8601String(),
    };
  }

  factory Settlement.fromMap(Map<String, dynamic> map) {
    return Settlement(
      id: map['id'],
      from: map['from'],
      to: map['to'],
      amount: (map['amount'] as num).toDouble(),
      settledAt: DateTime.parse(map['settledAt']),
    );
  }
}
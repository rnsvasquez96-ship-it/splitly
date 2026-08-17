import '../../expenses/models/expense.dart';
import 'member.dart';

class Group {
  final String id;
  String name;
  String description;
  List<Member> members;
  List<Expense> expenses;

  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.members,
    required this.expenses,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'members': members.map((m) => m.toMap()).toList(),
      'expenses': expenses.map((e) => e.toMap()).toList(),
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      members: (map['members'] as List<dynamic>? ?? [])
          .map(
            (member) => Member.fromMap(
          Map<String, dynamic>.from(member),
        ),
      )
          .toList(),
      expenses: (map['expenses'] as List<dynamic>? ?? [])
          .map(
            (expense) => Expense.fromMap(
          Map<String, dynamic>.from(expense),
        ),
      )
          .toList(),
    );
  }

  Group copyWith({
    String? id,
    String? name,
    String? description,
    List<Member>? members,
    List<Expense>? expenses,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      members: members ?? this.members,
      expenses: expenses ?? this.expenses,
    );
  }
}
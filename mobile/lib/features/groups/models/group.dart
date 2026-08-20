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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'members': members.map((m) => m.toJson()).toList(),
      'expenses': expenses.map((e) => e.toJson()).toList(),
    };
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      members: (json['members'] as List<dynamic>? ?? [])
          .map((member) => Member.fromJson(Map<String, dynamic>.from(member)))
          .toList(),
      expenses: (json['expenses'] as List<dynamic>? ?? [])
          .map(
            (expense) => Expense.fromJson(Map<String, dynamic>.from(expense)),
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

  // Compatibility with existing code
  Map<String, dynamic> toMap() => toJson();

  factory Group.fromMap(Map<String, dynamic> map) => Group.fromJson(map);
}

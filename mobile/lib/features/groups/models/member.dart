class Member {
  final String id;
  final String name;

  Member({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(id: map['id'] as String, name: map['name'] as String);
  }

  // Firestore compatibility
  Map<String, dynamic> toJson() => toMap();

  factory Member.fromJson(Map<String, dynamic> json) => Member.fromMap(json);
}

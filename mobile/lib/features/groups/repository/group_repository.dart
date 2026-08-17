import '../models/group.dart';

class GroupRepository {
  GroupRepository._();

  static final GroupRepository instance =
  GroupRepository._();

  final List<Group> _groups = [];

  List<Group> getGroups() {
    return List.unmodifiable(_groups);
  }

  void addGroup(Group group) {
    _groups.add(group);
  }

  void removeGroup(Group group) {
    _groups.remove(group);
  }

  void updateGroup(Group group) {
    final index = _groups.indexWhere(
          (g) => g.id == group.id,
    );

    if (index != -1) {
      _groups[index] = group;
    }
  }

  void clear() {
    _groups.clear();
  }
}
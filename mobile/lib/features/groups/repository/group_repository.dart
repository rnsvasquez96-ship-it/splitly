import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/group.dart';
import '../services/group_remote_service.dart';

class GroupRepository {
  GroupRepository._();

  static final GroupRepository instance = GroupRepository._();

  static const _groupsKey = "groups";

  final List<Group> _groups = [];

  final _remote = GroupRemoteService.instance;

  List<Group> getGroups() {
    return List.unmodifiable(_groups);
  }

  Future<void> loadGroups() async {
    final prefs = await SharedPreferences.getInstance();

    final saved = prefs.getStringList(_groupsKey);

    _groups.clear();

    if (saved != null) {
      for (final json in saved) {
        final map = jsonDecode(json);

        _groups.add(Group.fromMap(Map<String, dynamic>.from(map)));
      }
    }

    try {
      final cloudGroups = await _remote.watchGroups().first;

      _groups
        ..clear()
        ..addAll(cloudGroups);

      await saveGroups();
    } catch (_) {
      // Offline: keep local data.
    }
  }

  Future<void> saveGroups() async {
    final prefs = await SharedPreferences.getInstance();

    final data = _groups.map((group) => jsonEncode(group.toMap())).toList();

    await prefs.setStringList(_groupsKey, data);
  }

  Future<void> addGroup(Group group) async {
    _groups.add(group);

    await saveGroups();

    await _remote.createGroup(group);
  }

  Future<void> removeGroup(Group group) async {
    _groups.removeWhere((g) => g.id == group.id);

    await saveGroups();

    await _remote.deleteGroup(group.id);
  }

  Future<void> updateGroup(Group group) async {
    final index = _groups.indexWhere((g) => g.id == group.id);

    if (index == -1) return;

    _groups[index] = group;

    await saveGroups();

    await _remote.updateGroup(group);
  }

  Stream<List<Group>> watchGroups() {
    return _remote.watchGroups();
  }

  Future<void> clear() async {
    _groups.clear();
    await saveGroups();
  }
}

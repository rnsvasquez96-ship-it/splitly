import 'package:cloud_firestore/cloud_firestore.dart';

import '../../groups/models/group.dart';
import '../services/firestore_service.dart';

class FirestoreGroupRepository {
  FirestoreGroupRepository._();

  static final instance =
  FirestoreGroupRepository._();

  final _service = FirestoreService.instance;

  Future<void> saveGroup(
      Group group,
      ) async {
    await _service.groups.doc(group.id).set(
      group.toJson(),
    );
  }

  Future<void> deleteGroup(
      String id,
      ) async {
    await _service.groups.doc(id).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>
  groups() {
    return _service.groups.snapshots();
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/group.dart';

class GroupRemoteService {
  GroupRemoteService._();

  static final instance = GroupRemoteService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _groups => _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('groups');

  Future<void> createGroup(Group group) async {
    await _groups.doc(group.id).set(group.toJson());
  }

  Future<void> updateGroup(Group group) async {
    await _groups.doc(group.id).update(group.toJson());
  }

  Future<void> deleteGroup(String groupId) async {
    await _groups.doc(groupId).delete();
  }

  Stream<List<Group>> watchGroups() {
    return _groups.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => Group.fromJson(doc.data())).toList(),
    );
  }
}

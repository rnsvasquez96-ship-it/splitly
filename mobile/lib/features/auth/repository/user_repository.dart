import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';

class UserRepository {
  UserRepository._();

  static final instance = UserRepository._();

  final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  Future<void> saveUser(
      AppUser user,
      ) async {
    await _db
        .collection("users")
        .doc(user.uid)
        .set(user.toJson());
  }

  Future<AppUser?> getUser(
      String uid,
      ) async {
    final doc =
    await _db.collection("users").doc(uid).get();

    if (!doc.exists) {
      return null;
    }

    return AppUser.fromJson(doc.data()!);
  }
}
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';

class UserDatasource {
  final _firestore = FirebaseFirestore.instance;

  createUser(Users user) async {
    try {
      await _firestore.collection("users").doc(user.userId).set(user.toMap());
      log("success create user db");
    } catch (e) {
      log("error create user db: $e");
    }
  }

  Future<Users?> getUser(String userId) async {
  try {
    final doc = await _firestore.collection("users").doc(userId.toString()).get();
    if (doc.exists) {
      return Users.fromMap(doc.data()!);
    }
    return null;
  } catch (e) {
    throw Exception("Failed to get user: $e");
  }
}

  updateUser() async {
    try {
      _firestore.collection("users").doc("0giYUZmTIDzVykoBILuW").update(
          {"userName": "mnghia edit", "email": "edit 1", "password": "123456"});
      log("success update user db");
    } catch (e) {
      log("error update user db: $e");
    }
  }

  deleteUser() async {
    try {
      _firestore.collection("users").doc("0giYUZmTIDzVykoBILuW").delete();
      log("success delete user db");
    } catch (e) {
      log("error delete user db: $e");
    }
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';

class UserDatasource {
  final firestore = FirebaseFirestore.instance;
  static const String userCollection = "users";  

  Future<void> createUser(Users user) async {
    try {
      await firestore.collection(userCollection).doc(user.userId).set(user.toMap());
      log("success create user db");
    } catch (e) {
      log("error create user db: $e");
    }
  }

  Future<Users?> getUser(String userId) async {
    try {
      final doc =
          await firestore.collection(userCollection).doc(userId).get();
      if (doc.exists) {
        return Users.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception("Lỗi khi tải người dùng: $e");
    }
  }

  Future<void> updateUser(Users user) async {
    try {
      await firestore
          .collection(userCollection)
          .doc(user.userId)
          .update(user.toMap());
    } catch (e) {
      log('error update user: $e');
    }
  }
}

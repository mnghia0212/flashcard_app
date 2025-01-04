import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';

class CommentDatasource {
  final firestore = FirebaseFirestore.instance;

  Future<void> Comment(Comments comment) {
    try {} catch (e) {
      log("error send cmt: $e");
    }
  }

  Future<void> deleteComment(String commentId) {
    try {} catch (e) {
      log("error delete cmt: $e");
    }
  }
}

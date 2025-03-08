import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';

class CommentDatasource {
  final firestore = FirebaseFirestore.instance;

  Future<void> sendComment(Comments comment) async {
    try {
      await firestore.collection("comments").doc().set(comment.toMap());
      log("success send cmt");
    } catch (e) {
      log("error send cmt: $e");
    }
  }

   Future<void> deleteComment(String commentId) async {
    try {
      await firestore.collection('comments').doc(commentId).delete();
      log("success delete cmt");
    } catch (e) {
      log("error delete cmt: $e");
    }
  }

  Future<void> updateComment(Comments comment) async {
    try {
      await firestore
          .collection('comments')
          .doc(comment.commentId)
          .update(comment.toMap());
      log("error update cmt");
    } catch (e) {
      log('error update cmt: $e');
    }
  }
}

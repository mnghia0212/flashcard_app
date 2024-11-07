import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';

class FlashcardSetsSharedDatasource {
  final firestore = FirebaseFirestore.instance;

  Future<void> shareSet(FlashcardSetsShared flashcardSetsShared) async {
    try {
      final newSharedSetDoc = firestore.collection("flashcardSetsShared").doc();

      await newSharedSetDoc.set(flashcardSetsShared.copyWith().toMap());

      log("success share set");
    } catch (e) {
      log("error share set: $e");
    }
  }

  Future<void> deleteSharedSet(String flashcardSetsSharedId) async {
    try {
      await firestore
          .collection('flashcardSetsShared')
          .doc(flashcardSetsSharedId.toString())
          .delete();
      log("Success deleting shared set");
    } catch (e) {
      log("Error deleting shared set: $e");
    }
  }
}

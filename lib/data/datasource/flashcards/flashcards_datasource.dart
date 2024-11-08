import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FlashcardsDatasource {
  final firestore = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;

  Future<void> createCardInSet({
    required Flashcards flashcard,
    required String setId,
  }) async {
    try {
      final newFlashcardDoc =
          FirebaseFirestore.instance.collection('flashcards').doc();
      final newFlashcardId = newFlashcardDoc.id;

      await newFlashcardDoc
          .set(flashcard.copyWith(flashcardId: newFlashcardId).toMap());

      final newFlashcardSetDetail =
          FirebaseFirestore.instance.collection('flashcardSetDetails').doc();
      await newFlashcardSetDetail.set({
        'flashcardSetId': setId,
        'flashcardId': newFlashcardId,
      });

      log("Flashcard created and linked to set successfully");
    } catch (e) {
      log("Error creating flashcard in set: $e");
    }
  }

  Future<void> updateCard(Flashcards flashcard) async {
    try {
      await firestore
          .collection('flashcards')
          .doc(flashcard.flashcardId)
          .update(flashcard.toMap());
      log("Flashcard updated successfully");
    } catch (e) {
      throw Exception("Error updating flashcard: $e");
    }
  }

  Future<void> deleteCard(String flashcardId) async {
    try {
      await firestore.collection('flashcards').doc(flashcardId).delete();

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance  
        .collection("flashcardSetDetails")  
        .where('flashcardId', isEqualTo: flashcardId)  
        .get();  

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {  
        await firestore.collection('flashcardSetDetails').doc(doc.id).delete();  
      }  

      log("Success deleting flashcard set");
    } catch (e) {
      log("Error deleting flashcard set: $e");
    }
  }
}

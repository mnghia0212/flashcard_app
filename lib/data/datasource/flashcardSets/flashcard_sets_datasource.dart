import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FlashcardSetsDatasource {
  final _firestore = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;

  Future<void> createSet(
      FlashcardSets flashcardSets, BuildContext context) async {
    try {
      await SessionService().checkSession(context);

      final newSetDoc =
          _firestore.collection("flashcardSets").doc();
      final newSetId = newSetDoc.id;

      await newSetDoc.set(flashcardSets.copyWith(setId: newSetId).toMap());

      log("Success: flashcard set created in db");
    } catch (e) {
      log("Error creating set in db: $e");
    }
  }

  Future<String> getSetNameById(String? setId) async {
    try {
      final flashcardSets = await _firestore
          .collection('flashcardSets')
          .where('setId', isEqualTo: setId)
          .get();

      if (flashcardSets.docs.isNotEmpty) {
        return flashcardSets.docs.first['title'] as String;
      } else {
        return "Set name not found";
      }
    } catch (e) {
      log("$e");
      return "Error loading set name";
    }
  }

  Future<void> updateSet(
      FlashcardSets flashcardSets, BuildContext context) async {
    try {
      await SessionService().checkSession(context);
      await _firestore
          .collection('flashcardSets')
          .doc(flashcardSets.setId.toString())
          .update(flashcardSets.toMap());

      log("Success updating flashcard set");
    } catch (e) {
      log("Error updating flashcard set: $e");
    }
  }

  Future<void> deleteSet(String setId, BuildContext context) async {
    try {
      await SessionService().checkSession(context);
      await _firestore
          .collection('flashcardSets')
          .doc(setId)
          .delete();
      log("Success deleting flashcard set");
    } catch (e) {
      log("Error deleting flashcard set: $e");
    }
  }

  Stream<int?> getCardNumber(String setId) {
    try {
      return _firestore
          .collection('flashcards')
          .where('setId', isEqualTo: setId)
          .snapshots()
          .map((snapshot) => snapshot.docs.length);
    } catch (e) {
      log("Error getting flashcard number: $e");
      return Stream.value(0);
    }
  }

}

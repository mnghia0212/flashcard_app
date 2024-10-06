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
      final now = DateTime.now().toString();
      await SessionService().checkSession(context);

      await _firestore
          .collection("flashcardSets")
          .doc(now)
          .set(flashcardSets.toMap());

      log("success create set db");
    } catch (e) {
      log("error create set db: $e");
    }
  }

  Future<void> updateSet(
      FlashcardSets flashcardSets, BuildContext context) async {
    try {
      await SessionService().checkSession(context);
      await _firestore
          .collection('flashcardSets')
          .doc(flashcardSets.setId.toString())
          .update({
        'title': flashcardSets.title,
        'description': flashcardSets.description,
        'isFavorite': flashcardSets.isFavorite,
        'updatedAt': flashcardSets.updatedAt ?? DateTime.now().toString(),
      });

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
          .doc(setId.toString())
          .delete();
      log("Success deleting flashcard set");
    } catch (e) {
      log("Error deleting flashcard set: $e");
    }
  }

  Future<List<FlashcardSets>> getAllSets() async {
  try {
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      log("No user logged in");
      return [];
    }

    log("Fetching flashcard sets for userId: $userId");

    final querySnapshot = await _firestore
        .collection('flashcardSets')
        .where('userId', isEqualTo: userId)
        .get();

    final sets = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return FlashcardSets(
        setId: data['setId'],
        userId: data['userId'],
        title: data['title'],
        description: data['description'],
        isFavorite: data['isFavorite'],
        createdAt: data['createdAt'],
        updatedAt: data['updatedAt'],
      );
    }).toList();

    log("Fetched ${sets.length} sets for userId: $userId");

    return sets;
  } catch (e) {
    log("Error getting flashcard sets: $e");
    return [];
  }
}

  Stream<List<FlashcardSets>> listenToFlashcardSets() {
    final userId = supabase.auth.currentUser?.id;
    
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('flashcardSets')
        .where('userId', isEqualTo: userId)
        .snapshots() 
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return FlashcardSets(
              setId: data['setId'],
              userId: data['userId'],
              title: data['title'],
              description: data['description'],
              isFavorite: data['isFavorite'],
              createdAt: data['createdAt'],
              updatedAt: data['updatedAt'],
            );
          }).toList();
        });
  }
}

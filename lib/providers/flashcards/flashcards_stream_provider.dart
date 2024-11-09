import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final flashcardStreamProvider =
    StreamProvider.family<List<Flashcards>, String>((ref, setId) {
  return FirebaseFirestore.instance
      .collection('flashcards')
      .orderBy('createdAt', descending: true)
      .where('setId', isEqualTo: setId)
      .snapshots()
      .asyncMap((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();

      return Flashcards.fromMap(data);
    }).toList();
  });
});

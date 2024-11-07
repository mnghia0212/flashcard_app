import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final flashcardSetsSharedStreamProvider =
    StreamProvider.family<List<FlashcardSetsShared>, String>((ref, groupId) {
  return FirebaseFirestore.instance
      .collection('flashcardSetsShared')
      .where('groupId', isEqualTo: groupId)
      .snapshots()
      .asyncMap((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();

      return FlashcardSetsShared.fromMap(data);
    }).toList();
  });
});

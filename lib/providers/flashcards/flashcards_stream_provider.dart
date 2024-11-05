import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final flashcardStreamProvider =
    StreamProvider.family<List<Flashcards>, String>((ref, setId) {
  return FirebaseFirestore.instance
      .collection('flashcardSetDetails')
      .where('flashcardSetId', isEqualTo: setId)
      .snapshots()
      .asyncMap((snapshot) async {

    final flashcardIds =
        snapshot.docs.map((doc) => doc['flashcardId'] as String).toList();

    final querySnapshot = await FirebaseFirestore.instance
        .collection('flashcards')
        .orderBy('createdAt', descending: true)
        .get();

    final flashcards = querySnapshot.docs
        .where((doc) => flashcardIds.contains(doc.id))
        .map((doc) => Flashcards.fromMap(doc.data()))
        .toList();

    // for (var flashcard in flashcards) {
    //   log('Flashcard: ${flashcard.flashcardId} => ${flashcard.toMap()}');
    // }

    return flashcards;
  });
});

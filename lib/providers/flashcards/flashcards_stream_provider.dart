
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final flashcardStreamProvider = StreamProvider.family<List<Flashcards>, String>((ref, setId) {
  return FirebaseFirestore.instance
      .collection('flashcardSetDetails')
      .where('flashcardSetId', isEqualTo: setId)
      .snapshots()
      .asyncMap((snapshot) async {
        final flashcardIds = snapshot.docs.map((doc) => doc['flashcardId'] as String).toList();

        final flashcards = await Future.wait(flashcardIds.map((id) async {
          final flashcardSnapshot = await FirebaseFirestore.instance.collection('flashcards').doc(id).get();
          
          return Flashcards.fromMap(flashcardSnapshot.data()!);
        }));

        return flashcards;
      });
});


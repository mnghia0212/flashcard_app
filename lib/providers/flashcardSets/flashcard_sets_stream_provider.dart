import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final flashcardSetsStreamProvider = StreamProvider<List<FlashcardSets>>((ref) {
  final userId = ref.watch(userIdProvider);


  if (userId == null) {
    return Stream.value([]);
  }

  return FirebaseFirestore.instance
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
});


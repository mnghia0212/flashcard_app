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
      final newFlashcard =
          FirebaseFirestore.instance.collection('flashcards').doc();
      await newFlashcard.set(flashcard.toMap());
      final newFlashcardId = newFlashcard.id;

      final newFlashcardSetDetailRef =
          FirebaseFirestore.instance.collection('flashcardSetDetails').doc();
      await newFlashcardSetDetailRef.set({
        'flashcardSetId': setId,
        'flashcardId': newFlashcardId,
      });

      print("Flashcard created and linked to set successfully");
    } catch (e) {
      print("Error creating flashcard in set: $e");
    }
  }

  Future<List<Flashcards>> getCardsForSet(String setId) async {
  try {
    // Bước 1: Lấy tất cả flashcardId từ bảng FlashcardSetDetails cho setId cụ thể
    final flashcardSetDetailsSnapshot = await FirebaseFirestore.instance
        .collection('flashcardSetDetails')
        .where('flashcardSetId', isEqualTo: setId)
        .get();

    // Lấy danh sách flashcardId
    final flashcardIds = flashcardSetDetailsSnapshot.docs
        .map((doc) => doc['flashcardId'] as String)
        .toList();

    // Bước 2: Lấy dữ liệu flashcards từ flashcardIds
    final flashcards = await Future.wait(flashcardIds.map((id) async {
      final flashcardSnapshot = await FirebaseFirestore.instance.collection('flashcards').doc(id).get();
      return Flashcards.fromMap(flashcardSnapshot.data()!);
    }));

    return flashcards;
  } catch (e) {
    print("Error getting flashcards for set: $e");
    return [];
  }
}

  Stream<List<Flashcards>> getFlashcardsForSetStream(String setId) {
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
}

}

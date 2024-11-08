import 'package:flashcard_app/data/data.dart';

abstract class FlashcardRepositories {
  Future<void> createCardInSet(
      Flashcards flashcard, String setId);
  Future<void> updateCard(Flashcards flashcard);
  Future<void> deleteCard(String flashcardId);
}

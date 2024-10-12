import 'package:flashcard_app/data/data.dart';
import 'package:flutter/material.dart';

abstract class FlashcardRepositories {
  Future<void> createCardInSet(
      Flashcards flashcard, BuildContext context, String setId);
  Future<void> updateCard(Flashcards flashcard);
  Future<List<Flashcards>> getCardsForSet(String setId);
  Stream<List<Flashcards>> getFlashcardsForSetStream(String setId);
}

import 'dart:developer';

import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlashcardsNotifier extends StateNotifier<FlashcardsState> {
  final FlashcardRepositories repository;

  FlashcardsNotifier(this.repository) : super(const FlashcardsState.initial());

  Future<void> createCardInSet(
      Flashcards flashcard, String setId) async {
    try {
      await repository.createCardInSet(flashcard, setId);
    } catch (e) {
      log("error: $e");
    }
  }

  Future<void> updateCard(
      Flashcards flashcard, String setId) async {
    try {
      await repository.updateCard(flashcard);
    } catch (e) {
      log("error: $e");
    }
  }

}

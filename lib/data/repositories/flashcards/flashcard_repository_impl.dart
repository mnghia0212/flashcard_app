import 'dart:developer';

import 'package:flashcard_app/data/data.dart';
import 'package:flutter/src/widgets/framework.dart';

class FlashcardRepositoryImpl implements FlashcardRepositories {
  final FlashcardsDatasource datasource;
  FlashcardRepositoryImpl(this.datasource);

  @override
  Future<void> createCardInSet(
      Flashcards flashcard, BuildContext context, String setId) async {
    try {
      await datasource.createCardInSet(flashcard: flashcard, setId: setId);
    } catch (e) {
      log("$e");
    }
  }

  @override
  Future<List<Flashcards>> getCardsForSet(String setId) async {
    try {
      return await datasource.getCardsForSet(setId);
    } catch (e) {
      log("$e");
      return [];
    }
  }

  @override
  Stream<List<Flashcards>> getFlashcardsForSetStream(String setId) {
    try {
      return datasource.getFlashcardsForSetStream(setId);
    } catch (e) {
      log("$e");
      return Stream.value([]);
    }
  }
}

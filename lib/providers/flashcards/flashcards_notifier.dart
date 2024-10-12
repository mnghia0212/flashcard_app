import 'dart:developer';

import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlashcardsNotifier extends StateNotifier<FlashcardsState> {
  final FlashcardRepositories repository;

  FlashcardsNotifier(this.repository) : super(const FlashcardsState.initial());

  Future<void> createCardInSet(
      Flashcards flashcard, BuildContext context, String setId) async {
    getCardsForSet(setId);
    try {
      await repository.createCardInSet(flashcard, context, setId);
    } catch (e) {
      log("error: $e");
    }
  }

  Future<void> updateCard(
      Flashcards flashcard) async {
    try {
      await repository.updateCard(flashcard);
    } catch (e) {
      log("error: $e");
    }
  }

  void getCardsForSet(String setId) async {
    try {
      final flashcards = await repository.getCardsForSet(setId);
      state = state.copyWith(flashcards: flashcards);
    } catch (e) {
      log("$e");
    }
  }
}

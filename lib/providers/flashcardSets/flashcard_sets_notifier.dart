import 'dart:developer';

import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlashcardSetsNotifier extends StateNotifier<FlashcardSetsState> {
  final FlashcardSetsRepositories repository;

  FlashcardSetsNotifier(this.repository)
      : super(const FlashcardSetsState.initial());

  Future<void> createFlashcardSet(
      FlashcardSets flashcardSet, BuildContext context) async {
    try {
      await repository.createSet(flashcardSet, context);
    } catch (e) {
      log("error: $e");
    }
  }

  Future<void> updateSet(
      FlashcardSets flashcardSets, BuildContext context) async {
    try {
      await repository.updateSet(flashcardSets, context);
    } catch (e) {
      log("error: $e");
    }
  }

  Future<void> deleteSet(String setId, BuildContext context) async {
    try {
      await repository.deleteSet(setId, context);
    } catch (e) {
      log("error: $e");
    }
  }

  Future<String> getSetNameById(String setId) async {
    try {
      return await repository.getSetNameById(setId);
    } catch (e) {
      log("error: $e");
      return Future.value("Error loading set name");
    }
  }

  Stream<int?> getCardNumber(String setId) {
    try {
      return repository.getCardNumber(setId);
    } catch (e) {
      log("error: $e");
      return Stream.value(0);
    }
  }

  void selectFlashcardSet(FlashcardSets? flashcardSet) {
    if (flashcardSet != null) {
      state = state.copyWith(selectedFlashcardSet: flashcardSet);
    } else {
      state = state.copyWith(selectedFlashcardSet: null);
    }
  }
}

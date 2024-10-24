import 'dart:developer';

import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlashcardSetsNotifier extends StateNotifier<FlashcardSetsState> {
  final FlashcardSetsRepositories repository;

  FlashcardSetsNotifier(this.repository)
      : super(const FlashcardSetsState.initial()) {
    getSets();
  }

  Future<void> createFlashcardSet(
      FlashcardSets flashcardSet, BuildContext context) async {
    getSets();
    try {
      await repository.createSet(flashcardSet, context);
    } catch (e) {
      log("error: $e");
    }
  }

  void getSets() async{
    try {
      final flashcardSets = await repository.getAllSets();
      state = state.copyWith(flashcardSets: flashcardSets);
    } catch (e) {
      log("$e");
    }
  }
}

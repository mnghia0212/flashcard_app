import 'package:flashcard_app/data/data.dart';
import 'package:flutter/material.dart';

abstract class FlashcardSetsRepositories {
  Future<void> createSet(FlashcardSets flashcardSet, BuildContext context);
  Future<List<FlashcardSets>> getAllSets();
  Stream<List<FlashcardSets>> listenToFlashcardSets();
}

import 'package:flashcard_app/data/data.dart';
import 'package:flutter/material.dart';

abstract class FlashcardSetsRepositories {
  Future<void> createSet(FlashcardSets flashcardSet, BuildContext context);
  Future<void> updateSet(FlashcardSets flashcardSets, BuildContext context);
  Future<void> deleteSet(String setId, BuildContext context);
  Stream<int?> getCardNumber(String setId);
  Future<String> getSetNameById(String? setId);
}

import 'dart:developer';

import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlashcardSetsSharedNotifier
    extends StateNotifier<FlashcardSetsSharedState> {
  final FlashcardSetsSharedRepositories repository;

  FlashcardSetsSharedNotifier(this.repository)
      : super(const FlashcardSetsSharedState.initial());

  Future<void> shareSet(FlashcardSetsShared flashcardSetsShared) async {
    try {
      await repository.shareSet(flashcardSetsShared);
    } catch (e) {
      log("$e");
    }
  }

  Future<void> deleteSharedSet(String flashcardSetsSharedId) async {
    try {
      await repository.deleteSharedSet(flashcardSetsSharedId);
    } catch (e) {
      log("$e");
    }
  }
}

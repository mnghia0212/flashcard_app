import 'dart:developer';

import 'package:flashcard_app/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlashcardSetsRepositoryImpl implements FlashcardSetsRepositories {
  final FlashcardSetsDatasource datasource;
  FlashcardSetsRepositoryImpl(this.datasource);

  @override
  Future<void> createSet(
      FlashcardSets flashcardSet, BuildContext context) async {
    try {
      await datasource.createSet(flashcardSet, context);
    } catch (e) {
      log("$e");
    }
  }

  @override
  Future<List<FlashcardSets>> getAllSets() async {
    try {
      return await datasource.getAllSets();
    } catch (e) {
      log("$e");
      return [];
    }
  }

  @override
  Stream<List<FlashcardSets>> listenToFlashcardSets() {
    try {
      return datasource.listenToFlashcardSets();
    } catch (e) {
      log("$e");
      return Stream.value([]);
    }
  }

  @override
  Stream<int?> getCardNumber(String setId) {
    try {
      return datasource.getCardNumber(setId);
    } catch (e) {
      throw '$e';
    }
  }
}

import 'dart:developer';

import 'package:flashcard_app/data/data.dart';
import 'package:flutter/material.dart';

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
  Stream<int?> getCardNumber(String setId) {
    try {
      return datasource.getCardNumber(setId);
    } catch (e) {
      log("$e");
      return Stream.value(0);
    }
  }

  @override
  Future<String> getSetNameById(String? setId) {
    try {
      return datasource.getSetNameById(setId);
    } catch (e) {
      log("$e");
      return Future.value("Error loading set name");
    }
  }

  @override
  Future<void> deleteSet(String setId, BuildContext context) async {
    try {
      await datasource.deleteSet(setId, context);
    } catch (e) {
      log("$e");
    }
  }

  @override
  Future<void> updateSet(FlashcardSets flashcardSets, BuildContext context) async {
    try {
      await datasource.updateSet(flashcardSets, context);
    } catch (e) {
      log("$e");
    }
  }
}

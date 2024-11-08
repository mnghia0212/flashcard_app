import 'dart:developer';

import 'package:flashcard_app/data/data.dart';

class FlashcardRepositoryImpl implements FlashcardRepositories {
  final FlashcardsDatasource datasource;
  FlashcardRepositoryImpl(this.datasource);

  @override
  Future<void> createCardInSet(
      Flashcards flashcard, String setId) async {
    try {
      await datasource.createCardInSet(flashcard: flashcard, setId: setId);
    } catch (e) {
      log("$e");
    }
  }

  @override
  Future<void> updateCard(Flashcards flashcard) async {
    try {
      await datasource.updateCard(flashcard);
    } catch (e) {
      log("$e");
    }
  }
  
  @override
  Future<void> deleteCard(String flashcardId) async{
    try {
      await datasource.deleteCard(flashcardId);
    } catch (e) {
      log("$e");
    }
  }
}

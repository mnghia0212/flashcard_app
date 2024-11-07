import 'package:flashcard_app/data/data.dart';

abstract class FlashcardSetsSharedRepositories {
  Future<void> shareSet(FlashcardSetsShared flashcardSetsShared);
  Future<void> deleteSharedSet(String flashcardSetsSharedId);
}
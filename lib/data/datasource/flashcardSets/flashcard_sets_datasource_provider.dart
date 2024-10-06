import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flashcard_app/data/data.dart';

final flashcardSetDatasourceProvider = Provider<FlashcardSetsDatasource>((ref) {
  return FlashcardSetsDatasource();
});
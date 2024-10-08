import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flashcard_app/data/data.dart';

final flashcardDatasourceProvider = Provider<FlashcardsDatasource>((ref) {
  return FlashcardsDatasource();
});
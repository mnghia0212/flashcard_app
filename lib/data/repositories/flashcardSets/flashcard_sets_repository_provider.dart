import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flashcard_app/data/data.dart';

final flashcardSetsRepositoryProvider = Provider<FlashcardSetsRepositories>((ref) {
  final datasource = ref.watch(flashcardSetDatasourceProvider);
  return FlashcardSetsRepositoryImpl(datasource);
});
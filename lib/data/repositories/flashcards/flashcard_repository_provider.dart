import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flashcard_app/data/data.dart';

final flashcardRepositoryProvider = Provider<FlashcardRepositories>((ref) {
  final datasource = ref.watch(flashcardDatasourceProvider);
  return FlashcardRepositoryImpl(datasource);
});
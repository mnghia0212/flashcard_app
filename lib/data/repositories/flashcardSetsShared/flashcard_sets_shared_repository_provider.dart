import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flashcard_app/data/data.dart';

final flashcardSetsSharedRepositoryProvider = Provider<FlashcardSetsSharedRepositories>((ref) {
  final datasource = ref.watch(flashcardSetsSharedDatasourceProvider);
  return FlashcardSetsSharedRepositoryImpl(datasource);
});
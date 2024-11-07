import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final flashcardSetsSharedProvider = StateNotifierProvider<FlashcardSetsSharedNotifier, FlashcardSetsSharedState>((ref) {
  final repository = ref.watch(flashcardSetsSharedRepositoryProvider);
  return FlashcardSetsSharedNotifier(repository);
});
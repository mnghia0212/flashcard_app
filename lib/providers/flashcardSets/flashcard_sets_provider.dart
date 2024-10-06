import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final flashcardSetsProvider =
    StateNotifierProvider<FlashcardSetsNotifier, FlashcardSetsState>((ref) {
  final repository = ref.watch(flashcardSetsRepositoryProvider);
  return FlashcardSetsNotifier(repository);
});

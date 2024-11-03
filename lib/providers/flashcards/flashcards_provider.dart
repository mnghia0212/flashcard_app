import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final flashcardsProvider = StateNotifierProvider<FlashcardsNotifier, FlashcardsState>((ref) {
  final repository = ref.watch(flashcardRepositoryProvider);
  return FlashcardsNotifier(repository);
});
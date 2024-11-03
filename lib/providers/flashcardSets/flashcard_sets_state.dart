import 'package:equatable/equatable.dart';
import 'package:flashcard_app/data/data.dart';

class FlashcardSetsState extends Equatable {
  final List<FlashcardSets> flashcardSets;
  final FlashcardSets? selectedFlashcardSet;

  const FlashcardSetsState({required this.flashcardSets, this.selectedFlashcardSet});

  const FlashcardSetsState.initial()
      : flashcardSets = const [],
        selectedFlashcardSet = null;

  FlashcardSetsState copyWith({
    List<FlashcardSets>? flashcardSets,
    FlashcardSets? selectedFlashcardSet,
  }) {
    return FlashcardSetsState(
      flashcardSets: flashcardSets ?? this.flashcardSets,
      selectedFlashcardSet: selectedFlashcardSet ?? this.selectedFlashcardSet,
    );
  }

  @override
  List<Object?> get props => [flashcardSets, selectedFlashcardSet];
}

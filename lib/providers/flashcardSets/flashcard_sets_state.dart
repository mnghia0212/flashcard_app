import 'package:equatable/equatable.dart';
import 'package:flashcard_app/data/data.dart';

class FlashcardSetsState extends Equatable {
  final List<FlashcardSets> flashcardSets;

  const FlashcardSetsState({required this.flashcardSets});

  const FlashcardSetsState.initial({this.flashcardSets = const []});

  FlashcardSetsState copyWith({List<FlashcardSets>? flashcardSets}) {
    return FlashcardSetsState(
        flashcardSets: flashcardSets ?? this.flashcardSets);
  }

  @override
  List<Object?> get props => [flashcardSets];
}

import 'package:equatable/equatable.dart';
import 'package:flashcard_app/data/data.dart';

class FlashcardsState extends Equatable {
  final List<Flashcards> flashcards;

  const FlashcardsState({required this.flashcards});

  const FlashcardsState.initial({this.flashcards = const []});

  FlashcardsState copyWith({List<Flashcards>? flashcards}) {
    return FlashcardsState(
        flashcards: flashcards ?? this.flashcards);
  }

  @override
  List<Object?> get props => [flashcards];
}
import 'package:equatable/equatable.dart';
import 'package:flashcard_app/data/data.dart';

class FlashcardSetsSharedState extends Equatable {
  final List<FlashcardSetsShared> sharedSets;

  const FlashcardSetsSharedState({required this.sharedSets});

  const FlashcardSetsSharedState.initial({this.sharedSets = const []});

  FlashcardSetsSharedState copyWith({List<FlashcardSetsShared>? sharedSets}) {
    return FlashcardSetsSharedState(
      sharedSets: sharedSets ?? this.sharedSets
    );
  }

  @override
  List<Object?> get props => [sharedSets];
}

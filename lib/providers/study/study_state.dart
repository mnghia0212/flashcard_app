import 'package:flashcard_app/data/data.dart';

class StudyState {
  final List<StudyCards> initialBox;
  final List<StudyCards> wrongBox;
  final List<StudyCards> firstRightBox;
  final List<StudyCards> secondRightBox;
  final StudyCards? displayedFlashcard;

  StudyState({
    this.initialBox = const [],
    this.wrongBox = const [],
    this.firstRightBox = const [],
    this.secondRightBox = const [],
    this.displayedFlashcard,
  });

  StudyState copyWith({
    List<StudyCards>? initialBox,
    List<StudyCards>? wrongBox,
    List<StudyCards>? firstRightBox,
    List<StudyCards>? secondRightBox,
    StudyCards? displayedFlashcard,
  }) {
    return StudyState(
      initialBox: initialBox ?? this.initialBox,
      wrongBox: wrongBox ?? this.wrongBox,
      firstRightBox: firstRightBox ?? this.firstRightBox,
      secondRightBox: secondRightBox ?? this.secondRightBox,
      displayedFlashcard: displayedFlashcard ?? this.displayedFlashcard,
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flashcard_app/data/data.dart';

class StudyState {
  final List<StudyCards> remainBox;
  final List<StudyCards> initialBox;
  final List<StudyCards> wrongBox;
  final List<StudyCards> firstRightBox;
  final List<StudyCards> secondRightBox;
  final StudyCards? displayedFlashcard;
  final List<String>? randomAnswer;
  StudyState({
     this.remainBox = const [],
     this.initialBox = const [],
     this.wrongBox = const [],
     this.firstRightBox = const [],
     this.secondRightBox = const [],
     this.displayedFlashcard,
     this.randomAnswer
  });

  

  StudyState copyWith({
    List<StudyCards>? remainBox,
    List<StudyCards>? initialBox,
    List<StudyCards>? wrongBox,
    List<StudyCards>? firstRightBox,
    List<StudyCards>? secondRightBox,
    StudyCards? displayedFlashcard,
    List<String>? randomAnswer
  }) {
    return StudyState(
      remainBox: remainBox ?? this.remainBox,
      initialBox: initialBox ?? this.initialBox,
      wrongBox: wrongBox ?? this.wrongBox,
      firstRightBox: firstRightBox ?? this.firstRightBox,
      secondRightBox: secondRightBox ?? this.secondRightBox,
      displayedFlashcard: displayedFlashcard ?? this.displayedFlashcard,
      randomAnswer: randomAnswer ?? this.randomAnswer
    );
  }
}

import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class StudyNotifier extends StateNotifier<StudyState> {
  final Ref ref;

  StudyNotifier(this.ref) : super(StudyState());

  Future<void> initializeFlashcards(dynamic set) async {
    state = StudyState();
    final setId =
        set is DefaultSets ? (set).setId : (set as FlashcardSets).setId;

    final flashcards = set is DefaultSets
        ? await ref.read(defaultCardsFutureProvider(setId).future)
        : await ref.read(flashcardStreamProvider(setId).future);

    if (flashcards.isNotEmpty) {
      state = state.copyWith(
          remainBox: List<StudyCards>.from(flashcards),
          initialBox: List<StudyCards>.from(flashcards),
          displayedFlashcard: flashcards[Random().nextInt(flashcards.length)],
          randomAnswer: null);
    }
  }

  void setDisplayedCardState(StudyCards flashcard) {
    state = state.copyWith(displayedFlashcard: flashcard);
  }

  void setRandomAnswers(List<String> answerList) {
    state = state.copyWith(randomAnswer: answerList);
  }

  StudyCards? setNextFlashcard(bool isCorrect, StudyCards flashcard) {
    _updateBoxes(isCorrect, flashcard);
    final StudyCards? nextFlashcard = _selectNextFlashcard(flashcard);
    if (nextFlashcard != null) {
      return nextFlashcard;
    } else {
      return null;
    }
  }

  void _updateBoxes(bool isCorrect, StudyCards flashcard) {
    state = state.copyWith(
      initialBox: List<StudyCards>.from(state.initialBox),
      wrongBox: List<StudyCards>.from(state.wrongBox),
      firstRightBox: List<StudyCards>.from(state.firstRightBox),
      secondRightBox: List<StudyCards>.from(state.secondRightBox),
    );
    if (isCorrect) {
      if (state.initialBox.remove(flashcard)) {
        state.firstRightBox.add(flashcard);
      } else if (state.wrongBox.remove(flashcard)) {
        state.firstRightBox.add(flashcard);
      } else if (state.firstRightBox.remove(flashcard)) {
        state.secondRightBox.add(flashcard);
      }
    } else {
      if (state.initialBox.remove(flashcard)) {
        state.wrongBox.add(flashcard);
      } else if (state.firstRightBox.remove(flashcard)) {
        state.wrongBox.add(flashcard);
      }
    }

    state = state.copyWith(
      initialBox: [...state.initialBox],
      wrongBox: [...state.wrongBox],
      firstRightBox: [...state.firstRightBox],
      secondRightBox: [...state.secondRightBox],
    );

    debugPrint(
        "-----------------------------------------------------------------------");
    debugPrint(
        "initialBox: ${state.initialBox.map((e) => e.backContent).join(' - ')}");
    debugPrint(
        "wrongBox: ${state.wrongBox.map((e) => e.backContent).join(' - ')}");
    debugPrint(
        "firstRightBox: ${state.firstRightBox.map((e) => e.backContent).join(' - ')}");
    debugPrint(
        "secondRightBox: ${state.secondRightBox.map((e) => e.backContent).join(' - ')}");
    debugPrint(
        "-----------------------------------------------------------------------");
  }

  StudyCards? _selectNextFlashcard(StudyCards flashcard) {
    if (state.initialBox.isNotEmpty) {
      return state.initialBox[Random().nextInt(state.initialBox.length)];
    }
    if (state.wrongBox.isNotEmpty) {
      return _getRandomFromBox(state.wrongBox, flashcard);
    }
    if (state.firstRightBox.isNotEmpty) {
      return _getRandomFromBox(state.firstRightBox, flashcard);
    }
    return null;
  }

  StudyCards? _getRandomFromBox(List<StudyCards> box, StudyCards currentCard) {
    if (box.length == 1 && box.first == currentCard) {
      return state.firstRightBox.isEmpty
          ? box.first
          : state.firstRightBox[Random().nextInt(state.firstRightBox.length)];
    }

    StudyCards newCard;
    do {
      newCard = box[Random().nextInt(box.length)];
    } while (newCard == currentCard);

    return newCard;
  }
}

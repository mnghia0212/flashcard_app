import 'package:flutter/material.dart';

@immutable
class RouteLocation {
  const RouteLocation._();

  static String get bottomNavigator => '/bottomNavigator';
  static String get splash => '/splash';
  static String get home => '/home';
  static String get logIn => '/logIn';
  static String get signUp => '/signUp';
  static String get firstLogIn => '/firstLogIn';
  static String get flashcardSet => '/flashcardSet';
  static String get flashcard => '/flashcard/:setId/:setName';
  static String get writeModeStudy => '/writeModeStudy/:setId/:setName';
  static String get flipModeStudy => '/flipModeStudy/:setId/:setName';
  static String get abcdModeStudy => '/abcdModeStudy/:setId/:setName';
  static String get speedRecallModeStudy => '/speedRecallModeStudy/:setId/:setName';
  static String get endStudySessionScreen => '/endStudySessionScreen/:rightAnswerCount/:wrongAnswerCount';
  static String get testMode => '/testMode';
  static String get studyGroupScreen => '/studyGroupScreen/:groupId';
  static String get defaultFlashcardsScreen => '/defaultFlashcardsScreen/:setId/:setName';
}

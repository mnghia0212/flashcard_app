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
  static String get flashcard => '/flashcard/:setId';
  static String get writeModeStudy => '/writeModeStudy/:setId';
  static String get flipModeStudy => '/flipModeStudy/:setId';
  static String get abcdModeStudy => '/abcdModeStudy/:setId';
  static String get speedRecallModeStudy => '/speedRecallModeStudy/:setId';
  
}

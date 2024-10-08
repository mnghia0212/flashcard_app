import 'package:flutter/material.dart';

@immutable
class RouteLocation {
  const RouteLocation._();

  static String get bottomNavigator => '/bottomNavigator';
  static String get home => '/home';
  static String get logIn => '/logIn';
  static String get signUp => '/signUp';
  static String get firstLogIn => '/firstLogIn';
  static String get flashcardSet => '/flashcardSet';
  static String get flashcard => '/flashcard/:setId';
  static String get splash => '/splash';
}

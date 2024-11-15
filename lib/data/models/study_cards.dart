import 'package:flashcard_app/data/data.dart';

abstract class StudyCards {
  String get frontContent;
  String get backContent;
  String get uniqueKey;

  factory StudyCards.fromMap(Map<String, dynamic> map, String type) {
    switch (type) {
      case 'flashcards':
        return Flashcards.fromMap(map);
      case 'defaultCards':
        return DefaultCards.fromMap(map);
      default:
        throw Exception(
            "Invalid type '$type' for StudyCards. Accepted types are 'flashcards' and 'defaultCards'.");
    }
  }
}

import 'package:flashcard_app/data/data.dart';

class SelectedSetWrapper {
  final dynamic set;
  final bool isDefault;
  
  SelectedSetWrapper({required this.set, required this.isDefault});

  String get setId =>
      isDefault ? (set as DefaultSets).setId : (set as FlashcardSets).setId;

  String get title =>
      isDefault ? (set as DefaultSets).title : (set as FlashcardSets).title;
}

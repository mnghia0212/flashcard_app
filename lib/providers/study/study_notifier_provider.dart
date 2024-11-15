import 'package:flashcard_app/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final studyNotifierProvider =
    StateNotifierProvider<StudyNotifier, StudyState>((ref) {
  return StudyNotifier(ref);
});

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final defaultCardsFutureProvider =
    FutureProvider.family<List<StudyCards>, String>((ref, setId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('defaultCards')
      .where('setId', isEqualTo: setId)
      .get();

  return snapshot.docs.map((doc) {
    final data = doc.data();
    return DefaultCards.fromMap(data);
  }).toList();
});

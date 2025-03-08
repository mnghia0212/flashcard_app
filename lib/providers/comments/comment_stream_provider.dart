import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commentStreamProvider =
    StreamProvider.family<List<Comments>, String>((ref, setId) {
  return FirebaseFirestore.instance
      .collection('comments')
      .orderBy('commentedAt', descending: true)
      .where('setId', isEqualTo: setId)
      .snapshots()
      .asyncMap((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();

      return Comments.fromMap(data);
    }).toList();
  });
});

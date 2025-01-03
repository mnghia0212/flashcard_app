import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final requestsStreamProvider = StreamProvider<List<Requests>>((ref) {

  return FirebaseFirestore.instance
      .collection('requests')
      .orderBy('requestedAt', descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Requests.fromMap(data);
    }).toList();
  });
});
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupMembersStreamProvider =
    StreamProvider.family<List<GroupMembers>, String>((ref, groupId) {
  return FirebaseFirestore.instance
      .collection('groupMembers')
      .where('groupId', isEqualTo: groupId)
      .orderBy('joinAt', descending: true)
      .snapshots()
      .asyncMap((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();

      return GroupMembers.fromMap(data);
    }).toList();
  });
});
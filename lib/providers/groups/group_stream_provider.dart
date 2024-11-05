import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupStreamProvider = StreamProvider<List<Groups>>((ref) {
  final userId = ref.watch(userIdProvider);

  if (userId == null) {
    return Stream.value([]);
  }

  return FirebaseFirestore.instance
      .collection('groupMembers')
      .where('userId', isEqualTo: userId)
      .snapshots()
      .asyncMap((snapshot) async {
    final groupIds =
        snapshot.docs.map((doc) => doc['groupId'] as String).toList();

    final querySnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .orderBy('createdAt', descending: true)
        .get();
    
    final groups = querySnapshot.docs
        .where((doc) => groupIds.contains(doc.id))
        .map((doc) => Groups.fromMap(doc.data()))
        .toList();

    return groups;
  });
});

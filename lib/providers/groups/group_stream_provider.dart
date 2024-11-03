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

    final groups = await Future.wait(groupIds.map((id) async {
      final groupSnapshot =
          await FirebaseFirestore.instance.collection('groups').doc(id).get();

      final groupData = groupSnapshot.data();
      if (groupData != null) {
        return Groups.fromMap(groupData);
      } else {
        throw Exception("Group data is null for id: $id");
      }
    }));

    return groups;
  });
});

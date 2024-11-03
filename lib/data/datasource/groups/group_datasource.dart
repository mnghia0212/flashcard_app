import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroupDatasource {
  final firestore = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;

  Future<void> createGroup(
      Groups groups, String createdBy, String creatorName) async {
    try {
      final newGroupDoc = FirebaseFirestore.instance.collection("groups").doc();
      final newMemberDoc =
          FirebaseFirestore.instance.collection("groupMembers").doc();
          
      final newGroupId = newGroupDoc.id;
      final newMemberId = newMemberDoc.id;

      await newGroupDoc.set(groups.copyWith(groupId: newGroupId).toMap());

      final creatorMember = GroupMembers(
          groupMemberId: newMemberId,
          groupId: newGroupId,
          userId: createdBy,
          groupMemberName: creatorName,
          joinedAt: Timestamp.now().toString(),
          isAdmin: true);

      await newMemberDoc.set(creatorMember.toMap());

      log("success create group: $newGroupId");
    } catch (e) {
      log("error create group: $e");
    }
  }
}

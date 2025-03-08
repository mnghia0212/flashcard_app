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
      final newGroupDoc = firestore.collection("groups").doc();
      final newMemberDoc =
          FirebaseFirestore.instance.collection("groupMembers").doc();

      final newGroupId = newGroupDoc.id;
      final newMemberId = newMemberDoc.id;

      await newGroupDoc.set(groups.copyWith(groupId: newGroupId).toMap());

      final creatorMember = GroupMembers(
          groupMemberId: newMemberId,
          groupId: newGroupId,
          userId: createdBy,
          joinedAt: DateTime.now().toString(),
          isAdmin: true);

      await newMemberDoc.set(creatorMember.toMap());

      log("success create group: $newGroupId");
    } catch (e) {
      log("error create group: $e");
    }
  }

  Future<void> joinGroup(GroupMembers newMember) async {
    try {
      final newMemberDoc = firestore.collection("groupMembers").doc();
      final newMemberId = newMemberDoc.id;

      await newMemberDoc.set(newMember.copyWith(groupMemberId: newMemberId).toMap());

      log("success join group");
    } catch (e) {
      log("error join group: $e");
    }
  }

  Future<String?> getGroup(String groupId) async {
    try {
       final doc =
          await firestore.collection("groups").doc(groupId).get();
      if (doc.exists) {
        return Groups.fromMap(doc.data()!).groupName;
      }
      return null;
    } catch (e) {
       throw Exception("Failed to get group: $e");
    }
  }

  Future<void> deleteMember(String memberId) async {
    try {
      await firestore.collection('groupMembers').doc(memberId).delete();
      log("success delete request");
    } catch (e) {
      log("error delete request: $e");
    }
  }
}

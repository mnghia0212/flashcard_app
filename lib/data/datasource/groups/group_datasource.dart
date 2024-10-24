import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroupDatasource {
  final firestore = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;

  Future<void> createGroup(Groups groups) async {
    try {
      final newGroupDoc = FirebaseFirestore.instance.collection("groups").doc();
      final newGroupId = newGroupDoc.id;

      await newGroupDoc.set(groups.copyWith(groupId: newGroupId).toMap());
      log("success create group: $newGroupId");
    } catch (e) {
      log("error create group: $e");
    }
  }

  Future<List<Groups>> getGroups(Groups groups) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        log("No user logged in");
        return [];
      }


      log("Fetching groups for userId: $userId");
    
      final querruSnapshot = firestore
        .collection('')

    } catch (e) {
      log("error get groups: $e");
      return [];
    }
  }
}

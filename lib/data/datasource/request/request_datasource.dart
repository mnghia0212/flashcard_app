import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcard_app/data/data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RequestDatasource {
  final firestore = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;

  Future<String?> requestJoinGroup(String groupId) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final groups = await firestore
          .collection("groups")
          .where("groupId", isEqualTo: groupId)
          .get();

      final groupMembers = await firestore
          .collection("groupMembers")
          .where("groupId", isEqualTo: groupId)
          .where("userId", isEqualTo: userId)
          .get();

      final requests = await firestore
          .collection("requests")
          .where("groupId", isEqualTo: groupId)
          .where("userId", isEqualTo: userId)
          .get();

      if (groups.docs.isEmpty) {
        return "Nhóm không tồn tại";
      } else if (groupMembers.docs.isNotEmpty) {
        return "Bạn đã ở trong nhóm này";
      } else if (requests.docs.isNotEmpty) {
        return "Yêu cầu tham gia nhóm đang chờ duyệt";
      }
    } catch (e) {
      log("Error sending request: $e");
      return "Đã có lỗi khi gửi yêu cầu";
    }
    return null;
  }

  Future<void> sendRequest(Requests request) async {
    try {
      final newRequestDoc = firestore.collection("requests").doc();
      final newRequestId = newRequestDoc.id;

      await newRequestDoc
          .set(request.copyWith(requestId: newRequestId).toMap());
      log("Success join request");
    } catch (e) {
      log("Error join request: $e");
    }
  }

  Future<void> deleteRequest(String requestId) async {
    try {
      await firestore.collection('requests').doc(requestId).delete();
      log("success delete request");
    } catch (e) {
      log("error delete request: $e");
    }
  }
}

import 'dart:developer';

import 'package:flashcard_app/data/data.dart';
import 'package:flashcard_app/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupNotifier extends StateNotifier<GroupState> {
  final GroupRepositories repository;

  GroupNotifier(this.repository) : super(const GroupState.initial());

  Future<void> createGroup(
      Groups groups, String createdBy, String creatorName) async {
    try {
      await repository.createSet(groups, createdBy, creatorName);
    } catch (e) {
      log("error: $e");
    }
  }
}

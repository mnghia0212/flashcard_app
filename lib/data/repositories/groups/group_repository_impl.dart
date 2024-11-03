import 'dart:developer';

import 'package:flashcard_app/data/data.dart';

class GroupRepositoryImpl implements GroupRepositories {
  final GroupDatasource datasource;
  GroupRepositoryImpl(this.datasource);

  @override
  Future<void> createSet(
    Groups groups, String createdBy, String creatorName) async {
    try {
      await datasource.createGroup(groups, createdBy, creatorName);
    } catch (e) {
      log("$e");
    }
  }
}

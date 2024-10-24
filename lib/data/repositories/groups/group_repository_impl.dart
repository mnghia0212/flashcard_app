import 'dart:developer';

import 'package:flashcard_app/data/data.dart';

class GroupRepositoryImpl implements GroupRepositories {
  final GroupDatasource datasource;
  GroupRepositoryImpl(this.datasource);

  @override
  Future<void> createSet(Groups groups) async {
    try {
      await datasource.createGroup(groups);
    } catch (e) {
      log("$e");
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flashcard_app/data/data.dart';

final groupRepositoryProvider = Provider<GroupRepositories>((ref) {
  final datasource = ref.watch(groupDatasourceProvider);
  return GroupRepositoryImpl(datasource);
});
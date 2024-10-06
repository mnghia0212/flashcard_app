import 'package:flashcard_app/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<UserRepositories>((ref) {
  final datasource = ref.watch(userDatasourceProvider);
  return UserRepositoryImpl(datasource);
});
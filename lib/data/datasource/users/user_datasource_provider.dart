import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flashcard_app/data/data.dart';

final userDatasourceProvider = Provider<UserDatasource>((ref) {
  return UserDatasource();
});
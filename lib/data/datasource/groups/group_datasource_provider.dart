import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flashcard_app/data/data.dart';

final groupDatasourceProvider = Provider<GroupDatasource>((ref) {
  return GroupDatasource();
});
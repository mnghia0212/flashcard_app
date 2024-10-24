import 'package:flashcard_app/data/data.dart';

abstract class GroupRepositories {
  Future<void> createSet(Groups groups);
}
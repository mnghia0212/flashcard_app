import 'package:flashcard_app/data/data.dart';

abstract class UserRepositories {
  Future<void> createUser(Users user);
  Future<Users?> getUser(String userId);
}

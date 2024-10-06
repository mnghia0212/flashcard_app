import 'package:flashcard_app/data/data.dart';

class UserRepositoryImpl implements UserRepositories {
  final UserDatasource _datasource;
  UserRepositoryImpl(this._datasource);

  @override
  Future<void> createUser(Users user) async {
    try {
      await _datasource.createUser(user);
    } catch (e) {
      throw '$e';
    }
  }

  @override
  Future<Users?> getUser(String userId) async {
    try {
      return await _datasource.getUser(userId);
    } catch (e) {
      throw '$e';
    }
  }
}
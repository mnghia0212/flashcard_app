import 'package:equatable/equatable.dart';
import 'package:flashcard_app/data/data.dart';

class UserState extends Equatable {
  final Users? user;

  const UserState({required this.user});

  const UserState.initial() : user = null;

  UserState copyWith({
    Users? user,
  }) {
    return UserState(user: user ?? this.user);
  }

  @override
  List<Object?> get props => [user];
}

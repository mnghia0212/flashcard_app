import 'package:equatable/equatable.dart';
import 'package:flashcard_app/data/data.dart';

class GroupState extends Equatable {
  final List<Groups> groups;

  const GroupState({required this.groups});

  const GroupState.initial({this.groups = const []});

  GroupState copyWith({List<Groups>? groups}) {
    return GroupState(
        groups: groups ?? this.groups);
  }

  @override
  List<Object?> get props => [groups];
}
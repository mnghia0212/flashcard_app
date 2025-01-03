// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class GroupMembers extends Equatable {
  final String groupMemberId; 
  final String groupId;
  final String userId;
  final String joinedAt;
  final bool isAdmin;
  const GroupMembers({
    required this.groupMemberId,
    required this.groupId,
    required this.userId,
    required this.joinedAt,
    required this.isAdmin
  });

  GroupMembers copyWith({
    String? groupMemberId,
    String? groupId,
    String? userId,
    String? joinedAt,
    bool? isAdmin,
  }) {
    return GroupMembers(
      groupMemberId: groupMemberId ?? this.groupMemberId,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      joinedAt: joinedAt ?? this.joinedAt,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'groupMemberId': groupMemberId,
      'groupId': groupId,
      'userId': userId,
      'joinedAt': joinedAt,
      'isAdmin': isAdmin,
    };
  }

  factory GroupMembers.fromMap(Map<String, dynamic> map) {
    return GroupMembers(
      groupMemberId: map['groupMemberId'] as String,
      groupId: map['groupId'] as String,
      userId: map['userId'] as String,
      joinedAt: map['joinedAt'] as String,
      isAdmin: map['isAdmin'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupMembers.fromJson(String source) => GroupMembers.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      groupMemberId,
      groupId,
      userId,
      joinedAt,
      isAdmin,
    ];
  }
}

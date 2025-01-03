// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Requests extends Equatable {
  final String requestId;
  final String userId;
  final String groupId;
  final String requestedAt;
  const Requests({
    required this.requestId,
    required this.userId,
    required this.groupId,
    required this.requestedAt,
  });
  

  Requests copyWith({
    String? requestId,
    String? userId,
    String? groupId,
    String? requestedAt,
  }) {
    return Requests(
      requestId: requestId ?? this.requestId,
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      requestedAt: requestedAt ?? this.requestedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'requestId': requestId,
      'userId': userId,
      'groupId': groupId,
      'requestedAt': requestedAt,
    };
  }

  factory Requests.fromMap(Map<String, dynamic> map) {
    return Requests(
      requestId: map['requestId'] as String,
      userId: map['userId'] as String,
      groupId: map['groupId'] as String,
      requestedAt: map['requestedAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Requests.fromJson(String source) => Requests.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [requestId, userId, groupId, requestedAt];
}

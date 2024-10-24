// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Groups extends Equatable {
  final String groupId;
  final String groupName;
  final String createdBy;
  final String createdAt;
  final String? imagePath;
  const Groups({
    required this.groupId,
    required this.groupName,
    required this.createdBy,
    required this.createdAt,
    this.imagePath,
  });

  Groups copyWith({
    String? groupId,
    String? groupName,
    String? createdBy,
    String? createdAt,
    String? imagePath,
  }) {
    return Groups(
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'groupId': groupId,
      'groupName': groupName,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'imagePath': imagePath,
    };
  }

  factory Groups.fromMap(Map<String, dynamic> map) {
    return Groups(
      groupId: map['groupId'] as String,
      groupName: map['groupName'] as String,
      createdBy: map['createdBy'] as String,
      createdAt: map['createdAt'] as String,
      imagePath: map['imagePath'] != null ? map['imagePath'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Groups.fromJson(String source) => Groups.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      groupId,
      groupName,
      createdBy,
      createdAt,
    ];
  }
}

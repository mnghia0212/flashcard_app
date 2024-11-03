// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class FlashcardSetsShared extends Equatable {
  final String flashcardSetSharedId;
  final String userId;
  final String setId;
  final String setName;
  final String groupId;
  final String sharedAt;
  const FlashcardSetsShared({
    required this.flashcardSetSharedId,
    required this.userId,
    required this.setId,
    required this.setName,
    required this.groupId,
    required this.sharedAt,
  });

  FlashcardSetsShared copyWith({
    String? flashcardSetSharedId,
    String? userId,
    String? setId,
    String? setName,
    String? groupId,
    String? sharedAt,
  }) {
    return FlashcardSetsShared(
      flashcardSetSharedId: flashcardSetSharedId ?? this.flashcardSetSharedId,
      userId: userId ?? this.userId,
      setId: setId ?? this.setId,
      setName: setName ?? this.setName,
      groupId: groupId ?? this.groupId,
      sharedAt: sharedAt ?? this.sharedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'flashcardSetSharedId': flashcardSetSharedId,
      'userId': userId,
      'setId': setId,
      'setName': setName,
      'groupId': groupId,
      'sharedAt': sharedAt,
    };
  }

  factory FlashcardSetsShared.fromMap(Map<String, dynamic> map) {
    return FlashcardSetsShared(
      flashcardSetSharedId: map['flashcardSetSharedId'] as String,
      userId: map['userId'] as String,
      setId: map['setId'] as String,
      setName: map['setName'] as String,
      groupId: map['groupId'] as String,
      sharedAt: map['sharedAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FlashcardSetsShared.fromJson(String source) => FlashcardSetsShared.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      flashcardSetSharedId,
      userId,
      setId,
      setName,
      groupId,
      sharedAt,
    ];
  }
}

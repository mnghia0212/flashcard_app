// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Comments extends Equatable {
  final String commentId;
  final String userId;
  final String setId;
  final String text;
  final String commentedAt;
  const Comments({
    required this.commentId,
    required this.userId,
    required this.setId,
    required this.text,
    required this.commentedAt,
  });

  Comments copyWith({
    String? commentId,
    String? userId,
    String? setId,
    String? text,
    String? commentedAt,
  }) {
    return Comments(
      commentId: commentId ?? this.commentId,
      userId: userId ?? this.userId,
      setId: setId ?? this.setId,
      text: text ?? this.text,
      commentedAt: commentedAt ?? this.commentedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentId': commentId,
      'userId': userId,
      'setId': setId,
      'text': text,
      'commentedAt': commentedAt,
    };
  }

  factory Comments.fromMap(Map<String, dynamic> map) {
    return Comments(
      commentId: map['commentId'] as String,
      userId: map['userId'] as String,
      setId: map['setId'] as String,
      text: map['text'] as String,
      commentedAt: map['commentedAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Comments.fromJson(String source) => Comments.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      commentId,
      userId,
      setId,
      text,
      commentedAt,
    ];
  }
}

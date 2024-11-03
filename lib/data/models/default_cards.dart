// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class DefaultCards extends Equatable {
  final String flashcardId;
  final String setId;
  final String frontContent;
  final String backContent;
  
  const DefaultCards({
    required this.flashcardId,
    required this.setId,
    required this.frontContent,
    required this.backContent,
  });

  DefaultCards copyWith({
    String? flashcardId,
    String? setId,
    String? frontContent,
    String? backContent,
  }) {
    return DefaultCards(
      flashcardId: flashcardId ?? this.flashcardId,
      setId: setId ?? this.setId,
      frontContent: frontContent ?? this.frontContent,
      backContent: backContent ?? this.backContent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'flashcardId': flashcardId,
      'setId': setId,
      'frontContent': frontContent,
      'backContent': backContent,
    };
  }

  factory DefaultCards.fromMap(Map<String, dynamic> map) {
    return DefaultCards(
      flashcardId: map['flashcardId'] as String,
      setId: map['setId'] as String,
      frontContent: map['frontContent'] as String,
      backContent: map['backContent'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DefaultCards.fromJson(String source) => DefaultCards.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [flashcardId, setId, frontContent, backContent];
}

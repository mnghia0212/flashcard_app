// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class TestCards extends Equatable {
  final String testCardId;
  final String frontSide;
  final String backSide;
  const TestCards({
    required this.testCardId,
    required this.frontSide,
    required this.backSide,
  });

  TestCards copyWith({
    String? testCardId,
    String? frontSide,
    String? backSide,
  }) {
    return TestCards(
      testCardId: testCardId ?? this.testCardId,
      frontSide: frontSide ?? this.frontSide,
      backSide: backSide ?? this.backSide,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'testCardId': testCardId,
      'frontSide': frontSide,
      'backSide': backSide,
    };
  }

  factory TestCards.fromMap(Map<String, dynamic> map) {
    return TestCards(
      testCardId: map['testCardId'] as String,
      frontSide: map['frontSide'] as String,
      backSide: map['backSide'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TestCards.fromJson(String source) => TestCards.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [testCardId, frontSide, backSide];
}

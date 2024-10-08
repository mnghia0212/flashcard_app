// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class FlashcardSetDetails extends Equatable {
  final String detailId;
  final String flashcardSetId;
  final String flashcardId;
  const FlashcardSetDetails({
    required this.detailId,
    required this.flashcardSetId,
    required this.flashcardId,
  });
  
 

  FlashcardSetDetails copyWith({
    String? detailId,
    String? flashcardSetId,
    String? flashcardId,
  }) {
    return FlashcardSetDetails(
      detailId: detailId ?? this.detailId,
      flashcardSetId: flashcardSetId ?? this.flashcardSetId,
      flashcardId: flashcardId ?? this.flashcardId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'detailId': detailId,
      'flashcardSetId': flashcardSetId,
      'flashcardId': flashcardId,
    };
  }

  factory FlashcardSetDetails.fromMap(Map<String, dynamic> map) {
    return FlashcardSetDetails(
      detailId: map['detailId'] as String,
      flashcardSetId: map['flashcardSetId'] as String,
      flashcardId: map['flashcardId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FlashcardSetDetails.fromJson(String source) => FlashcardSetDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  // TODO: implement props
  List<Object?> get props {
    return [
        detailId,
        flashcardId,
        flashcardSetId
    ];
  }
}

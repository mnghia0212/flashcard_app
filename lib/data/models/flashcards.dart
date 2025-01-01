// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flashcard_app/data/data.dart';

class Flashcards extends Equatable implements StudyCards {
  final String flashcardId;
  final String userId;
  final String setId;
  @override
  final String frontContent;
  @override
  final String backContent;
  final String? audioFile;
  final String? videoFile;
  final String? audioPath;
  final String? videoPath;
  final String createdAt;
  final String? updatedAt;

  const Flashcards({
    required this.flashcardId,
    required this.userId,
    required this.setId,
    required this.frontContent,
    required this.backContent,
    this.audioPath,
    this.videoPath,
    this.audioFile,
    this.videoFile,
    required this.createdAt,
    this.updatedAt,
  });

  Flashcards copyWith({
    String? flashcardId,
    String? userId,
    String? setId,
    String? frontContent,
    String? backContent,
    String? audioPath,
    String? videoPath,
    String? audioFile,
    String? videoFile,
    String? createdAt,
    String? updatedAt,
  }) {
    return Flashcards(
      flashcardId: flashcardId ?? this.flashcardId,
      userId: userId ?? this.userId,
      setId: setId ?? this.setId,
      frontContent: frontContent ?? this.frontContent,
      backContent: backContent ?? this.backContent,
      audioPath: audioPath,
      videoPath: videoPath,
      audioFile: audioFile,
      videoFile: videoFile,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'flashcardId': flashcardId,
      'userId': userId,
      'setId': setId,
      'frontContent': frontContent,
      'backContent': backContent,
      'audioPath': audioPath,
      'videoPath': videoPath,
      'audioFile': audioFile,
      'videoFile': videoFile,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Flashcards.fromMap(Map<String, dynamic> map) {
    return Flashcards(
      flashcardId: map['flashcardId'] as String,
      userId: map['userId'] as String,
      setId: map['setId'] as String,
      frontContent: map['frontContent'] as String,
      backContent: map['backContent'] as String,
      audioPath: map['audioPath'] != null ? map['audioPath'] as String : null,
      videoPath: map['videoPath'] != null ? map['videoPath'] as String : null,
      audioFile: map['audioFile'] != null ? map['audioFile'] as String : null,
      videoFile: map['videoFile'] != null ? map['videoFile'] as String : null,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Flashcards.fromJson(String source) =>
      Flashcards.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      flashcardId,
      userId,
      setId,
      frontContent,
      backContent,
      audioPath,
      videoPath,
      audioFile,
      videoFile,
      createdAt,
      updatedAt,
    ];
  }

  @override
  String get uniqueKey => flashcardId;
}

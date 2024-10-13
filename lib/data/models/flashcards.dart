// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Flashcards extends Equatable {
  final String flashcardId;
  final String userId;
  final String frontContent;
  final String backContent;
  final String? audioPath;
  final String? videoPath;
  final String createdAt;
  final String? updatedAt;
  final int correctStreak;
  final int incorrectStreak;
  const Flashcards(
      {required this.flashcardId,
      required this.userId,
      required this.frontContent,
      required this.backContent,
      this.audioPath,
      this.videoPath,
      required this.createdAt,
      this.updatedAt,
      this.correctStreak = 0,
      this.incorrectStreak = 0});

  @override
  List<Object?> get props {
    return [
      flashcardId,
      userId,
      frontContent,
      backContent,
      createdAt,
      correctStreak,
      incorrectStreak
    ];
  }

  bool isMaster() => correctStreak >= 2;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'flashcardId': flashcardId,
      'userId': userId,
      'frontContent': frontContent,
      'backContent': backContent,
      'audioPath': audioPath,
      'videoPath': videoPath,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'correctStreak': correctStreak,
      'incorrectStreak': incorrectStreak
    };
  }

  factory Flashcards.fromMap(Map<String, dynamic> map) {
  return Flashcards(
    flashcardId: map['flashcardId'] as String,
    userId: map['userId'] as String,
    frontContent: map['frontContent'] as String,
    backContent: map['backContent'] as String,
    audioPath: map['audioPath'] != null ? map['audioPath'] as String : null,
    videoPath: map['videoPath'] != null ? map['videoPath'] as String : null,
    createdAt: map['createdAt'] as String,
    updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
    correctStreak: map['correctStreak'] as int,  
    incorrectStreak: map['incorrectStreak'] as int, 
  );
}


  String toJson() => json.encode(toMap());

  factory Flashcards.fromJson(String source) =>
      Flashcards.fromMap(json.decode(source) as Map<String, dynamic>);

  Flashcards copyWith({
    String? flashcardId,
    String? userId,
    String? frontContent,
    String? backContent,
    String? audioPath,
    String? videoPath,
    String? createdAt,
    String? updatedAt,
    int? correctStreak,
    int? incorrectStreak
  }) {
    return Flashcards(
      flashcardId: flashcardId ?? this.flashcardId,
      userId: userId ?? this.userId,
      frontContent: frontContent ?? this.frontContent,
      backContent: backContent ?? this.backContent,
      audioPath: audioPath ?? this.audioPath,
      videoPath: videoPath ?? this.videoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      correctStreak: correctStreak ?? this.correctStreak,
      incorrectStreak: incorrectStreak ?? this.incorrectStreak
    );
  }
}

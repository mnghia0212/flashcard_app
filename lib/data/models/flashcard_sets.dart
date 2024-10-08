// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class FlashcardSets extends Equatable {
  final String setId;
  final String userId;
  final String title;
  final String description;
  final bool isFavorite;
  final String createdAt;
  final String? updatedAt;

  const FlashcardSets({
    required this.setId,
    required this.userId,
    required this.title,
    required this.description,
    this.isFavorite = false,
    required this.createdAt,
    this.updatedAt,
  });

  FlashcardSets copyWith({
    String? setId,
    String? userId,
    String? title,
    String? description,
    bool? isFavorite,
    String? createdAt,
    String? updatedAt,
  }) {
    return FlashcardSets(
      setId: setId ?? this.setId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
  
  @override
  List<Object> get props {
    return [
      setId,
      userId,
      title,
      description,
      isFavorite,
      createdAt,
    ];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'setId': setId,
      'userId': userId,
      'title': title,
      'description': description,
      'isFavorite': isFavorite,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory FlashcardSets.fromMap(Map<String, dynamic> map) {
    return FlashcardSets(
      setId: map['setId'] as String,
      userId: map['userId'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      isFavorite: map['isFavorite'] as bool,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FlashcardSets.fromJson(String source) => FlashcardSets.fromMap(json.decode(source) as Map<String, dynamic>);
}

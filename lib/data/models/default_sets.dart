// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class DefaultSets extends Equatable {
  final String setId;
  final String title;

  const DefaultSets({
    required this.setId,
    required this.title,
  });



  DefaultSets copyWith({
    String? setId,
    String? title,
  }) {
    return DefaultSets(
      setId: setId ?? this.setId,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'setId': setId,
      'title': title,
    };
  }

  factory DefaultSets.fromMap(Map<String, dynamic> map) {
    return DefaultSets(
      setId: map['setId'] as String,
      title: map['title'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DefaultSets.fromJson(String source) => DefaultSets.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [setId, title];
}

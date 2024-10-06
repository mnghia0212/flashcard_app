// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Users extends Equatable {
  final String userId;
  final String userName;
  final String email;
  final String password;
  final String? role;
  final String? createdAt;
  final String? profilePicture;
  const Users({
    required this.userId,
    required this.userName,
    required this.email,
    required this.password,
     this.role,
     this.createdAt,
    this.profilePicture,
  });
  
  @override
  List<Object> get props {
    return [
      userName,
      email,
      password
    ];
  }

  Users copyWith({
    String? userId,
    String? userName,
    String? email,
    String? password,
    String? role,
    String? createdAt,
    String? profilePicture,
  }) {
    return Users(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'userName': userName,
      'email': email,
      'password': password,
      'role': role,
      'createdAt': createdAt,
      'profilePicture': profilePicture,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      role: map['role'] != null ? map['role'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      profilePicture: map['profilePicture'] != null ? map['profilePicture'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Users.fromJson(String source) => Users.fromMap(json.decode(source) as Map<String, dynamic>);
}

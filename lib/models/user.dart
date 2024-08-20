import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:parkmate/auth/login_view.dart';

class User {
  final String name;
  final String email;
  final String password;
  final UserType type;
  User(
      {required this.name,
      required this.email,
      required this.password,
      required this.type});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      password: '',
      type: json['type'] == 'host' ? UserType.host : UserType.seeker,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': md5.convert(utf8.encode(password)).toString(),
      'type': type.name,
    };
  }
}

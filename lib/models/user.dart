import 'package:flutter/material.dart';

import 'company.dart';

// https://javiercbk.github.io/json_to_dart/
class User {
  int id;
  String login;
  String firstName;
  String lastName;
  String email;
  bool activated;
  String langKey;
  String imageUrl;
  Company azienda;

  User(
      {this.id,
      this.login,
      this.firstName,
      this.lastName,
      this.email,
      this.activated,
      this.langKey,
      this.imageUrl,
      this.azienda});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    activated = json['activated'];
    langKey = json['langKey'];
    imageUrl = json['imageUrl'];
    azienda =
        json['azienda'] != null ? new Company.fromJson(json['azienda']) : null;
  }
}

class LoginRequest {
  String username;
  String password;

  LoginRequest({@required this.username, @required this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username.trim();
    data['password'] = this.password.trim();
    data['rememberMe'] = true;

    return data;
  }
}

class RefreshTokenRequest {
  String refreshToken;

  RefreshTokenRequest(this.refreshToken);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['refreshToken'] = this.refreshToken;
    data['rememberMe'] = true;

    return data;
  }
}

class LoginResponse {
  String accessToken;
  String refreshToken;

  LoginResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }
}

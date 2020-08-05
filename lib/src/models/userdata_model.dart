// To parse this JSON data, do
//
//     final userDataModel = userDataModelFromJson(jsonString);

import 'dart:convert';

UserDataModel userDataModelFromJson(String str) => UserDataModel.fromJson(json.decode(str));

String userDataModelToJson(UserDataModel data) => json.encode(data.toJson());

class UserDataModel {
  UserDataModel({
    this.ok,
    this.user,
  });

  bool ok;
  User user;

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
    ok: json["ok"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "user": user.toJson(),
  };
}

class User {
  User({
    this.name,
    this.lastname,
    this.phone1,
    this.phone2,
    this.phone3,
    this.email,
    this.dni,
  });

  String name;
  String lastname;
  dynamic phone1;
  String phone2;
  String phone3;
  String email;
  String dni;

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    lastname: json["lastname"],
    phone1: json["phone_1"],
    phone2: json["phone_2"],
    phone3: json["phone_3"],
    email: json["email"],
    dni: json["DNI"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "lastname": lastname,
    "phone_1": phone1,
    "phone_2": phone2,
    "phone_3": phone3,
    "email": email,
    "DNI": dni,
  };
}

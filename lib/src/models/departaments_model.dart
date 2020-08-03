import 'dart:convert';

DepartamentsModel departamentsModelFromJson(String str) => DepartamentsModel.fromJson(json.decode(str));

String departamentsModelToJson(DepartamentsModel data) => json.encode(data.toJson());

class DepartamentsModel {
  DepartamentsModel({
    this.ok,
    this.departaments,
  });

  bool ok;
  List<Departament> departaments;

  factory DepartamentsModel.fromJson(Map<String, dynamic> json) => DepartamentsModel(
    ok: json["ok"],
    departaments: List<Departament>.from(json["departaments"].map((x) => Departament.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "departaments": List<dynamic>.from(departaments.map((x) => x.toJson())),
  };
}

class Departament {
  Departament({
    this.name,
    this.ucode,
  });

  String name;
  String ucode;

  factory Departament.fromJson(Map<String, dynamic> json) => Departament(
    name: json["name"],
    ucode: json["ucode"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "ucode": ucode,
  };
}

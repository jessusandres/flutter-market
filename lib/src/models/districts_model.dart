import 'dart:convert';

DIstrictsModel dIstrictsModelFromJson(String str) => DIstrictsModel.fromJson(json.decode(str));

String dIstrictsModelToJson(DIstrictsModel data) => json.encode(data.toJson());

class DIstrictsModel {
  DIstrictsModel({
    this.ok,
    this.districts,
  });

  bool ok;
  List<District> districts;

  factory DIstrictsModel.fromJson(Map<String, dynamic> json) => DIstrictsModel(
    ok: json["ok"],
    districts: List<District>.from(json["districts"].map((x) => District.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "districts": List<dynamic>.from(districts.map((x) => x.toJson())),
  };
}

class District {
  District({
    this.name,
    this.ucode,
  });

  String name;
  String ucode;

  factory District.fromJson(Map<String, dynamic> json) => District(
    name: json["name"],
    ucode: json["ucode"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "ucode": ucode,
  };
}

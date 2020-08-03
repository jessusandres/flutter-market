import 'dart:convert';

ProvincesModel provincesModelFromJson(String str) => ProvincesModel.fromJson(json.decode(str));

String provincesModelToJson(ProvincesModel data) => json.encode(data.toJson());

class ProvincesModel {
  ProvincesModel({
    this.ok,
    this.provinces,
  });

  bool ok;
  List<Province> provinces;

  factory ProvincesModel.fromJson(Map<String, dynamic> json) => ProvincesModel(
    ok: json["ok"],
    provinces: List<Province>.from(json["provinces"].map((x) => Province.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "provinces": List<dynamic>.from(provinces.map((x) => x.toJson())),
  };
}

class Province {
  Province({
    this.name,
    this.ucode,
  });

  String name;
  String ucode;

  factory Province.fromJson(Map<String, dynamic> json) => Province(
    name: json["name"],
    ucode: json["ucode"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "ucode": ucode,
  };
}

import 'dart:convert';

StoreAddressDataModel storeAddressDataModelFromJson(String str) => StoreAddressDataModel.fromJson(json.decode(str));

String storeAddressDataModelToJson(StoreAddressDataModel data) => json.encode(data.toJson());

class StoreAddressDataModel {
  StoreAddressDataModel({
    this.ok,
    this.addresses,
  });

  bool ok;
  List<StoreAddress> addresses;

  factory StoreAddressDataModel.fromJson(Map<String, dynamic> json) => StoreAddressDataModel(
    ok: json["ok"],
    addresses: List<StoreAddress>.from(json["addresses"].map((x) => StoreAddress.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "addresses": List<dynamic>.from(addresses.map((x) => x.toJson())),
  };
}

class StoreAddress {
  StoreAddress({
    this.wname,
    this.direction,
    this.code,
    this.departamento,
    this.provincia,
  });

  String wname;
  String direction;
  String code;
  String departamento;
  String provincia;

  factory StoreAddress.fromJson(Map<String, dynamic> json) => StoreAddress(
    wname: json["wname"],
    direction: json["direction"],
    code: json["code"],
    departamento: json["departamento"],
    provincia: json["provincia"],
  );

  Map<String, dynamic> toJson() => {
    "wname": wname,
    "direction": direction,
    "code": code,
    "departamento": departamento,
    "provincia": provincia,
  };
}

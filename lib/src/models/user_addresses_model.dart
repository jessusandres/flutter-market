import 'dart:convert';

UserAddresses userAddressesFromJson(String str) => UserAddresses.fromJson(json.decode(str));

String userAddressesToJson(UserAddresses data) => json.encode(data.toJson());

class UserAddresses {
  UserAddresses({
    this.ok,
    this.addresses,
  });

  bool ok;
  List<Address> addresses;

  factory UserAddresses.fromJson(Map<String, dynamic> json) => UserAddresses(
    ok: json["ok"],
    addresses: List<Address>.from(json["addresses"].map((x) => Address.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "addresses": List<dynamic>.from(addresses.map((x) => x.toJson())),
  };
}

class Address {
  Address({
    this.direction,
    this.reference,
    this.departament,
    this.province,
    this.district,
    this.addressCode,
  });

  String direction;
  String reference;
  String departament;
  String province;
  String district;
  String addressCode;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    direction: json["direction"],
    reference: json["reference"],
    departament: json["departament"],
    province: json["province"],
    district: json["district"],
    addressCode: json["addressCode"],
  );

  Map<String, dynamic> toJson() => {
    "direction": direction,
    "reference": reference,
    "departament": departament,
    "province": province,
    "district": district,
    "addressCode": addressCode,
  };
}

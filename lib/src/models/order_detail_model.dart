import 'dart:convert';

UserOrderDetailResponse userOrderDetailResponseFromJson(String str) => UserOrderDetailResponse.fromJson(json.decode(str));

String userOrderDetailResponseToJson(UserOrderDetailResponse data) => json.encode(data.toJson());

class UserOrderDetailResponse {
  UserOrderDetailResponse({
    this.ok,
    this.detail,
  });

  bool ok;
  List<Detail> detail;

  factory UserOrderDetailResponse.fromJson(Map<String, dynamic> json) => UserOrderDetailResponse(
    ok: json["ok"],
    detail: List<Detail>.from(json["detail"].map((x) => Detail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "detail": List<dynamic>.from(detail.map((x) => x.toJson())),
  };
}

class Detail {
  Detail({
    this.itemDescription,
    this.brand,
    this.unity,
    this.amount,
    this.unityPrice,
    this.orderNumber,
    this.storeName,
    this.image,
  });

  String itemDescription;
  String brand;
  String unity;
  int amount;
  int unityPrice;
  String orderNumber;
  String storeName;
  String image;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    itemDescription: json["itemDescription"],
    brand: json["brand"],
    unity: json["unity"],
    amount: json["amount"],
    unityPrice: json["unityPrice"],
    orderNumber: json["orderNumber"],
    storeName: json["storeName"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "itemDescription": itemDescription,
    "brand": brand,
    "unity": unity,
    "amount": amount,
    "unityPrice": unityPrice,
    "orderNumber": orderNumber,
    "storeName": storeName,
    "image": image,
  };
}

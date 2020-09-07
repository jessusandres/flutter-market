import 'dart:convert';

UserOrderResponse userOrderResponseFromJson(String str) => UserOrderResponse.fromJson(json.decode(str));

String userOrderResponseToJson(UserOrderResponse data) => json.encode(data.toJson());

class UserOrderResponse {
  UserOrderResponse({
    this.ok,
    this.orders,
  });

  bool ok;
  List<Order> orders;

  factory UserOrderResponse.fromJson(Map<String, dynamic> json) => UserOrderResponse(
    ok: json["ok"],
    orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
  };
}

class Order {
  Order({
    this.storeRuc,
    this.storeName,
    this.purchaseDate,
    this.total,
    this.state,
    this.purchaseCode,
    this.avatar,
  });

  String storeRuc;
  String storeName;
  String purchaseDate;
  double total;
  int state;
  String purchaseCode;
  String avatar;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    storeRuc: json["storeRUC"],
    storeName: json["storeName"],
    purchaseDate: json["purchaseDate"],
    total: json["total"].toDouble(),
    state: json["state"],
    purchaseCode: json["purchaseCode"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "storeRUC": storeRuc,
    "storeName": storeName,
    "purchaseDate": purchaseDate,
    "total": total,
    "state": state,
    "purchaseCode": purchaseCode,
    "avatar": avatar,
  };
}

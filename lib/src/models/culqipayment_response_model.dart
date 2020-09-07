import 'dart:convert';

import 'package:gustolact/src/models/paymentItem.dart';

CulqiPaymentResponse culqiPaymentResponseFromJson(String str) => CulqiPaymentResponse.fromJson(json.decode(str));

String culqiPaymentResponseToJson(CulqiPaymentResponse data) => json.encode(data.toJson());

class CulqiPaymentResponse {
  CulqiPaymentResponse({
    this.ok,
    this.total,
    this.observations,
    this.userPaymentCulqi,
    this.items,
    this.message,
    this.emailStatus,
    this.emailError,
  });

  bool ok;
  double total;
  List<dynamic> observations;
  UserPaymentCulqi userPaymentCulqi;
  List<PaymentItem> items;
  String message;
  bool emailStatus;
  dynamic emailError;

  factory CulqiPaymentResponse.fromJson(Map<String, dynamic> json) => CulqiPaymentResponse(
    ok: json["ok"],
    total: json["total"].toDouble(),
    observations: List<dynamic>.from(json["observations"].map((x) => x)),
    userPaymentCulqi: UserPaymentCulqi.fromJson(json["userPaymentCulqi"]),
    items: List<PaymentItem>.from(json["items"].map((x) => PaymentItem.fromJson(x))),
    message: json["message"],
    emailStatus: json["emailStatus"],
    emailError: json["emailError"],
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "total": total,
    "observations": List<dynamic>.from(observations.map((x) => x)),
    "userPaymentCulqi": userPaymentCulqi.toJson(),
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "message": message,
    "emailStatus": emailStatus,
    "emailError": emailError,
  };
}



class UserPaymentCulqi {
  UserPaymentCulqi({
    this.paymentDate,
    this.cardNumber,
    this.cardBrand,
    this.cardType,
    this.cardCategory,
    this.ammount,
    this.currency,
  });

  String paymentDate;
  String cardNumber;
  String cardBrand;
  String cardType;
  String cardCategory;
  int ammount;
  String currency;

  factory UserPaymentCulqi.fromJson(Map<String, dynamic> json) => UserPaymentCulqi(
    paymentDate: json["paymentDate"],
    cardNumber: json["cardNumber"],
    cardBrand: json["cardBrand"],
    cardType: json["cardType"],
    cardCategory: json["cardCategory"],
    ammount: json["ammount"],
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "paymentDate": paymentDate,
    "cardNumber": cardNumber,
    "cardBrand": cardBrand,
    "cardType": cardType,
    "cardCategory": cardCategory,
    "ammount": ammount,
    "currency": currency,
  };
}

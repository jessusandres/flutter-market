import 'dart:convert';

import 'package:gustolact/src/models/paymentItem.dart';

QuotationPaymentResponse quotationPaymentResponseFromJson(String str) => QuotationPaymentResponse.fromJson(json.decode(str));

String quotationPaymentResponseToJson(QuotationPaymentResponse data) => json.encode(data.toJson());

class QuotationPaymentResponse {
  QuotationPaymentResponse({
    this.ok,
    this.total,
    this.observations,
    this.items,
    this.message,
    this.emailStatus,
    this.emailError,
  });

  bool ok;
  double total;
  List<dynamic> observations;
  List<PaymentItem> items;
  String message;
  bool emailStatus;
  dynamic emailError;

  factory QuotationPaymentResponse.fromJson(Map<String, dynamic> json) => QuotationPaymentResponse(
    ok: json["ok"],
    total: json["total"].toDouble(),
    observations: List<dynamic>.from(json["observations"].map((x) => x)),
    items: List<PaymentItem>.from(json["items"].map((x) => PaymentItem.fromJson(x))),
    message: json["message"],
    emailStatus: json["emailStatus"],
    emailError: json["emailError"],
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "total": total,
    "observations": List<dynamic>.from(observations.map((x) => x)),
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "message": message,
    "emailStatus": emailStatus,
    "emailError": emailError,
  };
}



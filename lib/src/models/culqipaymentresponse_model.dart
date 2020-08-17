import 'dart:convert';

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
  List<Item> items;
  String message;
  bool emailStatus;
  dynamic emailError;

  factory CulqiPaymentResponse.fromJson(Map<String, dynamic> json) => CulqiPaymentResponse(
    ok: json["ok"],
    total: json["total"].toDouble(),
    observations: List<dynamic>.from(json["observations"].map((x) => x)),
    userPaymentCulqi: UserPaymentCulqi.fromJson(json["userPaymentCulqi"]),
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
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

class Item {
  Item({
    this.cartCode,
    this.cartRuc,
    this.cartStoreName,
    this.cartStoreUrl,
    this.cartItemCode,
    this.cartItemCodf,
    this.cartItemDescription,
    this.cartItemAmmount,
    this.cartItemPrice,
    this.cartItemImage,
    this.cartItemBrand,
    this.cartItemUnity,
    this.cartRemitentDni,
    this.cartRegisterDate,
    this.cartStatus,
  });

  String cartCode;
  String cartRuc;
  String cartStoreName;
  String cartStoreUrl;
  String cartItemCode;
  String cartItemCodf;
  String cartItemDescription;
  int cartItemAmmount;
  double cartItemPrice;
  String cartItemImage;
  String cartItemBrand;
  String cartItemUnity;
  String cartRemitentDni;
  String cartRegisterDate;
  int cartStatus;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    cartCode: json["cartCode"],
    cartRuc: json["cartRuc"],
    cartStoreName: json["cartStoreName"],
    cartStoreUrl: json["cartStoreUrl"],
    cartItemCode: json["cartItemCode"],
    cartItemCodf: json["cartItemCodf"],
    cartItemDescription: json["cartItemDescription"],
    cartItemAmmount: json["cartItemAmmount"],
    cartItemPrice: json["cartItemPrice"].toDouble(),
    cartItemImage: json["cartItemImage"],
    cartItemBrand: json["cartItemBrand"],
    cartItemUnity: json["cartItemUnity"],
    cartRemitentDni: json["cartRemitentDNI"],
    cartRegisterDate: json["cartRegisterDate"],
    cartStatus: json["cartStatus"],
  );

  Map<String, dynamic> toJson() => {
    "cartCode": cartCode,
    "cartRuc": cartRuc,
    "cartStoreName": cartStoreName,
    "cartStoreUrl": cartStoreUrl,
    "cartItemCode": cartItemCode,
    "cartItemCodf": cartItemCodf,
    "cartItemDescription": cartItemDescription,
    "cartItemAmmount": cartItemAmmount,
    "cartItemPrice": cartItemPrice,
    "cartItemImage": cartItemImage,
    "cartItemBrand": cartItemBrand,
    "cartItemUnity": cartItemUnity,
    "cartRemitentDNI": cartRemitentDni,
    "cartRegisterDate": cartRegisterDate,
    "cartStatus": cartStatus,
  };

  String getImage() {

    if( cartItemImage != null ) {

      return 'https://redmovildenegocios.com/Mas7er/r3dmark3t/images_items/$cartItemImage';

    }else {
      return 'http://redmovildenegocios.com/Mas7er/r3dmark3t/images_items/imagennodisponible.jpg';
    }
  }

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

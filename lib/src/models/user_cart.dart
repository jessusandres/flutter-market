import 'dart:convert';

List<UserCart> userCartFromJson(String str) => List<UserCart>.from(json.decode(str).map((x) => UserCart.fromJson(x)));

String userCartToJson(List<UserCart> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserCart {
  UserCart({
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
  int cartItemUnity;
  String cartRemitentDni;
  String cartRegisterDate;
  int cartStatus;

  factory UserCart.fromJson(Map<String, dynamic> json) => UserCart(
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

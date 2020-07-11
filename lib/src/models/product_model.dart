
import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  ProductModel({
    this.codi,
    this.codf,
    this.brand,
    this.imageUrl,
    this.name,
    this.und,
    this.appPrice,
    this.webPrice,
    this.description,
  });

  String codi;
  String codf;
  String brand;
  String imageUrl;
  String name;
  String und;
  int appPrice;
  double webPrice;
  String uniqueId;
  String description;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    codi: json["codi"],
    codf: json["codf"],
    brand: json["brand"],
    imageUrl: json["image_url"],
    name: json["name"],
    und: json["und"],
    appPrice: json["app_price"],
    webPrice: json["web_price"].toDouble(),
    description: json["full_description"],
  );

  Map<String, dynamic> toJson() => {
    "codi": codi,
    "codf": codf,
    "brand": brand,
    "image_url": imageUrl,
    "name": name,
    "und": und,
    "app_price": appPrice,
    "web_price": webPrice,
    "full_description": description,
  };

  String getImage() {

    if( imageUrl != null ) {

      return 'https://redmovildenegocios.com/Mas7er/r3dmark3t/images_items/$imageUrl';

    }else {
      return 'http://redmovildenegocios.com/Mas7er/r3dmark3t/images_items/imagennodisponible.jpg';
    }
  }
  String getDescription() {

    if( description != null ) {

      return description;

    }else {
      return 'Sin información adicional';
    }
  }
  String getName() {
    if(name.length > 22){
      return name.substring(0, 18) + '...';
    }else {
      return name;
    }

  }
}


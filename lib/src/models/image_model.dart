import 'dart:convert';

List<ImageModel> imageModelFromJson(String str) => List<ImageModel>.from(json.decode(str).map((x) => ImageModel.fromJson(x)));

String imageModelToJson(List<ImageModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ImageModel {
  ImageModel({
    this.codi,
    this.image,
  });

  String codi;
  String image;

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
    codi: json["codi"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "codi": codi,
    "image": image,
  };

  String getImage() {

    if( image != null ) {

      return 'https://redmovildenegocios.com/Mas7er/r3dmark3t/images_items/$image';

    }else {
      return 'http://redmovildenegocios.com/Mas7er/r3dmark3t/images_items/imagennodisponible.jpg';
    }
  }
}

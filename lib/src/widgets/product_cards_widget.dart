import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:gustolact/src/models/image_model.dart';
import 'package:gustolact/src/models/product_model.dart';
import 'package:gustolact/src/providers/product_provider.dart';
import 'package:provider/provider.dart';

class ProductCards extends StatelessWidget {

  final ProductModel product;

  const ProductCards({@required this.product});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final ProductProvider productProvider = Provider.of<ProductProvider>(context);

    productProvider.getProductImages(product.codi);

    List<ImageModel> images = productProvider.productImages[product.codi];

    if (images.length == 0) {
      return Container(
        height: size.height * 0.4,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Hero(
              tag: product.uniqueId,
              child: Container(
                height: size.height * 0.4,
                child: Swiper(
                    autoplay: false,
//                    pagination: SwiperPagination(),
                    layout: SwiperLayout.DEFAULT,
                    itemWidth: size.width * 0.7,
                    itemHeight: size.height,
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          color: Colors.white,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: FadeInImage(
                              placeholder: AssetImage('assets/gif/loading.gif'),
                              image: NetworkImage(images[index].getImage()),
                              fit: BoxFit.contain,
                            ),
                          ));
                    }),
              ),
            ),
          ],
        ),
      );

    }
  }
}
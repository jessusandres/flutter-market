import 'package:flutter/material.dart';
import 'package:gustolact/src/models/image_model.dart';
import 'package:gustolact/src/models/product_model.dart';
import 'package:gustolact/src/providers/product_provider.dart';
import 'package:gustolact/src/widgets/card_product.dart';
import 'package:provider/provider.dart';

class ProductRelatedCards extends StatelessWidget {

  final ProductModel product;

  const ProductRelatedCards({@required this.product});

  @override
  Widget build(BuildContext context) {

    final _pageController = new PageController(
      initialPage: 1,
      viewportFraction: 0.3,
    );

    final screenSize = MediaQuery.of(context).size;

    final ProductProvider _productProvider = Provider.of<ProductProvider>(context);

    List<ImageModel> images = _productProvider.productRelated[product.codi];

    if (images.length == 0) {
      if(_productProvider.nullRelatedList[product.codi]) {
        return SizedBox( height: 10, );
      }else {
        return Container(
          height: screenSize.height * 0.4,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    } else {
      return Container(
        height: screenSize.height * 0.30,
        child: PageView.builder(
          controller: _pageController,
          physics: BouncingScrollPhysics(),
          pageSnapping: false,
          itemCount: images.length,
          itemBuilder: (BuildContext context, int index) =>
              CardProduct( image: images[index], pagename: 'related',),
        ),
      );
    }

  }


}



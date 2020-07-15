import 'package:flutter/material.dart';
import 'package:gustolact/src/models/image_model.dart';
import 'package:gustolact/src/models/product_model.dart';
import 'package:gustolact/src/providers/product_provider.dart';
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

    final ProductProvider productProvider = Provider.of<ProductProvider>(context);

    List<ImageModel> images = productProvider.productRelated[product.codi];

    if (images.length == 0) {
      if(productProvider.nullRelatedList[product.codi]) {
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
              _Card( image: images[index],),
        ),
      );
    }

  }


}
class _Card extends StatelessWidget {

  final ImageModel image;

  const _Card({@required this.image});

  @override
  Widget build(BuildContext context) {

    ProductProvider productProvider = Provider.of<ProductProvider>(context);

    ProductModel _currentProduct = productProvider.products.firstWhere((element) => element.codi == image.codi);

    final screenSize = MediaQuery.of(context).size;

    final Widget productCard =  Container(
      child: Column(
        children: <Widget>[
          Hero(
            tag: _currentProduct.codi,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: FadeInImage(
                image: NetworkImage(image.getImage()),
                placeholder: AssetImage('assets/gif/loading.gif'),
                height: screenSize.height * 0.22,
                width: screenSize.width * 0.25,
                fit: BoxFit.cover,
//              height: 160.0,
              ),
            ),
          ),
          SizedBox(height: 3.0,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              _currentProduct.name,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            ),
          )
        ],
      ),
    );

    return GestureDetector(
      child: productCard,
      onTap: (){
//        Navigator.pushNamed(context, '/product_detail', arguments: _currentProduct);
        Navigator.pushNamed(context, '/product_detail',arguments:  _currentProduct );
//        Navigator.push(context, 'productDetail', arguments: _currentProduct);
      },
    );
  }
}

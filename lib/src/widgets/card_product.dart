import 'package:flutter/material.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/config/key.dart';
import 'package:gustolact/src/models/image_model.dart';
import 'package:gustolact/src/models/product_model.dart';
import 'package:gustolact/src/pages/product_detail_page.dart';
import 'package:gustolact/src/providers/product_provider.dart';
import 'package:gustolact/src/tansitions/fade_transition.dart';
import 'package:provider/provider.dart';

class CardProduct extends StatelessWidget {

  final ImageModel image;
  final String pagename;

  const CardProduct({@required this.image, @required this.pagename});

  @override
  Widget build(BuildContext context) {

    final ProductProvider _productProvider = Provider.of<ProductProvider>(context);

    final ProductModel _currentProduct = _productProvider.products.firstWhere((element) => element.codi == image.codi);

    _currentProduct.indexview ++;
    _currentProduct.uniqueId = '${_currentProduct.codi}-${this.pagename}-${_currentProduct.indexview}';
    final screenSize = MediaQuery.of(context).size;

    final Widget productCard =  Container(
      child: Column(
        children: <Widget>[
          Hero(
            tag: _currentProduct.uniqueId,
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
//        Navigator.pushNamed(context, '/product_detail',arguments:  _currentProduct );
//        locator<NavigationService>().navigateToDetail(_currentProduct);
        Navigator.push(context, FadeRoute( page: ProductDetailPage(detailProduct: _currentProduct,) ) );
      },
    );
  }
}

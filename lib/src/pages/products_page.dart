import 'package:flutter/material.dart';
import 'package:gustolact/src/providers/product_provider.dart';
import 'package:gustolact/src/widgets/products_cards.dart';
import 'package:provider/provider.dart';

class HomeProductsPage extends StatefulWidget {
  @override
  _HomeIndexPageState createState() => _HomeIndexPageState();
}

class _HomeIndexPageState extends State<HomeProductsPage>
    with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);


    return (_productProvider.mainLoading)
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : RefreshIndicator(
            onRefresh: _productProvider.refreshProducts,
            child: ListProducts(products: _productProvider.products,),
          );
  }

  @override
  bool get wantKeepAlive => true;
}

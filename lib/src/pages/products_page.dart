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

    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);


    return (productProvider.loading)
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : RefreshIndicator(
            onRefresh: productProvider.refreshProducts,
            child: ListProducts(products: productProvider.products,),
          );
  }



  @override
  bool get wantKeepAlive => true;
}

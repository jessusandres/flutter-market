import 'package:flutter/material.dart';
import 'package:gustolact/src/models/product_model.dart';
import 'package:gustolact/src/providers/home_provider.dart';
import 'package:gustolact/src/providers/product_provider.dart';
import 'package:provider/provider.dart';

class HomeProductsPage extends StatefulWidget {
  @override
  _HomeIndexPageState createState() => _HomeIndexPageState();
}

class _HomeIndexPageState extends State<HomeProductsPage> with AutomaticKeepAliveClientMixin  {
  @override
  Widget build(BuildContext context) {

    final orientation = MediaQuery.of(context).orientation;
    final ProductProvider productProvider = Provider.of<ProductProvider>(context);
    HomeProvider homeProvider = Provider.of<HomeProvider>(context);

    return (productProvider.loading) ? Container(child: Center(child: CircularProgressIndicator(),),) :
    RefreshIndicator(
      onRefresh: productProvider.refreshProducts,
      child: GridView.count(
          physics: BouncingScrollPhysics(),
          childAspectRatio: (orientation == Orientation.landscape) ? 1.3 : 1,
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 20,
          mainAxisSpacing: 26,
          crossAxisCount: (orientation == Orientation.landscape) ? 3 : 2,
          children: _storeCards(context, productProvider.products)),
    );
  }

  List<Widget> _storeCards(BuildContext context, List<ProductModel> products) {

    List<Widget> storeCards = new List();

    products.forEach((product) {
      product.uniqueId = product.codi + 'hm';
      final container = Container(
          padding: EdgeInsets.all(6.0),
          width: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black45,
                    blurRadius: 15,
                    offset: Offset(2.0, 12.0),
                    spreadRadius: 0.01
                )
              ]),
//          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0)),
                child: Hero(
                  tag: product.uniqueId,
                  child: FadeInImage(
                    fadeInDuration: Duration(milliseconds: 50),
                    width: double.infinity,
                    placeholder: AssetImage('assets/img/loading.gif'),
                    image: NetworkImage(product.getImage()),
                    fit: BoxFit.cover,
                    height: 100.0,
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.3),
                child: Center(
                    child: Text(
                      product.getName(),
                      overflow: TextOverflow.fade,
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      textAlign: TextAlign.center,
                    )),
              ),
            ],
          )
      );


      storeCards.add(GestureDetector(
        child: container,
        onTap: () {
//          Navigator.of(context).pushNamed('productDetail', arguments:  product );
          Navigator.pushNamed(context, '/product_detail',arguments:  product );
        },
      ));
    });

    return storeCards;
  }

  @override
  bool get wantKeepAlive => true;
}

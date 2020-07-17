import 'package:flutter/material.dart';
import 'package:gustolact/src/models/product_model.dart';

class ListProducts extends StatelessWidget {

  final List<ProductModel> products;

  const ListProducts({@required this.products});
  @override
  Widget build(BuildContext context) {

    final orientation = MediaQuery.of(context).orientation;

    List<Widget> storeCards = new List();

    products.forEach((product) {
      product.uniqueId = product.codi + 'home';
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
                    spreadRadius: 0.01)
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
                    placeholder: AssetImage('assets/gif/loading.gif'),
                    image: NetworkImage(product.getImage()),
                    fit: BoxFit.cover,
                    height: 100.0,
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.3),
                    child: Text(
                      product.name,
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  )
              ),
            ],
          ));

      storeCards.add(GestureDetector(
        child: container,
        onTap: () {
//          Navigator.of(context).pushNamed('productDetail', arguments:  product );
          Navigator.pushNamed(context, '/product_detail', arguments: product);
        },
      ));
    });

    return GridView.count(
        physics: BouncingScrollPhysics(),
        childAspectRatio:
        (orientation == Orientation.landscape) ? 1.3 : 1,
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 20,
        mainAxisSpacing: 26,
        crossAxisCount: (orientation == Orientation.landscape) ? 3 : 2,
        children: storeCards
    );
  }
}



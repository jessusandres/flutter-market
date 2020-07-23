import 'package:flutter/material.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/config/key.dart';
import 'package:gustolact/src/providers/search_provider.dart';
import 'package:provider/provider.dart';

class FilterListProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final orientation = MediaQuery
        .of(context)
        .orientation;

    List<Widget> storeCards = new List();

    final SearchProvider _searchProvider = Provider.of<SearchProvider>(context);

    if(_searchProvider.loadQuery){
      _searchProvider.filterProducts();
    }

    final items = _searchProvider.filterResults;
    print(_searchProvider.loadQuery);

    if (_searchProvider.loadQuery) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    _searchProvider.loadQuery = true;

    if(items.length == 0) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        alignment: Alignment.topCenter,
        child: Text(
          'Ups :(  no pudimos encontrar el producto que necesitas, intenta realizar otra búsqueda',
          style: TextStyle(fontSize: 20),
        ),
      );
    }

    items.forEach((product) {
      product.uniqueId = product.codi + 'results';
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
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  )),
            ],
          ));

      storeCards.add(GestureDetector(
        child: container,
        onTap: () {

          locator<NavigationService>().navigateToDetail(product);
        },
      ));
    });

    return Scaffold(
      body: GridView.count(
          physics: BouncingScrollPhysics(),
          childAspectRatio:
          (orientation == Orientation.landscape) ? 1.3 : 1,
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 20,
          mainAxisSpacing: 26,
          crossAxisCount: (orientation == Orientation.landscape) ? 3 : 2,
          children: storeCards
      ),
    );

  }
}

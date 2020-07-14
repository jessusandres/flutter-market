import 'package:flutter/material.dart';
import 'package:gustolact/src/search/products_search.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          icon: Icon(Icons.search),
          onPressed: (){
            showSearch(context: context, delegate: ProductsSearch());
          },
        ),
      ),
    );
  }
}

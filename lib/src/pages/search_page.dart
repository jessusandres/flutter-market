import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:gustolact/src/providers/search_provider.dart';
import 'package:gustolact/src/search/products_search.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //showSearch(context: context, delegate: ProductsSearch());
  @override
  Widget build(BuildContext context) {
    SearchProvider searchProvider = Provider.of<SearchProvider>(context);
    searchProvider.getBrands();

    return ChangeNotifierProvider(
      create: (_) => new SearchProvider(),
      child: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Color.fromRGBO(188, 188, 188, 0.1),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 25),
//                    color: Colors.red,
                      child: Text(
                        'BUSCAR',
                        style: TextStyle(
                            fontSize: FontSize.large.size,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        searchProvider.showBottomButton = true;
                        showSearch(
                            context: context, delegate: ProductsSearch());
                      },
                      child: Container(
                        color: Color.fromRGBO(188, 188, 188, 0.0),
                        padding:
                            EdgeInsets.symmetric(vertical: 25, horizontal: 18),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: <Widget>[
                            Container(child: Icon(Icons.search)),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                  'Encuentra productos que te interesen..'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

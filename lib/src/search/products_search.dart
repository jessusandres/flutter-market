import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/models/product_model.dart';
import 'package:gustolact/src/providers/product_provider.dart';
import 'package:gustolact/src/providers/search_provider.dart';
import 'package:gustolact/src/widgets/filter_list_products.dart';
import 'package:gustolact/src/widgets/modal_bottom_filter.dart';
import 'package:gustolact/src/widgets/sugerences_list.dart';
import 'package:provider/provider.dart';

class ProductsSearch extends SearchDelegate {

  bool showButtom = false;

  @override
  List<Widget> buildActions(BuildContext context) {

    SearchProvider searchProvider = Provider.of<SearchProvider>(context);

    //acciones del appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if(searchProvider.query.trim().length == 0) Navigator.pop(context);
          searchProvider.reset();
          showButtom = false;
          query = '';
        },
      ),
      showButtom ? IconButton(
        icon: Icon(Icons.format_list_bulleted),
        onPressed: (){
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return ModalBottomFilter();
            },
          );
        },
      ) : Container(),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {


    SearchProvider searchProvider = Provider.of<SearchProvider>(context);
    //icono de inicio(izquierda del appbar)
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        searchProvider.reset();
        query = '';
        close(context, null);
      },
    );
  }


  @override
  Widget buildResults(BuildContext context) {

    showButtom = true;

    SearchProvider searchProvider = Provider.of<SearchProvider>(context);
    searchProvider.query = query;



    return Container(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 26, top: 27),
            child: Text('Resultados de la búsqueda: ', style: TextStyle(fontSize: FontSize.large.size, fontWeight: FontWeight.bold),),
          ),
          Expanded(
              child: FilterListProducts()
          ),
        ]
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // sugerencias que aparecen cuando escribe
    SearchProvider searchProvider = Provider.of<SearchProvider>(context);
    ProductProvider productProvider = Provider.of<ProductProvider>(context);

    if (query.isEmpty) {
      searchProvider.sugerences = [];
      return Container();
    }

    if(query != searchProvider.query) {
      searchProvider.sugerences = [];
    }

    return FutureBuilder(
      future: searchProvider.filterByName(query, productProvider),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.hasData) {
          final items = snapshot.data;
          return SugerencesList(items: items);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  String get searchFieldLabel => "Buscar en $storeName";
}



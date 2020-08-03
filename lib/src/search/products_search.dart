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
    final SearchProvider _searchProvider = Provider.of<SearchProvider>(context);

    //acciones del appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (_searchProvider.query.trim().length == 0) Navigator.pop(context);
          _searchProvider.reset();
          showButtom = false;
          query = '';
        },
      ),
      IconButton(
        icon: Icon(Icons.format_list_bulleted),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
//            isScrollControlled: true,
            builder: (BuildContext context) {
              return ModalBottomFilter(
                searchContext: context,
                callToShow: showResults,
              );
            },
          );
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    final SearchProvider _searchProvider = Provider.of<SearchProvider>(context);
    //icono de inicio(izquierda del appbar)
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        _searchProvider.reset();
        query = '';
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    showButtom = true;

    final SearchProvider _searchProvider = Provider.of<SearchProvider>(context);
    _searchProvider.query = query;
    return HomeSearch();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // sugerencias que aparecen cuando escribe
    final SearchProvider _searchProvider = Provider.of<SearchProvider>(context);
    final ProductProvider _productProvider = Provider.of<ProductProvider>(context);

    if (query.isEmpty) {
      _searchProvider.sugerences = [];
      return Container();
    }

    if (query != _searchProvider.query) {
      _searchProvider.sugerences = [];
    }

    return FutureBuilder(
      future: _searchProvider.filterByName(query, _productProvider),
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

class HomeSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 26, top: 27, bottom: 20),
          child: Text(
            'Resultados de la búsqueda: ',
            style: TextStyle(
                fontSize: FontSize.large.size, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: FilterListProducts()),
      ]),
    );
  }
}

class SearchResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Container(
          child: Text('results'),
        ),
      ),
    );
  }
}

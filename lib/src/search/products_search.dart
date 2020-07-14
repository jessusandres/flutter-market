import 'package:flutter/material.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/models/product_model.dart';
import 'package:gustolact/src/providers/main_provider.dart';
import 'package:gustolact/src/providers/product_provider.dart';
import 'package:gustolact/src/providers/search_provider.dart';
import 'package:provider/provider.dart';

class ProductsSearch extends SearchDelegate {
  final movies = [
    'Linterna Verda',
    'At-man',
    'Iron-Man',
    'Avengers',
    'Thor',
    'Dark'
  ];
  final recents = ['Spiderman Home Coming', 'Capitán América'];

  String selection = '';

//  final MoviesProvider moviesProvider = new MoviesProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    //acciones del appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //icono de inicio(izquierda del appbar)
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // builder que crea los resultados
    MainProvider mainProvider = Provider.of<MainProvider>(context);
    mainProvider.indexPage = 1;
    return Center(
      child: Container(
        height: 100,
        width: 100,
        color: Colors.deepPurple,
        child: Text(selection),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // sugerencias que aparecen cuando escribe
    SearchProvider searchProvider = Provider.of<SearchProvider>(context);
    ProductProvider productProvider = Provider.of<ProductProvider>(context);

//    final sugerenceList = (query.isEmpty) ? recents : movies.where((element) => element.toLowerCase().startsWith(query.toLowerCase())).toList();
//
//    return ListView.builder(
//      itemCount: sugerenceList.length,
//      itemBuilder: (BuildContext context, int index){
//        return ListTile(
//          leading: Icon(Icons.movie),
//          title: Text(sugerenceList[index]),
//          onTap: (){
//            selection =  sugerenceList[index];
//            showResults(context);
//          },
//        );
//      },
//    );

//https://api.flutter.dev/flutter/material/showModalBottomSheet.html
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
          return ListView(
            children: items.map((item) {
              item.uniqueId = '${item.codi}-search';
              return ListTile(
                leading: Hero(
                  tag: item.uniqueId,
                  child: FadeInImage(
                    placeholder: AssetImage('assets/gif/loading.gif'),
                    image: NetworkImage(item.getImage()),
                    width: 50.0,
                    fit: BoxFit.contain,
                  ),
                ),
                title: Text(item.name),
                subtitle: Text(item.brand),
                onTap: () {
                  searchProvider.query = query;
                  searchProvider.sugerences = items;
                  Navigator.pushNamed(context, 'product_detail',
                      arguments: item);
                },
              );
            }).toList(),
          );
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/models/product_model.dart';
import 'package:gustolact/src/providers/main_provider.dart';
import 'package:gustolact/src/providers/product_provider.dart';
import 'package:gustolact/src/providers/search_provider.dart';
import 'package:gustolact/src/themes/theme.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
    SearchProvider searchProvider = Provider.of<SearchProvider>(context);
    print("query ${searchProvider.query}");
    //acciones del appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          searchProvider.query = '';
          query = '';
        },
      ),
      searchProvider.query.trim().length > 0 ? IconButton(
        icon: Icon(Icons.format_list_bulleted),
        onPressed: (){

          showModalBottomSheet<void>(
            context: context,
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
//    MainProvider mainProvider = Provider.of<MainProvider>(context);
//    mainProvider.indexPage = 1;
//    SearchProvider searchProvider = Provider.of<SearchProvider>(context);
    SearchProvider searchProvider = Provider.of<SearchProvider>(context);
    searchProvider.query = query;
    return Center(
      child: Container(
        height: 100,
        width: 100,
        child: Text("RESULTF OF ${searchProvider.query}"),
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
//                  searchProvider.query = query;
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

class ModalBottomFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SearchProvider searchProvider = Provider.of<SearchProvider>(context);

    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.8,
      color: Colors.white38,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.close),
                onPressed: ()=>Navigator.pop(context),
              ),
              Container(
                child: Text('Filtros', style: TextStyle(fontSize: FontSize.xLarge.size, fontWeight: FontWeight.bold),),
              ),
            ],
          ),
          Divider(),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 17),
            child: Text('Ordenar por', style: TextStyle(fontSize: FontSize.large.size),),
          ),
          Row(
            children: <Widget>[
              SizedBox(width: 13,),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.deepOrangeAccent)
                ),
                child: Text('Menor Precio', style: TextStyle(color: Colors.deepOrangeAccent),),
                onPressed: (){},
              ),
              SizedBox(width: 25,),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.deepOrangeAccent)
                ),
                child: Text('Mayor Precio', style: TextStyle(color: Colors.deepOrangeAccent),),
                onPressed: (){},
              ),

            ],
          ),
          SizedBox(height: 15,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18),
            alignment: Alignment.centerLeft,
            child: Text('Ordenar por', style: TextStyle(fontSize: FontSize.large.size),),
          ),
          SizedBox(height: 8,),
          Expanded(
            child: ListView(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, 'filter', arguments: 'line');
                  },
                  child: Container(
                    child: Text('Linea', style: TextStyle(fontSize: FontSize.large.size, fontWeight: FontWeight.w400),),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    if(searchProvider.lineSelected == '0') {
                      Alert(context: context, title: "UPS", desc: "Debes seleccionar una Linea", buttons: []).show();
                      return;
                    }
                    Navigator.pushNamed(context, 'filter', arguments: 'subline');
                  },
                  child: Container(
                    child: Text('Sub Linea', style: TextStyle(fontSize: FontSize.large.size, fontWeight: FontWeight.w400),),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, 'filter', arguments: 'brand');
                    print('brand');
                  },
                  child: Container(
                    child: Text('Marca', style: TextStyle(fontSize: FontSize.large.size, fontWeight: FontWeight.w400),),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:gustolact/src/models/filter_model.dart';
import 'package:gustolact/src/providers/search_provider.dart';
import 'package:provider/provider.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  @override
  Widget build(BuildContext context) {
    final SearchProvider _searchProvider = Provider.of<SearchProvider>(context);

    final type = ModalRoute.of(context).settings.arguments;

    List<FilterModel> filters = [];
    String filterName;
    String filterSelected;

    switch (type) {

      case 'lines':

        filterName = 'Lineas';
        filterSelected = _searchProvider.lineSelected;
        _searchProvider.getLines();
        filters = _searchProvider.lines;
        break;

      case 'sublines':

        filterName = 'Sub Lineas';
        filterSelected = _searchProvider.subLineSelected;
        _searchProvider.getSubLines(_searchProvider.lineSelected);
        filters = _searchProvider.sublines;
        break;

      default:

        filterName = 'Marcas';
        filterSelected = _searchProvider.brandSelected;
        _searchProvider.getBrands();
        filters = _searchProvider.brands;
        break;

    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white60,
          elevation: 0,
          title: Text('Filtros avanzados', style: TextStyle(color: Colors.black54),),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black54,
            ),
            onPressed: () => Navigator.pop(context),
          )),
      body: filters.length > 0 ? Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 20),
              child: Text(
                '$filterName disponibles: ',
                style: TextStyle(
                    fontSize: FontSize.large.size, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: filters.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        Container(
                          padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                          child: CheckboxListTile(
                            value: (filterSelected == filters[index].code),
                            subtitle: (filterSelected == filters[index].code)
                                ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1, vertical: 6),
                              child: Text(
                                  'Filtro que se aplicará a la búsqueda'),
                            )
                                : Container(),
                            title: Text(filters[index].name),
                            onChanged: (bool value) {
                              print("tap");
                              String code;
                              (value) ? code = filters[index].code : code = '0';

                              switch (type) {
                                case 'lines':
                                  _searchProvider.lineSelected = code;
                                  _searchProvider.subLineSelected = '0';
                                  _searchProvider.sublines = [];
                                  break;
                                case 'sublines':
                                  _searchProvider.subLineSelected = code;
                                  break;
                                default:
                                  _searchProvider.brandSelected = code;
                                  break;
                              }
                            },
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  }),
            )
          ],
        ),
      ) : Container(child: Center(child: CircularProgressIndicator(),),),
    );
  }
}

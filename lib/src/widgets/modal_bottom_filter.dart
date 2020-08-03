import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:gustolact/src/providers/search_provider.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ModalBottomFilter extends StatelessWidget {
  final BuildContext searchContext;
  final Function callToShow;

  const ModalBottomFilter(
      {@required this.searchContext, @required this.callToShow});

  @override
  Widget build(BuildContext context) {
    final SearchProvider _searchProvider = Provider.of<SearchProvider>(context);

    return SafeArea(
      child: Container(
        color: Colors.white38,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                Container(
                  child: Text(
                    'Filtros',
                    style: TextStyle(
                        fontSize: FontSize.xLarge.size,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Container(
                      padding: EdgeInsets.only(right: 10),
                      alignment: Alignment.centerRight,
//                  color: Colors.red,
                      child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          textColor: Colors.deepOrange,
                          child: Text(
                            'Limpiar',
                            style:
                                TextStyle(fontSize: FontSize.xLarge.size - 1),
                          ),
                          onPressed: _searchProvider.resetFilters)),
                ),
              ],
            ),
            Divider(),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 17),
              child: Text(
                'Ordenar por',
                style: TextStyle(fontSize: FontSize.large.size),
              ),
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 13,
                ),
                FlatButton(
                  color: (_searchProvider.order == 1)
                      ? AppTheme.primaryColor
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(
                          color: (_searchProvider.order == 1)
                              ? Colors.white
                              : AppTheme.primaryColor)),
                  child: Text(
                    'Menor Precio',
                    style: TextStyle(
                        color: (_searchProvider.order == 1)
                            ? Colors.white
                            : AppTheme.primaryColor),
                  ),
                  onPressed: () {
                    _searchProvider.order = 1;
                  },
                ),
                SizedBox(
                  width: 25,
                ),
                FlatButton(
                  color: (_searchProvider.order == 2)
                      ? AppTheme.primaryColor
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(
                          color: (_searchProvider.order == 2)
                              ? Colors.white
                              : AppTheme.primaryColor)),
                  child: Text(
                    'Mayor Precio',
                    style: TextStyle(
                        color: (_searchProvider.order == 2)
                            ? Colors.white
                            : AppTheme.primaryColor),
                  ),
                  onPressed: () {
                    _searchProvider.order = 2;
                  },
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.centerLeft,
              child: Text(
                'Ordenar por',
                style: TextStyle(fontSize: FontSize.large.size),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, 'filter',
                          arguments: 'lines');
                    },
                    trailing: Icon(Icons.arrow_forward_ios),
                    title: Container(
                      child: Text(
                        'Linea',
                        style: TextStyle(
                            fontSize: FontSize.large.size,
                            fontWeight: FontWeight.w400),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      if (_searchProvider.lineSelected == '0') {
                        Alert(
                                context: context,
                                title: "UPS",
                                desc: "Debes seleccionar una Linea",
                                buttons: [],
                                closeFunction: () {})
                            .show();
                        return;
                      }
                      Navigator.pushNamed(context, 'filter',
                          arguments: 'sublines');
                    },
                    trailing: Icon(Icons.arrow_forward_ios),
                    title: Container(
                      child: Text(
                        'Sub Linea',
                        style: TextStyle(
                            fontSize: FontSize.large.size,
                            fontWeight: FontWeight.w400),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, 'filter',
                          arguments: 'brands');
                      print('brand');
                    },
                    trailing: Icon(Icons.arrow_forward_ios),
                    title: Container(
                      child: Text(
                        'Marca',
                        style: TextStyle(
                            fontSize: FontSize.large.size,
                            fontWeight: FontWeight.w400),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                width: double.infinity,
                child: (_searchProvider.showBottomButton)
                    ? FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        textColor: Colors.white,
                        color: AppTheme.primaryColor,
                        child: Text(
                          'Aplicar Filtros',
                          style: TextStyle(fontSize: FontSize.xLarge.size - 1),
                        ),
                        onPressed: () {
                          if (_searchProvider.brandSelected == '0' &&
                              _searchProvider.lineSelected == '0' &&
                              _searchProvider.subLineSelected == '0') {
                            print('returned of search');
                            return;

                          }
                          Navigator.pop(context);
                          this.callToShow(this.searchContext);
                        })
                    : Container())
          ],
        ),
      ),
    );
  }
}

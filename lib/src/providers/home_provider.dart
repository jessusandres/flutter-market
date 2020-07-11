import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gustolact/src/models/shorcut_model.dart';
import 'package:gustolact/src/pages/products_page.dart';
import 'package:gustolact/src/pages/unavaliable_page.dart';

class HomeProvider with ChangeNotifier{

  int _currentTabIndex = 0;
  int get currentTabIndex => this._currentTabIndex;
  set currentTabIndex(int index) {
    this._currentTabIndex = index;
    notifyListeners();
  }



  List<ShorcutModel> shorcuts = [
    ShorcutModel(icon: FontAwesomeIcons.building, name: 'Productos', tabpage: HomeProductsPage(), index: 0),
    ShorcutModel(icon: FontAwesomeIcons.tv, name: 'Categorías', tabpage: UnavaiablePage(), index: 1),
    ShorcutModel(icon: FontAwesomeIcons.addressCard, name: 'Tiendas', tabpage: UnavaiablePage(), index: 2),
    ShorcutModel(icon: FontAwesomeIcons.heart, name: 'Productos', tabpage: UnavaiablePage(), index: 3),
    ShorcutModel(icon: FontAwesomeIcons.lock, name: 'Other', tabpage: UnavaiablePage(), index: 4),
  ];


}
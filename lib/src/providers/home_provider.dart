import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gustolact/src/models/shorcut_model.dart';
import 'package:gustolact/src/pages/products_page.dart';
import 'package:gustolact/src/pages/offers_page.dart';

class HomeProvider with ChangeNotifier{

  int _currentTabIndex = 0;
  int get currentTabIndex => this._currentTabIndex;
  set currentTabIndex(int index) {
    this._currentTabIndex = index;
    notifyListeners();
  }

  bool _anotherPage = false;
  bool get anotherPage => this._anotherPage;
  set anotherPage(bool val) {
    this._anotherPage = val;
    notifyListeners();
  }



  List<ShorcutModel> shorcuts = [
    ShorcutModel(icon: FontAwesomeIcons.building, name: 'Productos', tabpage: HomeProductsPage(), index: 0),
    ShorcutModel(icon: FontAwesomeIcons.tv, name: 'Ofertas y Novedades', tabpage: OffersPage(), index: 1),
  ];


}
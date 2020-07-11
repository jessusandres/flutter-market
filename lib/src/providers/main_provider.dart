import 'package:flutter/material.dart';
import 'package:gustolact/src/navigators/home_navigator.dart';
import 'package:gustolact/src/pages/categories_page.dart';
import 'package:gustolact/src/pages/search_page.dart';
import 'package:gustolact/src/pages/unavaliable_page.dart';

class MainProvider with ChangeNotifier {

  GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get homeNavigatorKey => this._homeNavigatorKey;

  int _currentIndexPage = 0;

  int get indexPage => this._currentIndexPage;

  set indexPage(int index) {
    this._currentIndexPage = index;
    notifyListeners();
  }

  List<Widget> pages = [
    HomeNavigator(),
    SearchPage(),
    CategoriePage(),
    UnavaiablePage(),
  ];
}

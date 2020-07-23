import 'package:flutter/material.dart';
import 'package:gustolact/src/navigators/home_navigator.dart';
import 'package:gustolact/src/pages/cart_page.dart';
import 'package:gustolact/src/pages/please_login_page.dart';
import 'package:gustolact/src/pages/search_page.dart';
import 'package:gustolact/src/pages/unavaliable_page.dart';
import 'package:gustolact/src/providers/login_provider.dart';
import 'package:provider/provider.dart';

class MainProvider with ChangeNotifier {

  GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get homeNavigatorKey => this._homeNavigatorKey;

  int _currentIndexPage = 0;

  int get indexPage => this._currentIndexPage;

  set indexPage(int index) {
    this._currentIndexPage = index;
    notifyListeners();
  }

  int _currentDrawerPage = 0;

  int get drawerPage => this._currentDrawerPage;

  set drawerPage(int index) {
    this._currentDrawerPage = index;
    notifyListeners();
  }

  List<Widget> getPages(BuildContext context) {

    final pages = [
      HomeNavigator(),
      SearchPage(),
      UnavaiablePage()
    ];

    final LoginProvider _loginProvider = Provider.of<LoginProvider>(context);

    if(_loginProvider.isLogged) {
      pages.add(CartPage());
    }else {
      pages.add(PleaseLoginPage());
    }

    return pages;
  }
}

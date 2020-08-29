import 'package:flutter/material.dart';
import 'package:gustolact/src/navigators/home_navigator.dart';
import 'package:gustolact/src/pages/drawer_pages/orders_page.dart';
import 'package:gustolact/src/pages/drawer_pages/profile_page.dart';
import 'package:gustolact/src/pages/drawer_pages/shared_page.dart';
import 'package:gustolact/src/pages/filter_page.dart';
import 'package:gustolact/src/pages/main_page.dart';

final mainRoutes = {
  '/': (BuildContext context) => Builder(builder: (BuildContext context) {
    return MainPage(mainContext: context);
  },),
  'home': (BuildContext context) => HomeNavigator(),
  'profile': (BuildContext context) => ProfilePage(),
  'orders': (BuildContext context) => OrdersPage(),
  'settings': (BuildContext context) => SharedPage(),
  'filter': (BuildContext context) => FilterPage(),
};

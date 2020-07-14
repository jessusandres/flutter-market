import 'package:flutter/material.dart';
import 'package:gustolact/src/navigators/home_navigator.dart';
import 'package:gustolact/src/pages/drawer_pages/cotizations_page.dart';
import 'package:gustolact/src/pages/drawer_pages/profile_page.dart';
import 'package:gustolact/src/pages/drawer_pages/shared_page.dart';
import 'package:gustolact/src/pages/main_page.dart';
import 'package:gustolact/src/pages/product_detail_page.dart';

final mainRoutes = {
  '/': (BuildContext context) => MainPage(),
  'home': (BuildContext context) => HomeNavigator(),
  'profile': (BuildContext context) => ProfilePage(),
  'cotizations': (BuildContext context) => CotizationsPage(),
  'settings': (BuildContext context) => SharedPage(),
  'product_detail': (BuildContext context) => ProductDetailPage(),
};

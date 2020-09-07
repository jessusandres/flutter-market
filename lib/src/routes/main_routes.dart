import 'package:flutter/material.dart';
import 'package:gustolact/src/navigators/home_navigator.dart';
import 'package:gustolact/src/pages/drawer_pages/orders_page.dart';
import 'package:gustolact/src/pages/drawer_pages/profile_page.dart';
import 'package:gustolact/src/pages/drawer_pages/shared_page.dart';
import 'package:gustolact/src/pages/filter_page.dart';
import 'package:gustolact/src/pages/main_page.dart';

final mainRoutes = {
  '/': (_) => MainPage(),
  'home': (_) => HomeNavigator(),
  'profile': (_) => ProfilePage(),
  'orders': (_) => OrdersPage(),
  'shared': (_) => SharedPage(),
  'filter': (_) => FilterPage(),
};

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gustolact/src/pages/home_page.dart';
import 'package:gustolact/src/pages/unavaliable_page.dart';
import 'package:gustolact/src/providers/main_provider.dart';
import 'package:gustolact/src/widgets/appbar_widget.dart';
import 'package:gustolact/src/widgets/drawer_widget.dart';
import 'package:provider/provider.dart';

class HomeNavigator extends StatefulWidget {
  @override
  _HomeNavigatorState createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
//        statusBarColor: Color.fromRGBO(52, 54, 101, 0.0),
//        statusBarIconBrightness: Brightness.light));

    super.build(context);


    final MainProvider _mainProvider = Provider.of<MainProvider>(context);

    return Navigator(
      key: _mainProvider.homeNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return CupertinoPageRoute(
            maintainState: true,
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return HomePage();
                default:
                  return Scaffold(
                    drawer: DrawerMarket(),
                    appBar: AppBarMarket(),
                    body: UnavaiablePage(),
                  );
              }
            });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

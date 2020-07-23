import 'package:flutter/material.dart';
import 'package:gustolact/src/pages/home_page.dart';
import 'package:gustolact/src/pages/product_detail_page.dart';
import 'package:gustolact/src/pages/unavaliable_page.dart';
import 'package:gustolact/src/providers/main_provider.dart';
import 'package:gustolact/src/widgets/appbar_widget.dart';
import 'package:gustolact/src/widgets/drawer_widget.dart';
import 'package:provider/provider.dart';

class HomeNavigator extends StatefulWidget {
  @override
  _HomeNavigatorState createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final MainProvider _mainProvider = Provider.of<MainProvider>(context);
    return Navigator(
      key: _mainProvider.homeNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return HomePage();
                default:
                  return Container(
                      child: Scaffold(
                        drawer: DrawerMarket(),
                        appBar: AppBarMarket(),
                        body: UnavaiablePage(),
                  ));
              }
            });
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

//class Books1 extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Column(
//      children: <Widget>[
//        AppBar(
//          title: Text("Books 1"),
//        ),
//        FlatButton(
//          child: Text("Go to books 2"),
//          onPressed: () => Navigator.pushNamed(context, '/books2'),
//        ),
//      ],
//    );
//  }
//}
//
//class Books2 extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    final params = ModalRoute.of(context).settings.arguments;
//
//    print(params);
//
//    return Column(
//      children: <Widget>[
//        AppBar(
//          title: Text("Books 2"),
//        )
//      ],
//    );
//  }
//}

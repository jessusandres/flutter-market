import 'package:flutter/material.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/pages/drawer_pages/cotizations_page.dart';
import 'package:gustolact/src/pages/drawer_pages/profile_page.dart';
import 'package:gustolact/src/pages/drawer_pages/settings_page.dart';
import 'package:gustolact/src/pages/home_page.dart';
import 'package:gustolact/src/pages/product_detail_page.dart';
import 'package:gustolact/src/pages/unavaliable_page.dart';
import 'package:gustolact/src/providers/main_provider.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:gustolact/src/widgets/menu_widget.dart';
import 'package:provider/provider.dart';

class HomeNavigator extends StatefulWidget {
  @override
  _HomeNavigatorState createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  @override
  Widget build(BuildContext context) {
    MainProvider mainProvider = Provider.of<MainProvider>(context);
    return Navigator(
      key: mainProvider.homeNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return Container(
                      child: Scaffold(
                        drawer: MenuWidget(),
                        appBar: AppBar(
                          centerTitle: true,
                          backgroundColor: Colors.deepOrangeAccent,
                          title: Text(storeName),
                        ),
                        body: HomePage(),
                      ));
                case '/product_detail':
                  return ProductDetailPage();
                case 'profile':
                  return Container(
                      child: Scaffold(
                        drawer: MenuWidget(),
                        appBar: AppBar(
                          centerTitle: true,
                          backgroundColor: Colors.deepOrangeAccent,
                          title: Text(storeName),
                        ),
                        body: ProfilePage(),
                  ));
                case 'cotizations':
                  return Container(
                      child: Scaffold(
                        drawer: MenuWidget(),
                        appBar: AppBar(
                          centerTitle: true,
                          backgroundColor: Colors.deepOrangeAccent,
                          title: Text(storeName),
                        ),
                        body: CotizationsPage(),
                  ));
                case 'settings':
                  return Container(
                      child: Scaffold(
                        drawer: MenuWidget(),
                        appBar: AppBar(
                          centerTitle: true,
                          backgroundColor: Colors.deepOrangeAccent,
                          title: Text(storeName),
                        ),
                        body: SettingsPage(),
                  ));
                default:
                  return Container(
                      child: Scaffold(
                        drawer: MenuWidget(),
                        appBar: AppBar(
                          centerTitle: true,
                          backgroundColor: Colors.deepOrangeAccent,
                          title: Text(storeName),
                        ),
                        body: UnavaiablePage(),
                  ));
              }
            });
      },
    );
  }
}

class Books1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          title: Text("Books 1"),
        ),
        FlatButton(
          child: Text("Go to books 2"),
          onPressed: () => Navigator.pushNamed(context, '/books2'),
        ),
      ],
    );
  }
}

class Books2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final params = ModalRoute.of(context).settings.arguments;

    print(params);

    return Column(
      children: <Widget>[
        AppBar(
          title: Text("Books 2"),
        )
      ],
    );
  }
}

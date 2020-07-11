import 'package:flutter/material.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/pages/home_page.dart';
import 'package:gustolact/src/pages/product_detail_page.dart';
import 'package:gustolact/src/pages/unavaliable_page.dart';
import 'package:gustolact/src/providers/main_provider.dart';
import 'package:gustolact/src/widgets/menu_widget.dart';
import 'package:gustolact/src/widgets/title_text.dart';
import 'package:provider/provider.dart';

class HomeNavigator extends StatefulWidget {
  @override
  _HomeNavigatorState createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  @override
  Widget build(BuildContext context) {
    MainProvider homeProvider = Provider.of<MainProvider>(context);
    return Navigator(
      key: homeProvider.homeNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              print(settings.name);
              switch (settings.name) {
                case '/':
                  return Scaffold(
                    drawer: MenuWidget(),
                      appBar: AppBar(
                          title: TitleText(
                            text: storeName,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          )
                      ),
                      body: HomePage()
                  );
                case '/product_detail':
                  return ProductDetailPage();
                default:
                  return UnavaiablePage();
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

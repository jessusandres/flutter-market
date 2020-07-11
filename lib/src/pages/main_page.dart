import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:gustolact/src/providers/main_provider.dart';
import 'package:gustolact/src/providers/product_provider.dart';
import 'package:gustolact/src/widgets/bottombar_widget.dart';
import 'package:gustolact/src/widgets/fade_in_stack.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  List<GlobalKey<NavigatorState>> _navigatorKeys;

  Future<bool> _systemBackButtonPressed() {
    if (_navigatorKeys[_selectedIndex].currentState.canPop()) {
      _navigatorKeys[_selectedIndex]
          .currentState
          .pop(_navigatorKeys[_selectedIndex].currentContext);
    } else {
      SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    }
  }

  @override
  Widget build(BuildContext context) {
    MainProvider mainProvider = Provider.of<MainProvider>(context);
    ProductProvider productProvider = Provider.of<ProductProvider>(context);

    this._navigatorKeys = [
      mainProvider.homeNavigatorKey,
//      _coffeeNavigatorKey,
    ];

    return (productProvider.mainLoading)
        ? _mcontainer(productProvider.mainLoading)
        : WillPopScope(
            onWillPop: _systemBackButtonPressed,
            child: Scaffold(
//        bottomNavigationBar: BottomNavigationBar(
//            items: <BottomNavigationBarItem>[
//              BottomNavigationBarItem(
//                icon: Icon(Icons.book),
//                title: Text("Home"),
//              ),
//              BottomNavigationBarItem(
//                icon: Icon(Icons.free_breakfast),
//                title: Text("Search"),
//              )
//            ],
//            currentIndex: _selectedIndex,
//            onTap: (int index) {
//              setState(() {
//                _selectedIndex = index;
//              });
//            }),
              bottomNavigationBar: CustomBottomNavigationBar(),
              body: SafeArea(
                top: false,
                child: FadeIndexedStack(
                  index: mainProvider.indexPage,
                  children: mainProvider.pages,
//            children: <Widget>[
//              HomeNavigator(),
//              CoffeeNavigator(),
//            ],
                ),
              ),
            ),
          );
  }

  Widget _mcontainer(bool loading) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: loading ? 1.0 : 0.0,
          child: Container(
            child: Center(
              child: Image(
                image: AssetImage('assets/img/progress.gif'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CoffeeNavigator extends StatefulWidget {
  @override
  _CoffeeNavigatorState createState() => _CoffeeNavigatorState();
}

GlobalKey<NavigatorState> _coffeeNavigatorKey = GlobalKey<NavigatorState>();

class _CoffeeNavigatorState extends State<CoffeeNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _coffeeNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return Coffee1();
                case '/coffee2':
                  return Coffee2();
              }
            });
      },
    );
  }
}

class Coffee1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          title: Text("Coffee 1"),
        ),
        FlatButton(
          child: Text("Go to coffee 2"),
          onPressed: () => Navigator.pushNamed(context, '/coffee2'),
        ),
      ],
    );
  }
}

class Coffee2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          title: Text("Coffee 2"),
        ),
      ],
    );
  }
}

import 'dart:async';
import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gustolact/src/custom_drawer/drawer_user_controller.dart';
import 'package:gustolact/src/custom_drawer/home_drawer.dart';
import 'package:gustolact/src/pages/unavaliable_page.dart';
import 'package:gustolact/src/themes/app_theme.dart';
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

  Timer mtimer;

  Future<bool> _systemBackButtonPressed() {
    if (_navigatorKeys[_selectedIndex].currentState.canPop()) {
      _navigatorKeys[_selectedIndex]
          .currentState
          .pop(_navigatorKeys[_selectedIndex].currentContext);
    } else {
      SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    }
  }

  DrawerIndex drawerIndex;
  Widget screenView;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = MyHomePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MainProvider mainProvider = Provider.of<MainProvider>(context);
    ProductProvider productProvider = Provider.of<ProductProvider>(context);

    this._navigatorKeys = [
      mainProvider.homeNavigatorKey,
//      _coffeeNavigatorKey,
    ];

    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 2400),
        transitionBuilder: (Widget child, Animation<double> animation) {
          var begin = Offset(0.3, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        child: (productProvider.mainLoading)
            ? _mcontainer(true)
            : Container(
                color: AppTheme.nearlyWhite,
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Scaffold(
                    backgroundColor: AppTheme.nearlyWhite,
                    body: WillPopScope(
                      onWillPop: _systemBackButtonPressed,
                      child: Scaffold(
                        bottomNavigationBar: CustomBottomNavigationBar(),
                        body: SafeArea(
                          top: false,
                          child: FadeIndexedStack(
                            index: mainProvider.indexPage,
                            children: mainProvider.pages,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
//      WillPopScope(
//        onWillPop: _systemBackButtonPressed,
//        child: Scaffold(
//          bottomNavigationBar: CustomBottomNavigationBar(),
//          body: SafeArea(
//            top: false,
//            child: FadeIndexedStack(
//              index: mainProvider.indexPage,
//              children: mainProvider.pages,
//            ),
//          ),
//        ),
//      ),
        );

    if ((productProvider.mainLoading)) {
      return _mcontainer(productProvider.mainLoading);
    } else {
      return _mcontainer(productProvider.mainLoading);
      return WillPopScope(
        onWillPop: _systemBackButtonPressed,
        child: Scaffold(
          bottomNavigationBar: CustomBottomNavigationBar(),
          body: SafeArea(
            top: false,
            child: FadeIndexedStack(
              index: mainProvider.indexPage,
              children: mainProvider.pages,
            ),
          ),
        ),
      );
    }
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = MyHomePage();
        });
      } else if (drawerIndex == DrawerIndex.Help) {
        setState(() {
          screenView = UnavaiablePage();
        });
      } else if (drawerIndex == DrawerIndex.FeedBack) {
        setState(() {
          screenView = UnavaiablePage();
        });
      } else if (drawerIndex == DrawerIndex.Invite) {
        setState(() {
          screenView = UnavaiablePage();
        });
      } else {
        //do in your way......
      }
    }
  }

  Widget _mcontainer(bool loading) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Container(
          child: Center(
            child: Image(
              image: AssetImage('assets/img/progress.gif'),
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

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MainProvider mainProvider = Provider.of<MainProvider>(context);
    return WillPopScope(
      onWillPop: () {},
//      onWillPop: _systemBackButtonPressed,
      child: Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: SafeArea(
          top: false,
          child: FadeIndexedStack(
            index: mainProvider.indexPage,
            children: mainProvider.pages,
          ),
        ),
      ),
    );
  }
}

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

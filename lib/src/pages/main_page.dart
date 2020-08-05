import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gustolact/src/custom_drawer/home_drawer.dart';
import 'package:gustolact/src/navigators/home_navigator.dart';
import 'package:gustolact/src/providers/login_provider.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:gustolact/src/widgets/appbar_widget.dart';
import 'package:gustolact/src/widgets/drawer_widget.dart';
import 'package:provider/provider.dart';
import 'package:gustolact/src/providers/main_provider.dart';
import 'package:gustolact/src/providers/product_provider.dart';
import 'package:gustolact/src/widgets/bottombar_widget.dart';
import 'package:gustolact/src/widgets/fade_in_stack.dart';

class MainPage extends StatefulWidget {
  final BuildContext mainContext;

  const MainPage({@required this.mainContext});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;

  List<GlobalKey<NavigatorState>> _navigatorKeys;

  Timer mtimer;

  MainProvider _mainProvider;

  Future<bool> _systemBackButtonPressed() {
    if (_navigatorKeys[_selectedIndex].currentState.canPop()) {
      _navigatorKeys[_selectedIndex]
          .currentState
          .pop(_navigatorKeys[_selectedIndex].currentContext);
      return Future.value(true);
    } else {
      if (_mainProvider.indexPage == 0) {
        SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
        return Future.value(false);
      } else {
        _mainProvider.indexPage = 0;
        return Future.value(false);
      }
    }
  }

  DrawerIndex drawerIndex;
  Widget screenView;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = HomeNavigator();
    final LoginProvider loginProvider = Provider.of<LoginProvider>(widget.mainContext, listen: false);
    loginProvider.verifyLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Color.fromRGBO(52, 54, 101, 0.0),
        statusBarIconBrightness: Brightness.light));

    super.build(context);

    _mainProvider = Provider.of<MainProvider>(context);
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);

    this._navigatorKeys = [
      _mainProvider.homeNavigatorKey,
    ];


    return AnimatedSwitcher(
        duration: Duration(milliseconds: 2400),
        transitionBuilder: (Widget child, Animation<double> animation) {

          final curve = Curves.ease;
          final tween =
              Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

          return FadeTransition(
            opacity: animation.drive(tween),
            child: child,
          );
        },
        child: (_productProvider.mainLoading)
            ? _loadingContainer()
            : Container(
                color: AppTheme.nearlyWhite,
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Scaffold(
                    backgroundColor: AppTheme.nearlyWhite,
                    body: WillPopScope(
                      onWillPop: (_systemBackButtonPressed),
                      child: Scaffold(
                        drawer: DrawerMarket(),
                        appBar: AppBarMarket(),
                        bottomNavigationBar: CustomBottomNavigationBar(),
                        body: SafeArea(
                          top: false,
                          child: FadeIndexedStack(
                            index: _mainProvider.indexPage,
                            children: _mainProvider.getPages(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ));
  }

  Widget _loadingContainer() {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Container(
          child: Center(
            child: Image(
              image: AssetImage('assets/gif/progress.gif'),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

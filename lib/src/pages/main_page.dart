import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/custom_drawer/home_drawer.dart';
import 'package:gustolact/src/navigators/home_navigator.dart';
import 'package:gustolact/src/pages/unavaliable_page.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:gustolact/src/widgets/appbar_widget.dart';
import 'package:gustolact/src/widgets/drawer_widget.dart';
import 'package:provider/provider.dart';
import 'package:gustolact/src/providers/main_provider.dart';
import 'package:gustolact/src/providers/product_provider.dart';
import 'package:gustolact/src/widgets/bottombar_widget.dart';
import 'package:gustolact/src/widgets/fade_in_stack.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>  with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;

  List<GlobalKey<NavigatorState>> _navigatorKeys;

  Timer mtimer;

  MainProvider mainProvider;

  Future<bool> _systemBackButtonPressed() {

    if (_navigatorKeys[_selectedIndex].currentState.canPop()) {

      _navigatorKeys[_selectedIndex]
          .currentState
          .pop(_navigatorKeys[_selectedIndex].currentContext);
    } else {


      if(mainProvider.indexPage == 0) {
        SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
      }else {
        mainProvider.indexPage = 0;
      }

    }

  }

  DrawerIndex drawerIndex;
  Widget screenView;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = HomeNavigator();
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    mainProvider = Provider.of<MainProvider>(context);
    ProductProvider productProvider = Provider.of<ProductProvider>(context);

    this._navigatorKeys = [
      mainProvider.homeNavigatorKey,
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
                      onWillPop: (_systemBackButtonPressed),
                      child: Scaffold(
                        drawer: DrawerMarket(),
                        appBar: AppBarMarket(),
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
        );


  }

  void changeIndex(DrawerIndex drawerIndexdata) {

    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = HomeNavigator();
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
        setState(() {
          screenView = UnavaiablePage();
        });
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

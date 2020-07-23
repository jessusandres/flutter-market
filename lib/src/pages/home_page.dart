import 'package:flutter/material.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:gustolact/src/providers/home_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    final HomeProvider _homeProvider = Provider.of<HomeProvider>(context);

    return DefaultTabController(
      initialIndex: _homeProvider.currentTabIndex,
      length: _homeProvider.shorcuts.length,
      child: Scaffold(
        appBar: AppBarHome(height: 65.5),
        body: TabBarView(
          physics: BouncingScrollPhysics(),
          children: _homeProvider.shorcuts.map((shr) => shr.tabpage).toList(),
        ),
      ),
    );
  }
}
class AppBarHome extends StatelessWidget implements PreferredSizeWidget {

  final double height;

  const AppBarHome({Key key, @required this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    final HomeProvider _homeProvider = Provider.of<HomeProvider>(context);

    return AppBar(
        elevation: 10,
        backgroundColor: AppTheme.nearlyWhite,
        bottom: TabBar(
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.darkerText,
          tabs: _homeProvider.shorcuts.map((shr) =>
              Tab(
                child: Container(
                    padding: EdgeInsets.only(bottom: 16),
//                    child: Icon(shr.icon, color: Colors.grey,)),
                    child: Text(shr.name ),
                )
              )
          ).toList(),
        )
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);

}


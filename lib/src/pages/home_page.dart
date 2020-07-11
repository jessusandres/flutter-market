import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gustolact/src/providers/home_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    HomeProvider homeProvider = Provider.of<HomeProvider>(context);

    return DefaultTabController(
      initialIndex: homeProvider.currentTabIndex,
      length: homeProvider.shorcuts.length,
      child: Scaffold(
        appBar: AppBarHome(height: 55.5),
        body: TabBarView(
          children: homeProvider.shorcuts.map((shr) => shr.tabpage).toList(),
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

    HomeProvider homeProvider = Provider.of<HomeProvider>(context);

    return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        bottom: TabBar(
          tabs: homeProvider.shorcuts.map((shr) =>
              Tab(
                child: Container(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Icon(shr.icon, color: Colors.black12,)),
              )
          ).toList(),
        )
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);

}


import 'package:flutter/material.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/providers/main_provider.dart';
import 'package:provider/provider.dart';

class MenuWidget extends StatelessWidget {
  @override
  Drawer build(BuildContext context) {
    MainProvider mainProvider = Provider.of<MainProvider>(context);
    return Drawer(
      child: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Image(
                image: NetworkImage(storeAvatar),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.home,
                color: ( mainProvider.drawerPage == 0) ?  Theme.of(context).primaryColor : Colors.black26,
              ),
              title: Text('Inicio',
                style: TextStyle(
                  color: ( mainProvider.drawerPage == 0) ?  Theme.of(context).primaryColor : Colors.black26,
                  fontWeight: ( mainProvider.drawerPage == 0) ? FontWeight.w700 : FontWeight.normal,
                ),),
              onTap: () {
                mainProvider.drawerPage = 0;
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: ( mainProvider.drawerPage == 1) ?  Theme.of(context).primaryColor : Colors.black26,
              ),
              title: Text('Perfil',
                style: TextStyle(
                  color: ( mainProvider.drawerPage == 1) ?  Theme.of(context).primaryColor : Colors.black26,
                  fontWeight: ( mainProvider.drawerPage == 1) ? FontWeight.w700 : FontWeight.normal,
                ),),
              onTap: () {
                mainProvider.drawerPage = 1;
                Navigator.pushReplacementNamed(context, 'profile');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.party_mode,
                color: ( mainProvider.drawerPage == 2) ?  Theme.of(context).primaryColor : Colors.black26,
              ),
              title: Text('Cotizaciones',
                style: TextStyle(
                  color: ( mainProvider.drawerPage == 2) ?  Theme.of(context).primaryColor : Colors.black26,
                  fontWeight: ( mainProvider.drawerPage == 2) ? FontWeight.w700 : FontWeight.normal,
                ),),
              onTap: () {
                mainProvider.drawerPage = 2;
                Navigator.pushReplacementNamed(context, 'cotizations');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: ( mainProvider.drawerPage == 3) ?  Theme.of(context).primaryColor : Colors.black26,
              ),
              title: Text('Ajustes',
                style: TextStyle(
                  color: ( mainProvider.drawerPage == 3) ?  Theme.of(context).primaryColor : Colors.black26,
                  fontWeight: ( mainProvider.drawerPage == 3) ? FontWeight.w700 : FontWeight.normal,
                ),),
              onTap: () {
                mainProvider.drawerPage = 3;
                Navigator.pushReplacementNamed(context, 'settings');
              },
            ),
          ],
        ),
      ),
    );
  }
}

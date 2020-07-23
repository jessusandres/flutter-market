import 'package:flutter/material.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/providers/main_provider.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:provider/provider.dart';

class DrawerMarket extends StatelessWidget {
  @override
  Drawer build(BuildContext context) {
    final MainProvider _mainProvider = Provider.of<MainProvider>(context);
    return Drawer(
      child: Container(
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 210,
              width: double.infinity,
              child: FadeInImage(
                placeholder: AssetImage('assets/gif/spinner.gif'),
                image: NetworkImage(storeAvatar),
                fit: BoxFit.cover,
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.home,
                color: ( _mainProvider.drawerPage == 0) ?  AppTheme.primaryColor : Colors.black26,
              ),
              title: Text('Inicio',
                style: TextStyle(
                  color: ( _mainProvider.drawerPage == 0) ?  AppTheme.primaryColor : Colors.black26,
                  fontWeight: ( _mainProvider.drawerPage == 0) ? FontWeight.w700 : FontWeight.normal,
                ),),
              onTap: () {

                if(_mainProvider.drawerPage == 0) return;
                _mainProvider.drawerPage = 0;
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.account_circle,
                color: ( _mainProvider.drawerPage == 1) ?  Theme.of(context).primaryColor : Colors.black26,
              ),
              title: Text('Perfil',
                style: TextStyle(
                  color: ( _mainProvider.drawerPage == 1) ?  Theme.of(context).primaryColor : Colors.black26,
                  fontWeight: ( _mainProvider.drawerPage == 1) ? FontWeight.w700 : FontWeight.normal,
                ),),
              onTap: () {
                if(_mainProvider.drawerPage == 1) return;
                _mainProvider.drawerPage = 1;
                Navigator.pushReplacementNamed(context, 'profile');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.assessment,
                color: ( _mainProvider.drawerPage == 2) ?  Theme.of(context).primaryColor : Colors.black26,
              ),
              title: Text('Mis Pedidos',
                style: TextStyle(
                  color: ( _mainProvider.drawerPage == 2) ?  Theme.of(context).primaryColor : Colors.black26,
                  fontWeight: ( _mainProvider.drawerPage == 2) ? FontWeight.w700 : FontWeight.normal,
                ),),
              onTap: () {
                if(_mainProvider.drawerPage == 2) return;
                _mainProvider.drawerPage = 2;
                Navigator.pushReplacementNamed(context, 'cotizations');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.share,
                color: ( _mainProvider.drawerPage == 3) ?  Theme.of(context).primaryColor : Colors.black26,
              ),
              title: Text('Compartir',
                style: TextStyle(
                  color: ( _mainProvider.drawerPage == 3) ?  Theme.of(context).primaryColor : Colors.black26,
                  fontWeight: ( _mainProvider.drawerPage == 3) ? FontWeight.w700 : FontWeight.normal,
                ),),
              onTap: () {
                if(_mainProvider.drawerPage == 3) return;
                _mainProvider.drawerPage = 3;
                Navigator.pushReplacementNamed(context, 'settings');
              },
            ),
          ],
        ),
      ),
    );
  }
}

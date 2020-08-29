import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/pages/login_page.dart';
import 'package:gustolact/src/providers/login_provider.dart';
import 'package:gustolact/src/providers/main_provider.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:provider/provider.dart';

class DrawerMarket extends StatelessWidget {
  @override
  Drawer build(BuildContext context) {
    final MainProvider _mainProvider = Provider.of<MainProvider>(context);
    final LoginProvider _loginProvider = Provider.of<LoginProvider>(context);
    return Drawer(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromRGBO(242, 143, 43, 1.0),
                Color.fromRGBO(228, 174, 131, 1.0)
              ])),
              height: 25,
            ),
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
                color: (_mainProvider.drawerPage == 0)
                    ? AppTheme.primaryColor
                    : Colors.black26,
              ),
              title: Text(
                'Inicio',
                style: TextStyle(
                  color: (_mainProvider.drawerPage == 0)
                      ? AppTheme.primaryColor
                      : Colors.black26,
                  fontWeight: (_mainProvider.drawerPage == 0)
                      ? FontWeight.w700
                      : FontWeight.normal,
                ),
              ),
              onTap: () {
                if (_mainProvider.drawerPage == 0) return;
                _mainProvider.drawerPage = 0;
                _loginProvider.verifyLogin();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.account_circle,
                color: (_mainProvider.drawerPage == 1)
                    ? Theme.of(context).primaryColor
                    : Colors.black26,
              ),
              title: Text(
                'Perfil',
                style: TextStyle(
                  color: (_mainProvider.drawerPage == 1)
                      ? Theme.of(context).primaryColor
                      : Colors.black26,
                  fontWeight: (_mainProvider.drawerPage == 1)
                      ? FontWeight.w700
                      : FontWeight.normal,
                ),
              ),
              onTap: () {
                if (_mainProvider.drawerPage == 1) return;
                _mainProvider.drawerPage = 1;
                _loginProvider.verifyLogin();
                Navigator.pushReplacementNamed(context, 'profile');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.assessment,
                color: (_mainProvider.drawerPage == 2)
                    ? Theme.of(context).primaryColor
                    : Colors.black26,
              ),
              title: Text(
                'Mis Pedidos',
                style: TextStyle(
                  color: (_mainProvider.drawerPage == 2)
                      ? Theme.of(context).primaryColor
                      : Colors.black26,
                  fontWeight: (_mainProvider.drawerPage == 2)
                      ? FontWeight.w700
                      : FontWeight.normal,
                ),
              ),
              onTap: () {
                if (_mainProvider.drawerPage == 2) return;
                _mainProvider.drawerPage = 2;
                _loginProvider.verifyLogin();
                Navigator.pushReplacementNamed(context, 'orders');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.share,
                color: (_mainProvider.drawerPage == 3)
                    ? Theme.of(context).primaryColor
                    : Colors.black26,
              ),
              title: Text(
                'Compartir',
                style: TextStyle(
                  color: (_mainProvider.drawerPage == 3)
                      ? Theme.of(context).primaryColor
                      : Colors.black26,
                  fontWeight: (_mainProvider.drawerPage == 3)
                      ? FontWeight.w700
                      : FontWeight.normal,
                ),
              ),
              onTap: () {
                if (_mainProvider.drawerPage == 3) return;
                _mainProvider.drawerPage = 3;
                _loginProvider.verifyLogin();
                Navigator.pushReplacementNamed(context, 'settings');
              },
            ),
            Expanded(
              child: Container(),
            ),
            (_loginProvider.isLogged)
                ? ListTile(
                    trailing: Icon(
                      FontAwesomeIcons.signOutAlt,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        'Cerrar Sesión',
                        style: TextStyle(
                            color: Colors.black26,
                            fontWeight: FontWeight.w700,
                            fontSize: FontSize.large.size),
                      ),
                    ),
                    onTap: () {
                      _loginProvider.logout();
                    },
                  )
                : ListTile(
                    trailing: Icon(
                      FontAwesomeIcons.signOutAlt,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                            color: Colors.black26,
                            fontWeight: FontWeight.w700,
                            fontSize: FontSize.large.size),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, CupertinoPageRoute(builder:(_)=>LoginPage()));
                    },
                  ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

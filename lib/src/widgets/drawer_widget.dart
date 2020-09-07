import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/pages/login_page.dart';
import 'package:gustolact/src/providers/login_provider.dart';
import 'package:gustolact/src/providers/main_provider.dart';
import 'package:gustolact/src/tansitions/slide_transition.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:provider/provider.dart';

class DrawerMarket extends StatelessWidget {
  @override
  Drawer build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    final LoginProvider _loginProvider = Provider.of<LoginProvider>(context);

    final tiles = [
      {"title": "Inicio", "route": "/", "icon": Icons.home, "auth": false},
      {
        "title": "Perfil",
        "route": "profile",
        "icon": Icons.account_circle,
        "auth": true
      },
      {
        "title": "Mis Pedidos",
        "route": "orders",
        "icon": Icons.assessment,
        "auth": true
      },
      {
        "title": "Compartir",
        "route": "shared",
        "icon": Icons.share,
        "auth": false
      },
    ];

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
              color: AppTheme.bgDrawer,
              height: media.height * 0.3,
              width: double.infinity,
              child: FadeInImage(
                  fit: BoxFit.contain,
                  placeholder: AssetImage('assets/gif/spinner.gif'),
                  image: NetworkImage(storeAvatar)),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: tiles.length,
                itemBuilder: (BuildContext context, int index) {
                  return DrawerItem(
                      index: index,
                      mcontext: context,
                      auth: tiles[index]['auth'],
                      icon: tiles[index]['icon'],
                      route: tiles[index]['route'],
                      title: tiles[index]['title']);
                },
              ),
            ),
            (_loginProvider.isLogged)
                ? LogoutTile(loginProvider: _loginProvider)
                : LoginTile(),
            SizedBox(
              height: 7,
            )
          ],
        ),
      ),
    );
  }
}

class LogoutTile extends StatelessWidget {
  const LogoutTile({
    Key key,
    @required LoginProvider loginProvider,
  })  : _loginProvider = loginProvider,
        super(key: key);

  final LoginProvider _loginProvider;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Icon(
        FontAwesomeIcons.signOutAlt,
        color: AppTheme.primaryColor,
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
    );
  }
}

class LoginTile extends StatelessWidget {
  const LoginTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Icon(
        FontAwesomeIcons.signOutAlt,
        color: AppTheme.primaryColor,
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
        Navigator.push(
            context, CupertinoPageRoute(builder: (_) => LoginPage()));
      },
    );
  }
}

class DrawerItem extends StatelessWidget {
  final int index;
  final BuildContext mcontext;
  final String title;
  final String route;
  final IconData icon;
  final bool auth;

  const DrawerItem(
      {@required this.mcontext,
      @required this.title,
      @required this.index,
      @required this.route,
      @required this.icon,
      @required this.auth});

  @override
  Widget build(BuildContext context) {
    final MainProvider _mainProvider = Provider.of<MainProvider>(mcontext);
    final LoginProvider _loginProvider = Provider.of<LoginProvider>(mcontext);

    return ListTile(
      leading: Icon(
        icon,
        color: (_mainProvider.drawerPage == index)
            ? AppTheme.primaryColor
            : Colors.black26,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: (_mainProvider.drawerPage == index)
              ? AppTheme.primaryColor
              : Colors.black26,
          fontWeight: (_mainProvider.drawerPage == index)
              ? FontWeight.w700
              : FontWeight.normal,
        ),
      ),
      onTap: () {
        if (_mainProvider.drawerPage == index) return;
        if (auth && !_loginProvider.isLogged) {
          Navigator.push(context, SlideLeftRoute(page: LoginPage()));
          return;
        }
        _mainProvider.drawerPage = index;
        _loginProvider.verifyLogin();
        Navigator.pushReplacementNamed(context, '$route');
      },
    );
  }
}

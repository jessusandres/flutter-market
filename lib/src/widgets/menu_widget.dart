import 'package:flutter/material.dart';
import 'package:gustolact/src/config/config.dart';

class MenuWidget extends StatelessWidget {
  @override
  Drawer build(BuildContext context) {

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Container(),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(backgroungImage),
                    fit: BoxFit.contain
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Theme.of(context).primaryColor,),
              title: Text('Inicio'),
              onTap: (){
//              Navigator.pop(context);
//              Navigator.pushReplacementNamed(context,'');
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Theme.of(context).primaryColor,),
              title: Text('Perfil'),
              onTap: (){},
            ),
            ListTile(
              leading: Icon(Icons.party_mode, color: Theme.of(context).primaryColor,),
              title: Text('Cotizaciones'),
              onTap: (){},
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Theme.of(context).primaryColor,),
              title: Text('Ajustes'),
              onTap: (){
//              Navigator.pop(context);
//              Navigator.pushNamed(context, SettingsPage.routeName);
//              Navigator.pushReplacementNamed(context, '');
              },
            ),

          ],
        ),
      ),
    );
  }
}
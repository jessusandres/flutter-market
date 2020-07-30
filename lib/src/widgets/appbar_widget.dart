import 'package:flutter/material.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/themes/app_theme.dart';

class AppBarMarket extends PreferredSize {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(242, 143, 43, 1.0),
        Color.fromRGBO(228, 174, 131, 1.0)
      ])),
      child: SafeArea(
        child: Container(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                child: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
              Container(
                height: double.infinity,
                child: Center(
                  child:
                      Text(storeName.toUpperCase(), style: AppTheme.subtitle),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, 65);
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/pages/steps_payment_page.dart';
import 'package:gustolact/src/providers/login_provider.dart';
import 'package:gustolact/src/tansitions/slide_transition.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:provider/provider.dart';

class AppBarMarket extends PreferredSize {

  final double height  = 65.0;

  @override
  Widget build(BuildContext context) {

    final showPayButtom = Provider.of<LoginProvider>(context).isLogged;

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(242, 143, 43, 1.0),
        Color.fromRGBO(228, 174, 121, 1.0)
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
              ),
              showPayButtom ? Positioned(
                right: 0,
                child: Container(
                  height: height,
                  child: CupertinoButton(
                      onPressed: (){
                        Navigator.push(context, SlideTopRoute(page: StepsPaymentPage()));
                      },
                      child: Icon(Icons.payment, color: AppTheme.white,)
                  ),
                ),
              ) : Container()
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, height);
}

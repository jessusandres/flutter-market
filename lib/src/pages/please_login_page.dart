import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_html/style.dart';
import 'package:gustolact/src/pages/login_page.dart';
import 'package:gustolact/src/themes/app_theme.dart';


class PleaseLoginPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {


    final size = MediaQuery.of(context).size;

    final portrait = MediaQuery.of(context).orientation;

    double widthOne;

    if(portrait == Orientation.landscape) {
      widthOne = size.width * 0.50;
    }else {
      widthOne = size.width * 0.65;
    }

    return Scaffold(
      body: Container(
        child: Row(
          children: <Widget>[
            Container(
              child: ClipRRect(
                child: Image(
                  image: AssetImage('assets/img/muneco.jpg'),
                  height: size.height,
                  fit: BoxFit.fill,
                ),
              ),
              width: widthOne,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.035),
                      height: size.height * 0.15,
//                      width: size.width * 0.29,
                      child: Text(
                        'INICIA SESIÓN PRIMERO',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: FontSize.xLarge.size - 2),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    FlatButton(
                      color: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: Text(
                        'LOGUEARSE',
                        style: TextStyle(color: AppTheme.white),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

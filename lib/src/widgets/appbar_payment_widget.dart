import 'package:flutter/material.dart';
import 'package:gustolact/src/themes/app_theme.dart';

class AppBarPayment extends PreferredSize {
  final double height = 65.0;

  @override
  Widget build(BuildContext context) {
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
                    Icons.keyboard_backspace,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                height: double.infinity,
                child: Center(
                  child: Text(
                    "CHECKOUT",
                    style: AppTheme.subtitle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, height);
}

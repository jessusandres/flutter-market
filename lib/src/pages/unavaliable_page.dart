import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';

import 'package:gustolact/src/themes/app_theme.dart';

class UnavaiablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _MantenimientoContainer(),
    );
  }
}

class _MantenimientoContainer extends StatefulWidget {
  @override
  __MantenimientoContainerState createState() =>
      __MantenimientoContainerState();
}

class __MantenimientoContainerState extends State<_MantenimientoContainer>
    with SingleTickerProviderStateMixin {

  AnimationController _animationController;
  Animation<double> _moveup;
  Animation<double> _fadeIn;
  Animation<double> _fadeOut;

  @override
  void initState() {

    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));
    _moveup = new Tween(begin: 0.0, end: -275.0).animate(_animationController);

    _fadeIn = new Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.35, curve: Curves.easeOut)));

    _fadeOut = new Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.65, 1, curve: Curves.easeOut)));

    _animationController.addListener(() {
      if (_animationController.status == AnimationStatus.completed) {
        _animationController.repeat();
      }
    });

    super.initState();

  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromRGBO(228, 174, 131, 1.0)
      ),
      height: double.infinity,
      child: Center(
        child: TextoMantenimiento(),
      ),
    );

    return Container(
      color: Color.fromRGBO(255, 200, 0, 1),
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: <Widget>[
          AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext context, Widget child) {
              return Transform.translate(
                  offset: Offset(0, _moveup.value),
                  child: Opacity(opacity: _fadeIn.value - _fadeOut.value, child: child));
            },
            child: Center(
              child: Image(
                image: AssetImage('assets/img/mantenimiento.jpg'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
//            alignment: Alignment.bottomCenter,
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(bottom: 35),
            child: TextoMantenimiento(),
          )
        ],
      ),
    );
  }
}

class TextoMantenimiento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Página en mantenimiento',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppTheme.white,
        fontSize: FontSize.xxLarge.size,
      ),
    );
  }
}

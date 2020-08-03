import 'package:flutter/material.dart';
import 'package:gustolact/src/providers/cart_provider.dart';
import 'package:gustolact/src/providers/login_provider.dart';
import 'package:gustolact/src/providers/main_provider.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:gustolact/src/themes/light_color.dart';
import 'package:gustolact/src/widgets/BottomNavigationBar/bottom_curved_Painter.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  AnimationController _xController;
  AnimationController _yController;

  @override
  void initState() {
    _xController = AnimationController(
        vsync: this, animationBehavior: AnimationBehavior.preserve);
    _yController = AnimationController(
        vsync: this, animationBehavior: AnimationBehavior.preserve);

    Listenable.merge([_xController, _yController]).addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _xController.value =
        _indexToPosition(_selectedIndex) / MediaQuery.of(context).size.width;
    _yController.value = 1.0;

    super.didChangeDependencies();
  }

  double _indexToPosition(int index) {
    // Calculate button positions based off of their
    // index (works with `MainAxisAlignment.spaceAround`)
    const buttonCount = 4.0;
    final appWidth = MediaQuery.of(context).size.width;
    final buttonsWidth = _getButtonContainerWidth();
    final startX = (appWidth - buttonsWidth) / 2;
    return startX +
        index.toDouble() * buttonsWidth / buttonCount +
        buttonsWidth / (buttonCount * 2.0);
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    super.dispose();
  }

  Widget _icon(
      IconData icon, bool isEnable, int index, MainProvider mainProvider) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    final LoginProvider _loginProvider = Provider.of<LoginProvider>(context);

    if (isEnable) {
      _handlePressed(mainProvider.indexPage);
    }

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        onTap: () {
          mainProvider.indexPage = index;
          if (index == 3) {
            _cartProvider.getCart();
          }
          _loginProvider.verifyLogin();
          _handlePressed(mainProvider.indexPage);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          alignment: isEnable ? Alignment.topCenter : Alignment.center,
          child: AnimatedContainer(
              height: isEnable ? 40 : 20,
              duration: Duration(milliseconds: 300),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: isEnable ? AppTheme.primaryColor : Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: isEnable ? Color(0xfffeece2) : Colors.white,
                      blurRadius: 10,
                      spreadRadius: 5,
                      offset: Offset(5, 5),
                    ),
                  ],
                  shape: BoxShape.circle),
              child: Opacity(
                opacity: isEnable ? _yController.value : 1,
                child: Icon(icon,
                    color: isEnable
                        ? LightColor.background
                        : Theme.of(context).iconTheme.color),
              )),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    final inCurve = ElasticOutCurve(0.8);
    return CustomPaint(
      painter: BackgroundCurvePainter(
          _xController.value * MediaQuery.of(context).size.width,
          Tween<double>(
            begin: Curves.easeInExpo.transform(_yController.value),
            end: inCurve.transform(_yController.value),
          ).transform(_yController.velocity.sign * 0.5 + 0.5),
          Theme.of(context).backgroundColor),
    );
  }

  double _getButtonContainerWidth() {
    double width = MediaQuery.of(context).size.width;
    if (width > 400.0) {
      width = 400.0;
    }
    return width;
  }

  void _handlePressed(int index) {
    if (_selectedIndex == index || _xController.isAnimating) return;

    setState(() {
      _selectedIndex = index;
    });

    _yController.value = 1.0;
    _xController.animateTo(
        _indexToPosition(index) / MediaQuery.of(context).size.width,
        duration: Duration(milliseconds: 25));
    Future.delayed(
      Duration(milliseconds: 25),
      () {
        _yController.animateTo(1.0, duration: Duration(milliseconds: 25));
      },
    );
    _yController.animateTo(0.0, duration: Duration(milliseconds: 25));
  }

  @override
  Widget build(BuildContext context) {
    final appSize = MediaQuery.of(context).size;
    final height = 60.0;
    final MainProvider _mainProvider = Provider.of<MainProvider>(context);

    return (_mainProvider.drawerPage == 0)
        ? Container(
            color: Colors.white,
            width: appSize.width,
            height: 60,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  bottom: 0,
                  width: appSize.width,
                  height: height - 10,
                  child: _buildBackground(),
                ),
                Positioned(
                  left: (appSize.width - _getButtonContainerWidth()) / 2,
                  top: 0,
                  width: _getButtonContainerWidth(),
                  height: height,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _icon(Icons.home, _mainProvider.indexPage == 0, 0,
                          _mainProvider),
                      _icon(Icons.search, _mainProvider.indexPage == 1, 1,
                          _mainProvider),
                      _icon(Icons.message, _mainProvider.indexPage == 2, 2,
                          _mainProvider),
                      _icon(Icons.shopping_cart, _mainProvider.indexPage == 3,
                          3, _mainProvider),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            width: 0.0,
            height: 0.0,
          );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/providers/cart_provider.dart';
import 'package:gustolact/src/providers/login_provider.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final bool showBackbutton;

  const LoginPage({this.showBackbutton = false});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginProvider loginProvider;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _showPassword = false;

  @override
  void dispose() {
    loginProvider.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(children: <Widget>[
        _fullBackground(context),
        _loginForm(context),
        (loginProvider.loadingSign)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container()
      ]),
    );
  }

  Widget _circle({double right, double left, double top, double bottom}) {
    return Positioned(
      right: right,
      left: left,
      top: top,
      bottom: bottom,
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.04),
        ),
      ),
    );
  }

  Widget _backgroundColor(Size size) {
    return Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(242, 143, 43, 1.0),
        Color.fromRGBO(218, 174, 131, 1.0)
      ])),
    );
  }

  Widget _topContainer(Size size) {
    return Container(
      padding: EdgeInsets.only(top: size.height * 0.09),
      child: Column(
        children: <Widget>[
          Icon(Icons.person_pin_circle, size: 100.0, color: Colors.white),
          SizedBox(
            height: 11.0,
            width: double.infinity,
          ),
          Text(storeName,
              style: TextStyle(color: Colors.white, fontSize: 25.0)),
        ],
      ),
    );
  }

  Widget _fullBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(children: <Widget>[
      _backgroundColor(size),
      _circle(top: 90.0, left: 30.0),
      _circle(top: -40.0, right: -30.0),
      _circle(bottom: -50.0, right: -10.0),
      _circle(bottom: 120.0, right: 18.0),
      _circle(bottom: -50.0, left: -20.0),
      _topContainer(size)
    ]);
  }

  Widget _emailField(LoginProvider loginProvider) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 29.0),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            icon: Icon(
              Icons.alternate_email,
            ),
            hintText: 'example@domain.com',
            labelText: 'Correo Electrónico',
//            counterText: snapshot.data,
            errorText: loginProvider.email.error),
//              onChanged: (String value) => bloc.changeEmail(value),
        //primer argumento se traslada
        onChanged: (String val) {
          loginProvider.changeEmail(val);
        },
      ),
    );
  }

  Widget _passwordField(LoginProvider loginProvider) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 29.0),
      child: TextField(
//        maxLength: 10,
        obscureText: !this._showPassword,
        decoration: InputDecoration(
            suffix: IconButton(
              icon: (!this._showPassword)
                  ? Icon(Icons.remove_red_eye)
                  : Icon(Icons.lock),
              color: (this._showPassword) ? Colors.grey : AppTheme.primaryColor,
              onPressed: () {
                setState(() {
                  this._showPassword = !this._showPassword;
                });
              },
            ),
            icon: Icon(
              Icons.lock_outline,
            ),
            hintText: '********',
            labelText: 'Contraseña',
//            counterText: snapshot.data,
            errorText: loginProvider.password.error),
        // TODO call provider
        onChanged: (String value) {
          loginProvider.changePassword(value);
        },
      ),
    );
  }

  Widget _buttonLogin(BuildContext context) {
    final LoginProvider loginProvider = Provider.of<LoginProvider>(context);

    return RaisedButton(
      onPressed: (loginProvider.isValid && !loginProvider.loadingSign)
          ? () {
              loginUser(loginProvider, context);
            }
          : null,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(
          'Ingresar',
          style: TextStyle(fontSize: 17.0),
        ),
      ),
      elevation: 0.0,
      color: Color.fromRGBO(242, 143, 43, 1.0),
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }

  Widget _fieldsContainer(List<Widget> children, Size size) {
    return Container(
      width: size.width * 0.75,
      padding: EdgeInsets.symmetric(vertical: 30.0),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.5),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black26,
                blurRadius: 3.0,
                offset: Offset(0.0, 0.5),
                spreadRadius: 3.5)
          ]),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;

//    final bloc = Provider.of(context);
    final LoginProvider loginProvider = Provider.of<LoginProvider>(context);

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: size.height * 0.28,
            ),
          ),
          _fieldsContainer([
            (widget.showBackbutton)
                ? Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    width: 50,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppTheme.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                : Container(),
            (widget.showBackbutton) ? SizedBox(height: 15.0) : Container(),
            Text(
              'LOGIN',
//                  style: TextStyle(fontSize: 20.0),
              style: AppTheme.caption.copyWith(fontSize: 22),
            ),
            SizedBox(height: 30.0),
            _emailField(loginProvider),
            SizedBox(height: 30),
            _passwordField(loginProvider),
            SizedBox(height: 30),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: _buttonLogin(context))
          ], size),
          SizedBox(
            height: 15.0,
          ),
          Text('¿Olvidaste la contraseña?'),
          SizedBox(
            height: 100.0,
          ),
        ],
      ),
    );
  }

  loginUser(LoginProvider loginProvider, BuildContext mcontext) async {
    final response = await loginProvider.loginUser();
    print(response);
    if (!response['ok']) {
      this._scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(response['message']),
            action: SnackBarAction(
              label: 'Ocultar',
              onPressed: () {},
            ),
          ));

      return;
    }
    final CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    if (cartProvider.loadingCart == false) {
      cartProvider.getCart();
    }
    Navigator.pop(context);
  }
}

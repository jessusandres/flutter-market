import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/providers/cart_provider.dart';
import 'package:gustolact/src/providers/login_provider.dart';

//import 'package:gustolact/src/providers/login_provider.dart';
import 'package:gustolact/src/shared_preferences/user_preferences.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    final LoginProvider _loginProvider = Provider.of<LoginProvider>(context);
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
//    _loginProvider.verifyLogin();

    final UserPreferences _userPreferences = new UserPreferences();
//
//    final date = new DateTime.fromMillisecondsSinceEpoch(_loginProvider.expirationDate * 1000);

    return Scaffold(
      body: Container(
        child: _cartProvider.loadingCart
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(Duration(milliseconds: 150), () {
                    return _cartProvider.getCart();
                  });
                },
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Text(
                          'Hola ${_userPreferences.userFullName} este es tu carrito en $storeName: ',
                          style: AppTheme.title,
                        ),
                      ),
                      SizedBox(
                        height: 14.0,
                      ),
                      Expanded(child: _CartContainer()),
                    ],
                  ),
                )),
      ),
    );
  }
}

class _CartContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);

    Widget _containerToRender;

    if (_cartProvider.userCart.length == 0) {
      _containerToRender = Container(
        padding: EdgeInsets.symmetric(horizontal: 65.0),
        child: Center(
          child: Image(
            image: AssetImage('assets/img/noitemsincart.png'),
          ),
        ),
      );
    } else {
      final _cart = _cartProvider.userCart;

      _containerToRender = Container(
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: _cart.length,
          itemBuilder: (BuildContext context, int index) {
            TextEditingController textEditingController =
                new TextEditingController(
                    text: _cart[index].cartItemAmmount.toString());

            return Container(
              child: Card(
                child: Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      leading: Container(
                        width: 125,
                        child: FadeInImage(
                          placeholder: AssetImage('assets/gif/loading.gif'),
                          image: NetworkImage(_cart[index].getImage()),
                          fadeInCurve: Curves.fastOutSlowIn,
                        ),
                      ),
                      title: Text(_cart[index].cartItemDescription),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              '${_cart[index].cartItemAmmount} x ${_cart[index].cartItemPrice}'),
                          Text(
                              '${(_cart[index].cartItemAmmount * _cart[index].cartItemPrice).toStringAsFixed(2)}')
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  ),
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Actualizar',
                      color: Colors.blue,
                      icon: Icons.edit,
                      onTap: () => {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              final CartProvider _scartProvider =
                                  Provider.of<CartProvider>(context);

                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                                title: Text('Ingrese nueva cantidad'),
                                content: TextField(
                                  decoration: InputDecoration(
                                      errorText:
                                          _scartProvider.newAmmount.error),
                                  controller: textEditingController,
                                  onChanged: (String value) {
                                    _scartProvider
                                        .changeAmmount(double.parse(value));
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      if (_scartProvider.newAmmount.error !=
                                          null) {
                                        return;
                                      }

                                      _scartProvider
                                          .updateCartAmmount(_cart[index]);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Confirmar',
                                      style: TextStyle(
                                          color: AppTheme.primaryColor),
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancelar',
                                        style: TextStyle(
                                            color: AppTheme.primaryColor)),
                                  )
                                ],
                              );
                            })
                      },
                    ),
                  ],
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Borrar',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 0,
                                title: Column(
                                  children: <Widget>[
//                                  CircleAvatar(child: Image(image: AssetImage('assets/img/triste.png'),height: 175,)),
                                    Image(
                                      image:
                                          AssetImage('assets/img/triste.png'),
                                      height: 60,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        '¿Seguro que desea quitar el producto ${_cart[index].cartItemDescription}?'),
                                  ],
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text(
                                      'SÍ',
                                      style: TextStyle(
                                          color: AppTheme.dangerColor),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
//                                    final snackbar = SnackBar(content: Text('Producto eliminado'));
//                                    Scaffold.of(context).showSnackBar(snackbar);
                                    },
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'NO',
                                      style: TextStyle(color: AppTheme.grey),
                                    ),
                                  ),
                                ],
                              );
                            })
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    return _containerToRender;
  }
}

class Info extends StatelessWidget {
  const Info({
    Key key,
    @required UserPreferences userPreferences,
    @required this.date,
  })  : _userPreferences = userPreferences,
        super(key: key);

  final UserPreferences _userPreferences;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
          'PAGE : CartPage \nEmail:${_userPreferences.userEmail} \nUser: ${_userPreferences.userFullName} \nExpiration Session: $date'),
    );
  }
}

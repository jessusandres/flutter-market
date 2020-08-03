import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/models/user_cart.dart';
import 'package:gustolact/src/providers/cart_provider.dart';
import 'package:gustolact/src/shared_preferences/user_preferences.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:gustolact/src/widgets/skeleton_cart_widget.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  CartProvider _cartProvider;

  @override
  Widget build(BuildContext context) {

    this._cartProvider = Provider.of<CartProvider>(context);

    final UserPreferences _userPreferences = new UserPreferences();

    return Scaffold(
      body: Container(
        child: _cartProvider.loadingCart
            ? SkeletonCartItems()
            : RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(Duration(milliseconds: 150), () {
                    return _cartProvider.getCart();
                  });
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: Container(
                        height: 25,
                        child: Text(
                          'Hola ${_userPreferences.userFullName} este es tu carrito en $storeName: ',
                          style: AppTheme.title,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 14.0,
                    ),
                    Expanded(
                        child: _CartContainer(
                          mainContext: context,
                        )),
                  ],
                )
        ),
      ),
    );
  }
}

class _CartContainer extends StatelessWidget {

  final BuildContext mainContext;

  const _CartContainer({@required this.mainContext});

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
      final cart = _cartProvider.userCart;
      if (_cartProvider.executingAction) {
        _containerToRender = SkeletonCartItems();
      } else {
        _containerToRender =
            _itemListCart(mainContext: mainContext, cart: cart);
      }
    }

    return _containerToRender;
  }

  Widget _itemListCart(
      {@required BuildContext mainContext, @required List<UserCart> cart}) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: cart.length,
      itemBuilder: (BuildContext context, int index) {
        TextEditingController textEditingController = new TextEditingController(
            text: cart[index].cartItemAmmount.toString());

        return Container(
          child: Slidable(
            actionPane: SlidableScrollActionPane (),
            actionExtentRatio: 0.20,
            child: Container(
              color: AppTheme.white,
              child: ListTile(
                leading: Container(
                  width: 125,
                  child: FadeInImage(
                    placeholder: AssetImage('assets/gif/loading.gif'),
                    image: NetworkImage(cart[index].getImage()),
                    fadeInCurve: Curves.fastOutSlowIn,
                  ),
                ),
                title: Text(cart[index].cartItemDescription),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        '${cart[index].cartItemAmmount} x ${cart[index].cartItemPrice}'),
                    Text(
                        '${(cart[index].cartItemAmmount * cart[index].cartItemPrice).toStringAsFixed(2)}')
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
                                errorText: _scartProvider.tempAmmount.error),
                            controller: textEditingController,
                            onChanged: (String value) {
                              _scartProvider
                                  .changeTempAmmount(double.parse(value));
                            },
                            keyboardType: TextInputType.number,
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                if (_scartProvider.tempAmmount.error !=
                                    null) {
                                  return;
                                } else {
                                  Navigator.pop(context);
                                  updateAmmountCart(mainContext, cart[index],
                                      textEditingController.text);
                                }
                              },
                              child: Text(
                                'Confirmar',
                                style:
                                TextStyle(color: AppTheme.primaryColor),
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
                                image: AssetImage('assets/img/triste.png'),
                                height: 60,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  '¿Seguro que desea quitar el producto ${cart[index].cartItemDescription}?'),
                            ],
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                'SÍ',
                                style: TextStyle(color: AppTheme.dangerColor),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                deleteItemCart(mainContext, cart[index]);
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
        );
      },
    );
  }

  updateAmmountCart(
      BuildContext context, UserCart userCart, String value) async {
    final CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    final response =
        await cartProvider.updateCartAmmount(userCart, double.parse(value));
    print(response);

    if (response["observation"] != null) {
      Toast.show(response["observation"], context,
          duration: 3, gravity: Toast.BOTTOM);
    }
    Future.delayed(Duration(milliseconds: 3100), () {
      Toast.show(response["message"], context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    });
  }

  deleteItemCart(BuildContext context, UserCart userCart) async {
    final CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);

    final response =
        await cartProvider.deleteItem(itemcode: userCart.cartItemCode);

    Toast.show(response["message"], context,
        duration: 2, gravity: Toast.BOTTOM);
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/models/user_cart.dart';
import 'package:gustolact/src/models/validation_model.dart';
import 'package:gustolact/src/shared_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class CartProvider with ChangeNotifier{

  double _totalCart;
  double get totalCart => this._totalCart;
  set totalCart(double value) {
    this._totalCart = value;
  }

  final UserPreferences _userPreferences = UserPreferences();
  ValidationItem _tempAmmount = new ValidationItem(null, null);
  ValidationItem get tempAmmount => this._tempAmmount;

  void changeTempAmmount(double value) {
    print("change");
    if(value == null) {
//      print("0");
      this._tempAmmount = ValidationItem(null,'Cantidad Incorrecta');
      notifyListeners();
      return;
    }

    if(value <= 0) {
//      print("1");
      this._tempAmmount = ValidationItem(null,'Cantidad Incorrecta');
    }else {
//      print("2");
      this._tempAmmount = ValidationItem(value.toString(),null);
    }

    notifyListeners();

  }

  List<UserCart> _userCart;
  List<UserCart> get userCart => this._userCart;
  set userCart(List<UserCart> newlist) {
    this._userCart = newlist;
  }

  bool _loadingCart = true;
  get loadingCart => this._loadingCart;
  set loadingCart(bool value) {
    this._loadingCart = value;
    notifyListeners();
  }

  bool _executingAction = false;
  get executingAction => this._executingAction;
  set executingAction(bool value) {
    this._executingAction = value;
    notifyListeners();
  }

  CartProvider() {
    print("== Cart Provider init ==");
  }

  // FUNCTIONS
  Future<dynamic>getCart() async {
    print("==GET CART==");
    loadingCart = true;

    final response = await http.get("$baseUrlAPI/cart/${_userPreferences.userCode}?token=${_userPreferences.authToken}");
    final decoded = jsonDecode(response.body);
//    print(decoded);
    if(decoded['ok']) {
      final cart = userCartFromJson(jsonEncode(decoded['cart']));

      List<UserCart> exclusiveCart = [];

      double ammoutForstore = 0.0;
      cart.forEach((element) {

        if(element.cartStoreUrl == urlStore) {
          final subto = element.cartItemAmmount * element.cartItemPrice;
          ammoutForstore += subto;
          exclusiveCart.add(element);
        }

      });
      totalCart = ammoutForstore;
//      print(totalCart);
      userCart = exclusiveCart;
      loadingCart = false;
    }else {
      userCart = [];
      loadingCart = false;
    }

//    Future.delayed(Duration(milliseconds: 50),(){

//    });

  }

  Future<Map<String, dynamic>> addItemToCart({@required String itemCode, @required double ammount}) async {

    if(itemCode != null && ammount != null) {
      if(itemCode.length > 0 && ammount > 0) {
        this.executingAction = true;
        final UserPreferences userPreferences = UserPreferences();

        final payload = {
          "item_code": itemCode,
          "item_ammount": ammount.toString()
        };

        final url = "$baseUrlAPI/cart/${userPreferences.userCode}/$urlStore?token=${userPreferences.authToken}";
        final response = await http.post(url, body: payload);

        final decoded = jsonDecode(response.body);
        this.executingAction = false;

        return decoded;

      }else{
        return {
          "ok": false,
          "message": 'Error en los datos'
        };
      }
    }
    return {
      "ok": false,
      "message": 'Error en los datos'
    };



  }

  Future<Map<String, dynamic>> updateCartAmmount(UserCart userCart, double newAmmount) async{
    if(newAmmount == null) {
      return {
        "message": "Valores incorrectos"
      };
    }
//    print("old ammount: ${userCart.cartItemAmmount}");
//    print("new ammount: $newAmmount");

    if(userCart.cartItemAmmount == newAmmount) {
      return {
        "message": "No se registraron cambios"
      };
    }
    this.executingAction = true;

    this._tempAmmount = ValidationItem(null, null);

    final updateRes = await updateItemToCart(itemCode: userCart.cartItemCode, ammount: newAmmount);
    this.executingAction = false;
    this.getCart();
    return updateRes;
  }

  Future<Map<String, dynamic>> updateItemToCart({@required String itemCode, @required double ammount}) async {

    if(itemCode != null && ammount != null) {
      if(itemCode.length > 0 && ammount > 0) {
        this.executingAction = true;
        final UserPreferences userPreferences = UserPreferences();
//        print(userPreferences.userCode);
        final payload = {
          "item_code": itemCode,
          "item_ammount": ammount.toString()
        };

        final url = "$baseUrlAPI/cart/${userPreferences.userCode}/$urlStore?token=${userPreferences.authToken}";
        final response = await http.put(url, body: payload);

        final decoded = jsonDecode(response.body);
        this.executingAction = false;
        return decoded;


      }else{
        return {
          "ok": false,
          "message": 'Error en los datos'
        };
      }
    }
    return {
      "ok": false,
      "message": 'Error en los datos'
    };



  }

  Future<Map<String, dynamic>> deleteItem({@required String itemcode}) async {

    final url = "$baseUrlAPI/cart/${_userPreferences.userCode}/$urlStore/$itemcode?token=${_userPreferences.authToken}";

    final response = await http.delete(url);
    final decoded = jsonDecode(response.body);
    this.getCart();
    return decoded;

  }

}

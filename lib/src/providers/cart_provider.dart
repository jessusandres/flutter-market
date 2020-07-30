import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/models/user_cart.dart';
import 'package:gustolact/src/models/validation_model.dart';
import 'package:gustolact/src/shared_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class CartProvider with ChangeNotifier{

  final UserPreferences _userPreferences = UserPreferences();

  ValidationItem _newAmmount = new ValidationItem(null, null);
  ValidationItem get newAmmount => this._newAmmount;
  void changeAmmount(double value) {
    print("change");
    if(value == null) {
      print("0");
      this._newAmmount = ValidationItem(null,'Cantidad Incorrecta');
      notifyListeners();
      return;
    }

    if(value <= 0) {
      print("1");
      this._newAmmount = ValidationItem(null,'Cantidad Incorrecta');
    }else {
      print("2");
      this._newAmmount = ValidationItem(value.toString(),null);
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

  CartProvider() {
    print("== Cart Provider init ==");
  }

  getCart() async {
    print("get cart");
    loadingCart = true;
//    print("full: ${_userPreferences.userFullName}");
    final response = await http.get("https://tuquepides.com/api/user/000001/cart?token=${_userPreferences.authToken}");
    final decoded = jsonDecode(response.body);

    if(decoded['ok']) {
      final cart = userCartFromJson(jsonEncode(decoded['cart']));

      List<UserCart> exclusiveCart = [];

      cart.forEach((element) {
        print(element.cartStoreUrl);
        if(element.cartStoreUrl == urlStore) {
          exclusiveCart.add(element);
        }
      });

      userCart = exclusiveCart;
    }else {
      userCart = [];
    }

    Future.delayed(Duration(milliseconds: 200),(){
      loadingCart = false;
    });

  }


  updateCartAmmount(UserCart userCart) {
    if(newAmmount == null) {
      return;
    }
    print("old ammount: ${userCart.cartItemAmmount}");
    print("new ammount: ${this._newAmmount.value}");
    this._newAmmount = ValidationItem(null, null);
    getCart();
  }


}

import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:http/http.dart' as http;

class ValidationItem {
  final String value;
  final String error;

  ValidationItem(this.value, this.error);
}

class LoginProvider with ChangeNotifier {
  ValidationItem _email = ValidationItem(null, null);
  ValidationItem get email => this._email;
  ValidationItem _password = ValidationItem(null, null);
  ValidationItem get password => this._password;

  final token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7InJvbGUiOiJVU0VSX1JPTEUiLCJnb29nbGUiOmZhbHNlLCJfaWQiOiI1ZjEzOGZkODEzOGViNjMwMmM3M2IwNjciLCJuYW1lIjoiSmVzw7pzIiwibGFzdG5hbWUiOiJBbmRyw6lzIiwiZW1haWwiOiJsaXZrbGl4QGdtYWlsLmNvbSIsInBhc3N3b3JkIjoiJDJiJDEwJEprWVJqOUNXbkhobDBuNEEvb0s5SS45MTRYOXdUNkJrcjJENkhpWnlENzRINVhXdGxMdi5hIiwiX192IjowfSwiaWF0IjoxNTk1Mjk2ODIyLCJleHAiOjE1OTUzMTEyMjJ9.VTxyyWccdB7KtcO2__uf6hUIyjn7hyRhG_H7MdqOvQU';

  bool _isLogged = false;
  bool get isLogged => this._isLogged;
  set isLogged(bool isLogged) {
    this._isLogged = isLogged;
    notifyListeners();
  }

  bool _loadingSign = false;
  bool get loadingSign => this._loadingSign;
  set loadingSign(bool isLogged) {
    this._loadingSign = isLogged;
    notifyListeners();
  }

  LoginProvider() {
//    this.loadingSign = true;
    print('LOGIN PROVIDER IS INIT');
    var payload = Jwt.parseJwt(token);
    print('payload: $payload');
//    this.isLogged = false;

  }

  reset() {
    print("reset");
    this._email = ValidationItem(null, null);
    this._password = ValidationItem(null, null);
  }

  Future<dynamic>loginUser() async{

    if(this.email == null || this.password == null) return;

    this.loadingSign = true;
    print("email: ${this.email.value}");
    print("password: ${this.password.value}");

    final res = await http.get('https://tuquepides.com/api/store/GustoLact/search/products?line=01&subline=01&brand=0002&item=all&auth=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiYW5kcmV3IiwicGFzcyI6ImJsbW9udDEwIiwiaWQiOjIwMjAwM30.WwgI6w5rWu5yXdxuKFsPWhA-4pAl1XoyHVHcKVvjZZ8');

//    print(res.body);
//    this._isLogged = true;
    this.loadingSign = false;

    return {
      'ok': false,
      'message': 'Credenciales incorrectas',
    };
//    return {
//      'ok': true
//    };

  }

  verifyLogin() async {
    print('verify');
    final res = await http.get('http://192.168.1.5:3000/');
    print(res.body);
  }

  bool get isValid => this._email.value != null && this._password.value != null;

  void changeEmail(String uemail) {

    if(uemail == null) {
      return;
    }

    if(uemail.length == 0) {
      this._email = ValidationItem(null, 'Email requerido');
      notifyListeners();
      return;
    }

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(pattern);

    if (regExp.hasMatch(uemail)) {
      this._email = ValidationItem(uemail, null);
    } else {
      this._email = ValidationItem(null, 'Email incorrecto');
    }
    notifyListeners();
  }

  void changePassword(String upassword) {

    if(upassword == null) {
      return;
    }

    if(upassword.length == 0) {
      this._password = ValidationItem(null, 'Contraseña requerido');
      notifyListeners();
      return;
    }

    if(upassword.length > 10) return;

    if ( upassword.length < 10 ) {
      this._password = ValidationItem(null, 'Contraseña mínima de 10 caracteres');
    }else {
      this._password = ValidationItem(upassword, null);
    }
    notifyListeners();
  }
}

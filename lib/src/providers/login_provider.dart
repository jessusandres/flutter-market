import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/models/userdata_model.dart';
import 'package:gustolact/src/models/validation_model.dart';
import 'package:gustolact/src/secure_preferences/secure_preferences.dart';
import 'package:gustolact/src/shared_preferences/user_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:http/http.dart' as http;

class LoginProvider with ChangeNotifier {
  UserPreferences _userPreferences;
  SecurePreferences _securePreferences;

  ValidationItem _email = ValidationItem(null, null);

  ValidationItem get email => this._email;

  ValidationItem _password = ValidationItem(null, null);

  ValidationItem get password => this._password;

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
    _userPreferences = new UserPreferences();
    _securePreferences = new SecurePreferences();
    print('==LOGIN PROVIDER IS INIT==');
//    this.verifyLogin();
  }

  reset() {
    this._email = ValidationItem(null, null);
    this._password = ValidationItem(null, null);
    this._loadingSign = false;
  }

  int expirationDate = 0;

  logout() {
    this._securePreferences.clear();
    this._userPreferences.clear();
    this.isLogged = false;
  }

  noneF() {

  }

  Future<dynamic> setUserData() async {
    final url =
        "$baseUrlAPI/user/${_userPreferences.userCode}?token=${_userPreferences.authToken}";
    final res = await http.get(url);
    final UserDataModel userDataModel = userDataModelFromJson(res.body);
    final userData = userDataModel.user;
//    print("p1 ${userData.phone1}");
//    print("p2 ${userData.phone2}");
//    print("p3 ${userData.phone3}");
    if (userData.phone1 == null) {
      if (userData.phone2 == null) {
        if (userData.phone3 != null)
          (userData.phone3.trim().length > 0)
              ? this._userPreferences.userPhone = userData.phone3
              : noneF();
      } else {
        (userData.phone2.trim().length > 0)
            ? this._userPreferences.userPhone = userData.phone2
            : noneF();
      }
    } else {
      (userData.phone1.trim().length > 0)
          ? this._userPreferences.userPhone = userData.phone1
          : noneF();
    }
  }

  Future<dynamic> loginUser() async {
    if (this.email == null || this.password == null) return;

    this.loadingSign = true;

    final body = {"email": this.email.value, "password": this.password.value};

    final res =
        await http.post('$baseUrlAPI/login?auth=$globalToken', body: body);
    final decode = jsonDecode(res.body);

    if (decode['ok'] == true) {
      final payload = Jwt.parseJwt(decode['token']);

      final _fullname =
          "${payload['user']['userName']} ${payload['user']['userLastname']}";
      final _userCode = payload['user']['userCode'];

      final expirationDate = payload['exp'];
      this._userPreferences.userEmail = this.email.value;
      this._userPreferences.authToken = decode['token'];
      this._userPreferences.userFullName = _fullname;
      this._userPreferences.userCode = _userCode;

      await this._securePreferences.setUserPassword(this._password.value);

      this.isLogged = true;

      this.expirationDate = expirationDate;

      return {'ok': true};
    }

    this.loadingSign = false;

    return {
      'ok': false,
      'message': 'Credenciales incorrectas',
    };
  }

  Future<bool> _loginExpiration(String femail, String fpassword) async {
    if (femail == null || fpassword == null) {
      return false;
    }

    final body = {"email": femail, "password": fpassword};

    final res =
        await http.post('$baseUrlAPI/login?auth=$globalToken', body: body);
    final decode = jsonDecode(res.body);

    if (decode['ok'] == true) {
      final payload = Jwt.parseJwt(decode['token']);
      final expirationDate = payload['exp'];
      final _userCode = payload['user']['userCode'];
      final _fullname =
          "${payload['user']['userName']} ${payload['user']['userLastname']}";
      // TODO : save user email and paswword in secure storage -- save token in user preferences
      this._userPreferences.userEmail = femail;
      this._userPreferences.userFullName = _fullname;
      this._userPreferences.userCode = _userCode;
      this._userPreferences.authToken = decode['token'];
      await this._securePreferences.setUserPassword(fpassword);

      this.expirationDate = expirationDate;
      this.isLogged = true;
      return true;
    }

    return false;
  }

  Future<dynamic> verifyLogin() async {
    print('==== VERIFICATION ====');

    if (this._userPreferences.all != null &&
        await this._securePreferences.all != null) {
      if (this._userPreferences.authToken != null &&
          this._userPreferences.userEmail != null &&
          await this._securePreferences.userPassword != null) {


        final payload = Jwt.parseJwt(this._userPreferences.authToken);

        final expirationDate = payload['exp'];

        final date =
            new DateTime.fromMillisecondsSinceEpoch(expirationDate * 1000);

        final currentDate = new DateTime.now();

        print(
            "Time to expired: ${date.difference(currentDate).inMinutes} minutes");

        if (date.difference(currentDate).inMinutes < 20) {
          print("===TOKEN REFRESH===");
          this._refreshToken(this._userPreferences.authToken);

        } else {
          this.expirationDate = expirationDate;
          this._isLogged = true;
          notifyListeners();
        }
      } else {
        print("local data is empty");
        if (this._isLogged == true) {
          this._isLogged = false;
          notifyListeners();
        }
      }
    }
    else {
      print("Invalid token");
      if (this._isLogged == true) {
        this._isLogged = false;
        notifyListeners();
      }
    }
  }

  void _refreshToken(String token) async {
    final verificationUrl = '$baseUrlAPI/login/verification?token=$token';
    final refreshUrl = '$baseUrlAPI/login/refreshToken?token=$token';

    final response = await http.get(verificationUrl);
    final decoded = jsonDecode(response.body);

    if (decoded['ok'] == true) {
      final rfrresponse = await http.get(refreshUrl);

      final rfrdecoded = jsonDecode(rfrresponse.body);


      final payload = Jwt.parseJwt(rfrdecoded['newToken']);

      final expirationDate = payload['exp'];
      final _userCode = payload['user']['userCode'];
      final _fullname =
          "${payload['user']['userName']} ${payload['user']['userLastname']}";
      final _email = payload['user']['userEmail'];

      print(
          "new ex: ${DateTime.fromMillisecondsSinceEpoch(expirationDate * 1000)}");

      this.expirationDate = expirationDate;
      this._userPreferences.authToken = rfrdecoded['newToken'];
      this._userPreferences.userFullName = _fullname;
      this._userPreferences.userCode = _userCode;
      this._userPreferences.userEmail = _email;

      this.isLogged = true;

    } else {

      if (decoded['err']['name'] == 'TokenExpiredError') {

        await this._loginExpiration(this._userPreferences.userEmail,
            await this._securePreferences.userPassword);
      } else {

        this._userPreferences.clear();
        this._securePreferences.clear();
        this._isLogged = false;
        notifyListeners();
      }
    }
  }

  bool get isValid => this._email.value != null && this._password.value != null;

  void changeEmail(String uemail) {
    if (uemail == null) {
      return;
    }

    if (uemail.length == 0) {
      this._email = ValidationItem(null, 'Email requerido');
      notifyListeners();
      return;
    }


    RegExp regExp = new RegExp(emailPattern);

    if (regExp.hasMatch(uemail)) {
      this._email = ValidationItem(uemail, null);
    } else {
      this._email = ValidationItem(null, 'Email incorrecto');
    }
    notifyListeners();
  }

  void changePassword(String upassword) {
    if (upassword == null) {
      return;
    }

    if (upassword.length == 0) {
      this._password = ValidationItem(null, 'Contraseña requerido');
      notifyListeners();
      return;
    }

    // TODO verificar cantidad de caracteres permitida
//    if(upassword.length > 10) return;

    if (upassword.length < 10) {
      this._password =
          ValidationItem(null, 'Contraseña mínima de 10 caracteres');
    } else {
      this._password = ValidationItem(upassword, null);
    }
    notifyListeners();
  }
}

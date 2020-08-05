import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {

  SharedPreferences _preferences;

  static final UserPreferences userPreferencesInstance =
      new UserPreferences._internal();

  UserPreferences._internal();

  factory UserPreferences() => userPreferencesInstance;

  initPrefences() async {
    this._preferences = await SharedPreferences.getInstance();
  }

  get authToken {
    return this._preferences.get("rm_token");
  }

  set authToken(String token) {
    this._preferences.setString("rm_token", token);
  }

  get userEmail{
    return this._preferences.get("rm_email");
  }

  set userEmail(String email) {
    this._preferences.setString("rm_email", email);
  }

  get userFullName{
    return this._preferences.get("rm_username");
  }

  set userFullName(String name) {
    this._preferences.setString("rm_username", name);
  }

  get userCode{
    return this._preferences.get("rm_usercode");
  }

  set userCode(String code) {
    this._preferences.setString("rm_usercode", code);
  }


  get all => this._preferences.getKeys();

  clear() async{
    await this._preferences.clear();
  }
}
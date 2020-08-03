import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurePreferences {
  FlutterSecureStorage _secureStorage;

  static final SecurePreferences securePreferencesInstance =
      new SecurePreferences._internal();

  SecurePreferences._internal() {
    this.initSecureSt();
  }

  factory SecurePreferences() => securePreferencesInstance;

  initSecureSt() {
    this._secureStorage = new FlutterSecureStorage();
  }

  get userPassword {
    return this._secureStorage.read(key: "rm_password");
  }

  setUserPassword(String password) {
    this._secureStorage.write(key: "rm_password", value: password);
  }
  get all => this._secureStorage.readAll();

  clear() {
    this._secureStorage.deleteAll();
  }
}

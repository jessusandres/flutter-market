import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/models/departaments_model.dart';
import 'package:gustolact/src/models/districts_model.dart';
import 'package:gustolact/src/models/provinces_model.dart';
import 'package:gustolact/src/models/user_addresses_model.dart';
import 'package:gustolact/src/models/validation_model.dart';
import 'package:gustolact/src/options/payment_options.dart';
import 'package:gustolact/src/pages/checkout/card_payment.dart';
import 'package:gustolact/src/pages/checkout/payment_resume.dart';
import 'package:gustolact/src/pages/checkout/user_reference_page.dart';
import 'package:gustolact/src/shared_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class StepsProvider with ChangeNotifier {
  final UserPreferences _userPreferences = new UserPreferences();

  BehaviorSubject<List<Departament>> _allDepartamentsController =
      new BehaviorSubject<List<Departament>>();

  Stream<List<Departament>> get departamentsStream =>
      _allDepartamentsController.stream;

  BehaviorSubject<List<Province>> _allProvincesController =
      new BehaviorSubject<List<Province>>();

  Stream<List<Province>> get provincesStream => _allProvincesController.stream;

  BehaviorSubject<List<District>> _allDistrictsController =
      new BehaviorSubject<List<District>>();

  Stream<List<District>> get districtsStream => _allDistrictsController.stream;

  BehaviorSubject<List<Map<String, Address>>> _userDirectionsController =
      new BehaviorSubject<List<Map<String, Address>>>();

  Stream<List<Map<String, Address>>> get userDirectionsStream =>
      _userDirectionsController.stream;

  @override
  void dispose() {
    _allDepartamentsController.close();
    _allProvincesController.close();
    _allDistrictsController.close();
    _userDirectionsController.close();
    super.dispose();
  }

  void getUserDirections() async {
    final url =
        "$baseUrlAPI/user/${_userPreferences.userCode}/directions?token=${_userPreferences.authToken}";
    final res = await http.get(url);
    final userAddressesData = userAddressesFromJson(res.body);
    final userAddresses = userAddressesData.addresses;
    final List<Map<String, Address>> mList = [];
    userAddresses.forEach((element) {
      final mmap = {element.addressCode: element};
      mList.add(mmap);
    });

    _userDirectionsController.sink.add(mList);
  }

  Future<bool> getAllDepartaments() async {
    final url = "$baseUrlAPI/departaments?auth=$globalToken";
    final res = await http.get(url);
    final data = departamentsModelFromJson(res.body);

    final departaments = data.departaments;
    _allDepartamentsController.sink.add(departaments);
    return true;
  }

  Future<bool> getAllProvinces(String departamentCode) async {
    final url = "$baseUrlAPI/$departamentCode/provinces?auth=$globalToken";
    final res = await http.get(url);
    final data = provincesModelFromJson(res.body);
    final provinces = data.provinces;
    _allProvincesController.sink.add(provinces);
    return true;
  }

  Future<bool> getAllDistricts(String provinceCode) async {
    final url =
        "$baseUrlAPI/$departamentSelected/$provinceCode/districts?auth=$globalToken";
    final res = await http.get(url);
    final data = dIstrictsModelFromJson(res.body);
    final districts = data.districts;
    _allDistrictsController.sink.add(districts);
    return true;
  }

  //Propertys

  List<Widget> _forms = [
    UserReferencePage(),
    PaymentResumePage(),
  ];

  List<Widget> get listForms => this._forms;

  String _departamentSelected = "0";

  String get departamentSelected => this._departamentSelected;

  set departamentSelected(String value) {
    this._departamentSelected = value;
    this.getAllProvinces(value);
    notifyListeners();
  }

  String _provinceSelected = "0";

  String get provinceSelected => this._provinceSelected;

  set provinceSelected(String value) {
    this._provinceSelected = value;
    this.getAllDistricts(value);
    notifyListeners();
  }

  String _districtSelected = "0";

  String get districtSelected => this._districtSelected;

  set districtSelected(String value) {
    this._districtSelected = value;
    notifyListeners();
  }

  PaymentOptions _paymentOptionSelected = PaymentOptions.efective;

  PaymentOptions get paymentOptionSelected => this._paymentOptionSelected;

  set paymentOptionSelected(PaymentOptions value) {
    this._paymentOptionSelected = value;
    if (paymentOptionSelected == PaymentOptions.card) {
      this._forms.insert(1, CardPaymentPage());
      this._effectiveEntered = ValidationItem('0.0', null);
    } else {
      this._forms.removeAt(1);
    }
    notifyListeners();
  }

  ValidationItem _effectiveEntered = new ValidationItem(null, null);

  ValidationItem get effectiveEntered => this._effectiveEntered;

  void changeEffective(String value) {
    // TODO : MONTO TOTAL COGER
    print("veri: $value");
    if (double.parse(value) > 20) {
      this._effectiveEntered = ValidationItem(value, null);
    } else {
      this._effectiveEntered = ValidationItem('0.0', 'Monto incorrecto');
    }
    notifyListeners();
  }

  String _addressFrecuentlySelected = '00';

  String get addressFrecuentlySelected => this._addressFrecuentlySelected;

  void changeAddressFrecuently(String selected) async {


    this._addressFrecuentlySelected = selected;

//    this._departamentSelected = "00";
//    this._provinceSelected = "00";
//    this._districtSelected = "00";

    _userDirectionsController.value.forEach((element) {
      element.forEach((key, address) {
        if (key == selected) {
          this.addressController.text = address.direction;
          this.referenceController.text = address.reference;

          _allDepartamentsController.value.forEach((dpt) async {
            if (dpt.name == address.departament) {
              this.departamentSelected = dpt.ucode;
              await this.getAllProvinces(dpt.ucode);

              _allProvincesController.value.forEach((prv) async {
                if (prv.name == address.province) {
                  this.provinceSelected = prv.ucode;
                  await this.getAllDistricts(prv.ucode);

                  _allDistrictsController.value.forEach((dist) async{
                    if (dist.name == address.district) {
                      this.districtSelected = dist.ucode;
                    }
                  });
                }
              });
            }
          });
        }
      });
    });
    print("e.e");
    notifyListeners();
  }

  TextEditingController addressController = new TextEditingController();
  ValidationItem _addressEntered = new ValidationItem(null, null);

  ValidationItem get addressEntered => this._addressEntered;

  void changeAddress(String value) {
    if (value.trim().length > 5) {
      this._addressEntered = ValidationItem(value, null);
    } else {
      this._addressEntered = ValidationItem(null, 'Dirección incorrecta');
    }

    notifyListeners();
  }

  ValidationItem _phoneEntered = new ValidationItem(null, null);

  ValidationItem get phoneEntered => this._phoneEntered;

  void changePhone(String value) {
    if (value.trim().length == 9 || value.trim().length == 6) {
      this._phoneEntered = ValidationItem(value, null);
    } else {
      this._phoneEntered = ValidationItem(null, 'Teléfono incorrecto');
    }

    notifyListeners();
  }

  TextEditingController referenceController = TextEditingController();
  ValidationItem _referenceEntered = new ValidationItem(null, null);

  ValidationItem get referenceEntered => this._referenceEntered;

  void changeReference(String value) {
    if (value.trim().length > 10) {
      this._referenceEntered = ValidationItem(value, null);
    } else {
      this._referenceEntered = ValidationItem(null, 'Referencia incorrecta');
    }
    notifyListeners();
  }

  String _observationEntered;

  String get observationEntered => this._observationEntered;

  void changeObservation(String value) {
    this._observationEntered = value;
  }

  bool getValidations() {
//    print("v: ${this._effectiveEntered.value}");
//    print("v2: ${this.paymentOptionSelected}");
//    print(
//        "vf: ${(this.paymentOptionSelected == PaymentOptions.efective && this._effectiveEntered.value != '0.0')}");
    if (this._addressEntered.value != null &&
        this._phoneEntered.value != null &&
        this._referenceEntered.value != null &&
        this.departamentSelected != '0' &&
        this.provinceSelected != '0' &&
        this.districtSelected != '0') {
      if (this.paymentOptionSelected == PaymentOptions.efective &&
          this._effectiveEntered.value == '0.0') {
        return false;
      }

      return true;
    } else {
      (this._phoneEntered.value == null)
          ? this.changePhone('')
          : this.changePhone(this._phoneEntered.value);

      (this._addressEntered.value == null)
          ? this.changeAddress('')
          : this.changeAddress(this._addressEntered.value);

      (this._referenceEntered.value == null)
          ? this.changeReference('')
          : this.changeReference(this._referenceEntered.value);

      (this.paymentOptionSelected == PaymentOptions.efective &&
              (this.effectiveEntered.value == '0.0' ||
                  this.effectiveEntered.value == null))
          ? this.changeEffective('0.0')
          : this.changeEffective(this._effectiveEntered.value);

      return false;
    }
  }

  void addressListener() {
    addressController.addListener(() {
      final value = addressController.text;
      if (value.trim().length > 5) {
        this._addressEntered = ValidationItem(value, null);
      } else {
        this._addressEntered = ValidationItem(null, 'Dirección incorrecta');
        notifyListeners();
      }
    });
  }

  void referenceListener() {
    referenceController.addListener(() {
      final value = referenceController.text;
      if (value.trim().length > 10) {
        this._referenceEntered = ValidationItem(value, null);
      } else {
        this._referenceEntered = ValidationItem(null, 'Referencia incorrecta');
        notifyListeners();
      }
    });
  }

  StepsProvider() {
    addressListener();
    referenceListener();

    this.getUserDirections();
    this.getAllDepartaments();
  }
}

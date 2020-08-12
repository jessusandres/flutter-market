import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/models/departaments_model.dart';
import 'package:gustolact/src/models/districts_model.dart';
import 'package:gustolact/src/models/provinces_model.dart';
import 'package:gustolact/src/models/store_address_model.dart';
import 'package:gustolact/src/models/user_addresses_model.dart';
import 'package:gustolact/src/models/validation_model.dart';
import 'package:gustolact/src/options/payment_options.dart';
import 'package:gustolact/src/options/voucher_types.dart';
import 'package:gustolact/src/pages/checkout/card_payment.dart';
import 'package:gustolact/src/pages/checkout/quotation_data.dart';
import 'package:gustolact/src/pages/checkout/user_reference_page.dart';
import 'package:gustolact/src/pages/checkout/voucher_data.dart';
import 'package:gustolact/src/providers/cart_provider.dart';
import 'package:gustolact/src/providers/login_provider.dart';
import 'package:gustolact/src/shared_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class StepsProvider with ChangeNotifier {

  final CartProvider _cartProvider = CartProvider();
  final LoginProvider _loginProvider = LoginProvider();

  final UserPreferences _userPreferences = new UserPreferences();

  final RegExp regExp = new RegExp(emailPattern);

  bool _applyPayment = false;

  bool get applyPayment => this._applyPayment;

  set applyPayment(bool value) {
    this._applyPayment = value;
    notifyListeners();
  }

  BehaviorSubject<List<StoreAddress>> _allStoreAddressesController =
      new BehaviorSubject<List<StoreAddress>>();

  Stream<List<StoreAddress>> get storeAddressStrem =>
      _allStoreAddressesController.stream;

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
    _allStoreAddressesController.close();
    _allDepartamentsController.close();
    _allProvincesController.close();
    _allDistrictsController.close();
    _userDirectionsController.close();
    _loadingOptionsController.close();

    //INPUTS
    emailController.dispose();
    phoneController.dispose();
    effectiveController.dispose();
    referenceController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<dynamic> getUserDirections() async {

    final url =
        "$baseUrlAPI/user/${_userPreferences.userCode}/addresses";

    final res = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer ${_userPreferences.authToken}"
    });

    final userAddressesData = userAddressesFromJson(res.body);
    final userAddresses = userAddressesData.addresses;
    final List<Map<String, Address>> mList = [];
    userAddresses.forEach((element) {
      final mmap = {element.addressCode: element};
      mList.add(mmap);
    });

    _userDirectionsController.sink.add(mList);
    return true;
  }

  Future<bool> getAllStoreAddresses() async {
    final url = "$storeUrlAPI/addresses?auth=$globalToken";
    final res = await http.get(url);
    final data = storeAddressDataModelFromJson(res.body);
    final addresses = data.addresses;
    _allStoreAddressesController.sink.add(addresses);
    return true;
  }

  Future<bool> getAllDepartaments() async {
    final url = "$baseUrlAPI/locations/departaments?auth=$globalToken";
    final res = await http.get(url);
    final data = departamentsModelFromJson(res.body);

    final departaments = data.departaments;
    _allDepartamentsController.sink.add(departaments);
    return true;
  }

  Future<bool> getAllProvinces(String departamentCode) async {
    final url = "$baseUrlAPI/locations/$departamentCode/provinces?auth=$globalToken";
    final res = await http.get(url);
    final data = provincesModelFromJson(res.body);
    final provinces = data.provinces;
    _allProvincesController.sink.add(provinces);
    return true;
  }

  Future<bool> getAllDistricts(String provinceCode) async {
    final url =
        "$baseUrlAPI/locations/$departamentSelected/$provinceCode/districts?auth=$globalToken";
    final res = await http.get(url);

    final data = dIstrictsModelFromJson(res.body);
    final districts = data.districts;
    _allDistrictsController.sink.add(districts);
    return true;
  }

  //Propertys

  List<Widget> _forms = [
    UserReferencePage(),
    QuotationDataStep(),
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

  void changeProvince(String value, {bool charge = true}) {
    this._provinceSelected = value;
    if (charge) this.getAllDistricts(value);
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
      this._forms.insert(this._forms.length, CardPaymentPage());
      this._effectiveEntered = ValidationItem('0.0', null);
      this.effectiveController.text = '';
    } else {
      final findW =
          this._forms.firstWhere((element) => element is CardPaymentPage);
      this._forms.removeWhere((element) => element == findW);
    }
    notifyListeners();
  }

  bool _voucher = false;

  bool get voucher => this._voucher;

  set voucher(bool value) {
    this._voucher = value;
    if (voucher) {
      this._forms.insert(2, VoucherData());
    } else {
      final findW = this._forms.firstWhere((element) => element is VoucherData);
      this._forms.removeWhere((element) => element == findW);
    }
    notifyListeners();
  }

  VoucherTypes _voucherTypeSelected = VoucherTypes.boleta;

  VoucherTypes get voucherTypeSelected => this._voucherTypeSelected;

  set voucherTypeSelected(VoucherTypes value) {
    this._voucherTypeSelected = value;
    getVoucherValidations();
    notifyListeners();
  }

  String _storeAddressSelected = '00';

  String get storeAddressSelected => this._storeAddressSelected;

  set storeAddressSelected(String value) {
    this._storeAddressSelected = value;
    notifyListeners();
  }

  TextEditingController voucherNameController = new TextEditingController();
  ValidationItem _voucherNameEntered = new ValidationItem(null, null);

  ValidationItem get voucherNameEntered => this._voucherNameEntered;

  set voucherNameEntered(ValidationItem item) {
    final value = item.value;
    changeVoucherName(value);
    notifyListeners();
  }

  void changeVoucherName(String value) {
    if (value.trim().length < 5) {
      this._voucherNameEntered = ValidationItem(null,
          '${(voucherTypeSelected.index == 0 ? 'Nombre' : 'Razón Comercial')} incorrecto');
    } else {
      this._voucherNameEntered = ValidationItem(value, null);
    }
  }

  TextEditingController voucherDocController = new TextEditingController();
  ValidationItem _voucherDocEntered = new ValidationItem(null, null);

  ValidationItem get voucherDocEntered => this._voucherDocEntered;

  set voucherDocEntered(ValidationItem item) {
    final value = item.value;
    changeVoucherDoc(value, 1);
    notifyListeners();
  }

  void changeVoucherDoc(String value, int pos) {
    if (voucherTypeSelected.index == 0) {
      value.trim().length == 8
          ? this._voucherDocEntered = ValidationItem(value, null)
          : this._voucherDocEntered = ValidationItem(null, 'DNI incorrecto');
    } else {
      value.trim().length == 11
          ? this._voucherDocEntered = ValidationItem(value, null)
          : this._voucherDocEntered = ValidationItem(null, 'RUC incorrecto');
    }

    notifyListeners();
  }

  TextEditingController emailController = new TextEditingController();
  ValidationItem _emailEntered = new ValidationItem(null, null);

  ValidationItem get emailEntered => this._emailEntered;

  void changeEmail(String payEmail) {
    if (payEmail == null) {
      this._emailEntered = ValidationItem(null, 'Email incorrecto');
      notifyListeners();
      return;
    }

    if (regExp.hasMatch(payEmail)) {
      this._emailEntered = ValidationItem(payEmail, null);
    } else {
      this._emailEntered = ValidationItem(null, 'Email incorrecto');
    }
    notifyListeners();
  }

  TextEditingController effectiveController = new TextEditingController();
  ValidationItem _effectiveEntered = new ValidationItem(null, null);

  ValidationItem get effectiveEntered => this._effectiveEntered;

  void changeEffective(String value) {
    if (value == null) {
      this._effectiveEntered = ValidationItem(
          '0.0', 'Monto incorrecto, mínimo: ${_cartProvider.totalCart}');
    } else {
      if (double.parse(value) > _cartProvider.totalCart) {
        this._effectiveEntered = ValidationItem(value, null);
      } else {
        this._effectiveEntered = ValidationItem(
            '0.0', 'Monto incorrecto, mínimo: ${_cartProvider.totalCart}');
      }
    }

    notifyListeners();
  }

  String _addressFrecuentlySelected = '00';

  String get addressFrecuentlySelected => this._addressFrecuentlySelected;

  void changeAddressFrecuently(String selected) async {
    _allProvincesController.sink.add(null);
    _allDistrictsController.sink.add(null);

    this._addressFrecuentlySelected = selected;

    _userDirectionsController.value.forEach((element) {
      element.forEach((key, address) {
        if (key == selected) {
          this.addressController.text = address.direction;
          this.referenceController.text = address.reference;

          _allDepartamentsController.value.forEach((dpt) {
            if (dpt.name == address.departament) {
              this._departamentSelected = dpt.ucode;
              this.getAllProvinces(dpt.ucode).then((_) => {
                    _allProvincesController.value.forEach((prov) {
                      if (prov.name.trim() == address.province.trim()) {
                        this.getAllDistricts(prov.ucode).then((_) {
                          for (final dist in _allDistrictsController.value) {
                            if (dist.name.trim() == address.district.trim()) {
                              this._districtSelected = dist.ucode;
                              break;
                            }
                          }
                          this._provinceSelected = prov.ucode;
                          notifyListeners();
                        });
                        return;
                      }
                    })
                  });
            }
          });
        }
      });
    });
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

  TextEditingController phoneController = new TextEditingController();
  ValidationItem _phoneEntered = new ValidationItem(null, null);

  ValidationItem get phoneEntered => this._phoneEntered;

  void changePhone(String value) {
    if (value == null) {
      this._phoneEntered = ValidationItem(null, 'Teléfono incorrecto');
    } else {
      if (value.trim().length == 9 || value.trim().length == 6) {
        this._phoneEntered = ValidationItem(value, null);
      } else {
        this._phoneEntered = ValidationItem(null, 'Teléfono incorrecto');
      }
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
    if (this._addressEntered.value != null &&
        this._phoneEntered.value != null &&
        this._referenceEntered.value != null &&
        this.departamentSelected != '0' &&
        this.provinceSelected != '0' &&
        this.districtSelected != '0') {
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

      return false;
    }
  }

  bool getQuotationValidations({bool anotherPage = false}) {
    if (anotherPage) {
      if (this.storeAddressSelected != '00') {
        if (this.paymentOptionSelected == PaymentOptions.efective &&
            (this._effectiveEntered.value == '0.0' ||
                this._effectiveEntered.value == null)) {
          return false;
        }
        return true;
      } else {
        return false;
      }
    } else {
      if (this.storeAddressSelected != '00') {
        if (this.paymentOptionSelected == PaymentOptions.efective &&
            (this._effectiveEntered.value == '0.0' ||
                this._effectiveEntered.value == null)) {
          this.changeEffective("0.0");
          return false;
        }
        return true;
      } else {
        return false;
      }
    }
  }

  bool getVoucherValidations({bool anotherPage = false}) {
    if (anotherPage) {
      if (this.voucherDocEntered.value != null &&
          this.voucherNameEntered.value != null) {
        return true;
      } else {
        return false;
      }
    } else {
      (this.voucherDocEntered.value == null)
          ? this.changeVoucherDoc('', 0)
          : this.changeVoucherDoc(this.voucherDocEntered.value, 3);
      (this.voucherNameEntered.value == null)
          ? this.changeVoucherName('')
          : this.changeVoucherName(this.voucherNameEntered.value);

      if (this.voucherDocEntered.error != null ||
          this.voucherNameEntered.error != null) {
        return false;
      } else {
        return true;
      }
    }
  }

  bool getAllValidations() {
    final validation1 = this.getValidations();
    if (validation1 && this.emailEntered.value != null) {
      return true;
    } else {
      this.changeEmail(this.emailEntered.value);
      return false;
    }
  }

  Future<dynamic> generateQuotation() async {
    final dptName = this
        ._allDepartamentsController
        .value
        .firstWhere((dpt) => dpt.ucode == departamentSelected)
        .name;
    final prvName = this
        ._allProvincesController
        .value
        .firstWhere((prv) => prv.ucode == provinceSelected)
        .name;
    final dstName = this
        ._allDistrictsController
        .value
        .firstWhere((dst) => dst.ucode == districtSelected)
        .name;

    final Map<String, dynamic> payload = {
      "provinceName": prvName,
      "departamentName": dptName,
      "districtName": dstName,
      "effectiveAmmount": this.effectiveEntered.value,
      "warehouseCode": this.storeAddressSelected,
      "phone": phoneEntered.value,
      "address": addressEntered.value,
      "reference": referenceEntered.value,
      "ubigeo": "$departamentSelected-$provinceSelected-$districtSelected",
      "observation": observationEntered ?? '',
      "voucher": voucher
    };

    if (voucher) {
      payload.addAll({
        "voucherType": (voucherTypeSelected.index == 0) ? 'B' : 'F',
        "voucherName": voucherNameEntered.value,
        "voucherDocument": voucherDocEntered.value
      });
    }

    print(payload);
  }

  Future<dynamic> generatePayment(String token, String email) async {
    this.applyPayment = true;
    final dptName = this
        ._allDepartamentsController
        .value
        .firstWhere((dpt) => dpt.ucode == departamentSelected)
        .name;
    final prvName = this
        ._allProvincesController
        .value
        .firstWhere((prv) => prv.ucode == provinceSelected)
        .name;
    final dstName = this
        ._allDistrictsController
        .value
        .firstWhere((dst) => dst.ucode == districtSelected)
        .name;

    final url =
        "$baseUrlAPI/payment/culqi/$urlStore/${_userPreferences.userCode}";

    final payload = {
      "email": email,
      "token": token,
      "provinceName": prvName,
      "departamentName": dptName,
      "districtName": dstName,
      "effectiveAmmount": this.effectiveEntered.value,
      "warehouseCode": this.storeAddressSelected,
      "phone": phoneEntered.value,
      "address": addressEntered.value,
      "reference": referenceEntered.value,
      "ubigeo": "$departamentSelected-$provinceSelected-$districtSelected",
      "observation": observationEntered ?? '',
      "voucher": voucher.toString()
    };

    if (voucher) {
      payload.addAll({
        "voucherType": (voucherTypeSelected.index == 0) ? 'B' : 'F',
        "voucherName": voucherNameEntered.value,
        "voucherDocument": voucherDocEntered.value
      });
    }

    final response = await http.post(url, body: payload, headers: {
      HttpHeaders.authorizationHeader: "Bearer ${_userPreferences.authToken}"
    });
    final res = response.body;
    print("body: $res");
    final decoded = jsonDecode(res);
    this.applyPayment = false;
    return decoded;
//    return {"ok": false, "message": 'En prueba'};
  }

  void addressListener() {
    addressController.addListener(() {
      final value = addressController.text;
      if (value.trim().length > 5) {
        this._addressEntered = ValidationItem(value, null);
      } else {
        this._addressEntered = ValidationItem(null, 'Dirección incorrecta');
      }
      notifyListeners();
    });
  }

  void referenceListener() {
    referenceController.addListener(() {
      final value = referenceController.text;
      if (value.trim().length > 10) {
        this._referenceEntered = ValidationItem(value, null);
      } else {
        this._referenceEntered = ValidationItem(null, 'Referencia incorrecta');
      }
      notifyListeners();
    });
  }

  void phoneListener() {
    phoneController.addListener(() {
      final value = phoneController.text;
      if (value.trim().length == 9 || value.trim().length == 6) {
        this._phoneEntered = ValidationItem(value, null);
      } else {
        this._phoneEntered = ValidationItem(null, 'Teléfono incorrecto');
      }
      notifyListeners();
    });
  }

  void effectiveListener() {
    effectiveController.addListener(() {
      final value = effectiveController.text;
      if (value == null) {
        this._effectiveEntered = ValidationItem(
            '0.0', 'Monto incorrecto, mínimo: ${_cartProvider.totalCart}');
      } else {
        if (value.trim().length == 0) {
          this._effectiveEntered = ValidationItem(
              '0.0', 'Monto incorrecto, mínimo: ${_cartProvider.totalCart}');
        } else {
          if (double.parse(value) > _cartProvider.totalCart) {
            this._effectiveEntered = ValidationItem(value, null);
          } else {
            this._effectiveEntered = ValidationItem(
                '0.0', 'Monto incorrecto, mínimo: ${_cartProvider.totalCart}');
          }
        }
      }
      notifyListeners();
    });
  }

  void emailListener() {
    emailController.addListener(() {
      final payEmail = emailController.text;

      if (regExp.hasMatch(payEmail)) {
        this._emailEntered = ValidationItem(payEmail, null);
      } else {
        this._emailEntered = ValidationItem(null, 'Email incorrecto');
      }
      notifyListeners();
    });
  }

  void voucherNameListener() {
    voucherNameController.addListener(() {
      changeVoucherName(voucherNameController.text);
      notifyListeners();
    });
  }

  void voucherDocListener() {
    voucherDocController.addListener(() {
      changeVoucherDoc(voucherDocController.text, 4);
      notifyListeners();
    });
  }

  StreamController<bool> _loadingOptionsController = BehaviorSubject<bool>();

  Stream<bool> get loadingStream => this._loadingOptionsController.stream;

  void setLoading(bool value) {
    _loadingOptionsController.sink.add(value);
  }

  void setInputListeners() {
    addressListener();
    referenceListener();
    phoneListener();
    effectiveListener();
    emailListener();
    voucherNameListener();
    voucherDocListener();
  }

  StepsProvider() {
    setLoading(true);

    setInputListeners();

    Future.wait([
      getUserDirections(),
      getAllDepartaments(),
      getAllStoreAddresses(),
      _loginProvider.verifyLogin()
    ]).then((_) {
      this._loginProvider.setUserData().then((_) {
        phoneController.text = _userPreferences.userPhone;
        emailController.text = _userPreferences.userEmail;
        this._cartProvider.getCart().then((_) {
          setLoading(false);
        });
      });
    });
  }
}

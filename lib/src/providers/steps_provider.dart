import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/models/departaments_model.dart';
import 'package:gustolact/src/models/districts_model.dart';
import 'package:gustolact/src/models/provinces_model.dart';
import 'package:gustolact/src/options/payment_options.dart';
import 'package:http/http.dart' as http;

class StepsProvider with ChangeNotifier {

  StreamController<List<Departament>> _allDepartamentsController = new StreamController<List<Departament>>.broadcast();
  Stream<List<Departament>> get departamentsStream => _allDepartamentsController.stream;

  StreamController<List<Province>> _allProvincesController = new StreamController<List<Province>>.broadcast();
  Stream<List<Province>> get provincesStream => _allProvincesController.stream;

  StreamController<List<District>> _allDistrictsController = new StreamController<List<District>>.broadcast();
  Stream<List<District>> get districtsStream => _allDistrictsController.stream;

  @override
  void dispose() {
    _allDepartamentsController.close();
    _allProvincesController.close();
    _allDistrictsController.close();
    super.dispose();
  }

  void getAllDepartaments() async{
    final url = "$baseUrlAPI/departaments?auth=$globalToken";
    final res = await http.get(url);
    final data = departamentsModelFromJson(res.body);

    final departaments = data.departaments;
    _allDepartamentsController.sink.add(departaments);

  }

  void getAllProvinces(String departamentCode) async{
    final url = "$baseUrlAPI/$departamentCode/provinces?auth=$globalToken";
    final res = await http.get(url);
    final data = provincesModelFromJson(res.body);
    final provinces = data.provinces;
    _allProvincesController.sink.add(provinces);
  }

  void getAllDistricts(String provinceCode) async{
    final url = "$baseUrlAPI/$departamentSelected/$provinceCode/districts?auth=$globalToken";
    final res = await http.get(url);
    final data = dIstrictsModelFromJson(res.body);
    final districts = data.districts;
    _allDistrictsController.sink.add(districts);
  }

  //Propertys

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
    notifyListeners();
  }

  StepsProvider() {
    this.getAllDepartaments();
  }

}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/models/filter_model.dart';
import 'package:gustolact/src/models/filter_model.dart';
import 'package:gustolact/src/models/filter_model.dart';
import 'package:gustolact/src/models/product_model.dart';
import 'package:gustolact/src/providers/product_provider.dart';
import 'package:http/http.dart' as http;

class SearchProvider with ChangeNotifier{

  List<FilterModel> _brands = [];
  get brands => this._brands;

  List<FilterModel> _lines = [];
  get lines => this._lines;

  Map<String, List<FilterModel>> _sublines = {};
  get sublines => this._sublines;


  List<ProductModel> _sugerences = [];
  get sugerences => this._sugerences;
  set sugerences(List<ProductModel> list) => this._sugerences = list;

  String _query = '';
  get query => this._query;
  set query(String value) {
    this._query = value;
//    notifyListeners();
  }

  String lineSelected = '0';
  String subLineSelected = '0';
  String brandSelected = '0';

  getLines() async{

    if(lines.length > 0) return this.lines;

    final url = '$storeUrlAPI/lines?auth=$globalToken';

    final response = await http.get(url);

    final data = jsonDecode(response.body);

    final toParse = jsonEncode(data['lines']);

    final linesRecived = filterModelFromJson(toParse);

    this._lines.addAll(linesRecived);

    linesRecived.forEach((element) {
      this._sublines[element.code] = [];
    });

    return linesRecived;
  }

  getSubLines(String line) async{

    if(sublines[line].length > 0) return this.sublines;

    final url = '$storeUrlAPI/$line/sublines?auth=$globalToken';

    final response = await http.get(url);

    final data = jsonDecode(response.body);

    final toParse = jsonEncode(data['sublines']);

    final sublinesRecived = filterModelFromJson(toParse);

    this._sublines[line].addAll(sublinesRecived);

    return sublinesRecived;
  }

  getBrands() async {

  }

  SearchProvider(){
    print('==SEARCH PROVIDER==');
    this.getLines();
    this.getBrands();
  }

  Future<List<ProductModel>>filterByName(String query, ProductProvider productProvider) async {

    if(sugerences.length > 0 ) return sugerences;

    final allProducts = await productProvider.getAllProducts();

    List<ProductModel> currentSugerences = [];

    allProducts.forEach((element) {

      if(element.name.toLowerCase().contains(query.toLowerCase())) {
        currentSugerences.add(element);
      }

    });

    return currentSugerences;

  }




}
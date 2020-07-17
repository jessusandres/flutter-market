import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/models/filter_model.dart';
import 'package:gustolact/src/models/product_model.dart';
import 'package:gustolact/src/providers/product_provider.dart';
import 'package:http/http.dart' as http;

class SearchProvider with ChangeNotifier {

  List<FilterModel> _brands = [];
  get brands => this._brands;

  List<FilterModel> _lines = [];
  get lines => this._lines;

  List<FilterModel> _sublines = [];
  get sublines => this._sublines;
  set sublines(List<FilterModel> list){
    this._sublines = list;
  }

  List<ProductModel> _sugerences = [];

  get sugerences => this._sugerences;

  set sugerences(List<ProductModel> list) => this._sugerences = list;

  String _query = '';

  get query => this._query;

  set query(String value) {
    this._query = value;
//    notifyListeners();
  }

  String _lineSelected = '0';

  get lineSelected => this._lineSelected;

  set lineSelected(String value) {
    print("change line");
    this._lineSelected = value;
    notifyListeners();
  }

  String _subLineSelected = '0';

  get subLineSelected => this._subLineSelected;

  set subLineSelected(String value) {
    this._subLineSelected = value;
    notifyListeners();
  }

  String _brandSelected = '0';

  get brandSelected => this._brandSelected;

  set brandSelected(String value) {
    this._brandSelected = value;
    notifyListeners();
  }


  List<ProductModel> filterResults = [];

  getLines() async {

    if (lines.length > 0) return this.lines;

    final url = '$storeUrlAPI/lines?auth=$globalToken';

    final response = await http.get(url);

    final data = jsonDecode(response.body);

    final toParse = jsonEncode(data['lines']);

    final linesRecived = filterModelFromJson(toParse);

    this._lines.addAll(linesRecived);

    notifyListeners();

    return linesRecived;

  }

  getSubLines(String line) async {

    if (sublines.length > 0) return this.sublines;

    final url = '$storeUrlAPI/$line/sublines?auth=$globalToken';
    print(url);
    final response = await http.get(url);

    final data = jsonDecode(response.body);

    final toParse = jsonEncode(data['sublines']);

    final sublinesRecived = filterModelFromJson(toParse);

    print("recived: $sublinesRecived");
    this._sublines.addAll(sublinesRecived);

    notifyListeners();

    return sublinesRecived;

  }

  getBrands() async {

    if (brands.length > 0) return this.brands;

    final url = '$storeUrlAPI/brands?auth=$globalToken';

    final response = await http.get(url);

    final data = jsonDecode(response.body);

    final toParse = jsonEncode(data['brands']);

    final brandsRecived = filterModelFromJson(toParse);

    this._brands.addAll(brandsRecived);

    notifyListeners();

    return brandsRecived;

  }

  reset() {
    this.query = '';
    this.filterResults = [];
    notifyListeners();
  }

  Timer mtimer;

  bool _load = false;
  get load => this._load;

  set load(bool val) {
    this._load   = val;
  }

  Future<List<ProductModel>> filterProducts() async{

    this.filterResults = [];
    load = true;

    String itemName = 'all';
//    print("queryo: ${this._query.trim().length}");
    if(this._query.trim().length > 0) {
      itemName = query;
    }
    print("query: $itemName");
    final url = '$storeUrlAPI/search/products?line=$lineSelected&subline=$subLineSelected&brand=$brandSelected&item=$itemName&auth=$globalToken';
    print("url: $url");
    final response = await http.get(url);

    final data = jsonDecode(response.body);
    print("data: $data");

    if(data['ok'] == false) {
      return [];
    }

    final toParse = jsonEncode(data['products']);



    final productsRecived = productModelFromJson(toParse);


    this.filterResults.addAll(productsRecived);

    load = false;

    return this.filterResults;

  }


  searchProducts(String query, ProductProvider productProvider) async{

//    if(query.trim().length <= 3) return this.filterResults;
print("search");
    this.filterResults = [];

    final allProducts = productProvider.products;

    List<ProductModel> currentResults = [];

    allProducts.forEach((element) {
      if (element.name.toLowerCase().contains(query.toLowerCase())) {
        currentResults.add(element);
      }
    });

//    return currentSugerences;

    this.filterResults.addAll(currentResults);
    notifyListeners();
//    return  this.filterResults;

  }

  SearchProvider() {
    print('==SEARCH PROVIDER==');
  }

  Future<List<ProductModel>> filterByName(

      String query, ProductProvider productProvider) async {

    if (sugerences.length > 0) return sugerences;

    final allProducts = await productProvider.getAllProducts();

    List<ProductModel> currentSugerences = [];

    //TODO: opcional colocar un limite
    allProducts.forEach((element) {
      if (element.name.toLowerCase().contains(query.toLowerCase())) {
        currentSugerences.add(element);
      }
    });

    return currentSugerences;
  }
}

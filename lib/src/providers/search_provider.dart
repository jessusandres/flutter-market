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
  set sublines(List<FilterModel> list) {
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

  List<ProductModel> _filterResults = [];

  List<ProductModel> get filterResults => this._filterResults;

  set filterResults(List<ProductModel> filterResults) {
    this._filterResults = filterResults;
  }

  int _order = 0;

  int get order => this._order;

  set order(int order) {
    this._order = order;
    notifyListeners();
  }



  reset() {
    this.query = '';
    this.filterResults = [];
    notifyListeners();
    this.order = 0;
  }

  resetFilters() {

    this.lineSelected = '0';
    this.brandSelected = '0';
    this.subLineSelected = '0';
    notifyListeners();
    this.order = 0;
  }

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

    final response = await http.get(url);

    final data = jsonDecode(response.body);

    final toParse = jsonEncode(data['sublines']);

    final sublinesRecived = filterModelFromJson(toParse);

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

  bool _load = false;
  get load => this._load;
  set load(bool val) {
    this._load = val;
  }

  bool _showBottomButton;

  bool get showBottomButton => this._showBottomButton;

  set showBottomButton(bool showBottomButton) {
    this._showBottomButton = showBottomButton;
  }

  bool _loadQuery = true;

  bool get loadQuery => this._loadQuery;

  set loadQuery(bool loadQuery) {
    this._loadQuery = loadQuery;
  }

  Timer mtimer;

  filterProducts() async {

    this.showBottomButton = false;

    this.filterResults = [];

    String itemName = 'all';

    if (this._query.trim().length > 0) {
      itemName = query;
    }


    final url =
        '$storeUrlAPI/search/products?line=$lineSelected&subline=$subLineSelected&brand=$brandSelected&item=$itemName&auth=$globalToken';

    final response = await http.get(url);


    final data = jsonDecode(response.body);

    if (data['ok'] == false) {
      this.filterResults = [];
      this.loadQuery = false;
      notifyListeners();
      return;
    }


    final toParse = jsonEncode(data['products']);

    final productsRecived = productModelFromJson(toParse);

    if ( this.order == 1 ) {
      productsRecived.sort((a, b) => a.webPrice.compareTo(b.webPrice));
    }

    if( this.order == 2 ) {
      productsRecived.sort((a, b) => b.webPrice.compareTo(a.webPrice));
    }

    this.filterResults.addAll(productsRecived);

    this.loadQuery = false;
    notifyListeners();

  }

  searchProducts(String query, ProductProvider productProvider) async {
    this.filterResults = [];

    final allProducts = productProvider.products;

    List<ProductModel> currentResults = [];

    allProducts.forEach((element) {
      if (element.name.toLowerCase().contains(query.toLowerCase())) {
        currentResults.add(element);
      }
    });

    this.filterResults.addAll(currentResults);
    notifyListeners();
  }

  SearchProvider();

  Future<List<ProductModel>> filterByName(
      String query, ProductProvider productProvider) async {
    if (sugerences.length > 0) return sugerences;

    final allProducts = await productProvider.getAllProducts();

    List<ProductModel> currentSugerences = [];

    int maximo = 10;
    for (ProductModel element in allProducts) {
      if (element.name.toLowerCase().contains(query.toLowerCase())) {
        currentSugerences.add(element);
        maximo--;
      }
      if (maximo == 0) {
        break;
      }
    }

    return currentSugerences;
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gustolact/src/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/models/image_model.dart';

class ProductProvider with ChangeNotifier {

  final _token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiYW5kcmV3IiwicGFzcyI6ImJsbW9udDEwIiwiaWQiOjIwMjAwM30.WwgI6w5rWu5yXdxuKFsPWhA-4pAl1XoyHVHcKVvjZZ8';
  final _url = 'https://tuquepides.com/api';


  bool _loading = true;
  bool get loading => this._loading;

  set loading(bool value){

    if(value) {

      this._loading = value;

    }else {

      this._loading = value;

      if(this._mainLoading) {
        this.mainLoading = false;
      }else {
        notifyListeners();
      }


    }

  }

  bool _mainLoading = true;
  get mainLoading => this._mainLoading;

  set mainLoading(bool value) {

    this._mainLoading = value;
    if(value) {
      notifyListeners();
    }else {
      Timer timer;
      timer = Timer(
          Duration(seconds: 3),
              (){
            notifyListeners();
            timer.cancel();
          }
      );
    }

  }


  Map<String, List<ImageModel>> _productImages = {};
  Map<String, List<ImageModel>> get productImages => this._productImages;



  List<ProductModel> _allProducts = new List();
  List<ProductModel> get products => this._allProducts;
  set products(List<ProductModel> list) => this._allProducts.addAll(list);




  Map<String, List<ImageModel>> _productRelated = {};
  Map<String, List<ImageModel>> get productRelated => this._productRelated;


  //FUNCTIONS

  Future<List<ProductModel>>getAllProducts() async {

    if (products.length > 0) return this.products ;

    return await this.refreshProducts();

  }

  getProductImages(String code) async {

    if (productImages[code].length > 0) {
      return;
    } else {

      final url = '$_url/store/$urlStore/images/$code?auth=$_token';
      final response = await http.get(url);
      final jsnresponse = jsonDecode(response.body);
      final encoded = jsonEncode(jsnresponse['results']);
      List<ImageModel> images = imageModelFromJson(encoded);


      this._productImages[code].addAll(images);
      notifyListeners();

    }
  }

  Future<List<ProductModel>> refreshProducts() async{

    loading = true;

    final url = '$_url/store/$urlStore/products?auth=$_token';

    final response = await http.get(url);
    final productsRes = jsonDecode(response.body);

    final encoded = jsonEncode(productsRes['data']);
    this.products = productModelFromJson(encoded);

    this.products.forEach((element) {
      this.productImages[element.codi] = new List();
      this.productRelated[element.codi] = new List();
    });

    loading = false;

    return this.products;
  }

  getRelatedProducts(String codi) async{

    if(this.productRelated[codi].length > 0 ) {
      return;
    }

    loading = true;
    final url = '$_url/store/$urlStore/related/$codi?auth=$_token';
    final response = await http.get(url);
    final productsRel = jsonDecode(response.body);

    print("responserelated: $productsRel");

    final encoded = jsonEncode(productsRel['related']);
    List<ImageModel> images = imageModelFromJson(encoded);
    this.productRelated[codi].addAll(images);
    loading = false;

  }


  ProductProvider() {
    this.getAllProducts();
  }

}
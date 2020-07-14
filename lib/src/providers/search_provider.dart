import 'package:flutter/material.dart';
import 'package:gustolact/src/models/product_model.dart';
import 'package:gustolact/src/providers/product_provider.dart';
import 'package:http/http.dart' as http;

class SearchProvider with ChangeNotifier{

  Map<String, String> brands = {};
  Map<String, String> line = {};
  Map<String, String> subline = {};

  List<ProductModel> sugerences = [];

  String query;

  getLines() async{
  }

  SearchProvider() {
    print('==SEARCH PROVIDER==');
    this.getLines();
  }

  Future<List<ProductModel>>filterByName(String query, ProductProvider productProvider) async{

    print(sugerences.length);
    if(sugerences.length > 0 ) return sugerences;
    final allProducts = await productProvider.getAllProducts();
    List<ProductModel> currentSugerences = [];
    allProducts.forEach((element) {
      print(element.name);
      if(element.name.toLowerCase().contains(query.toLowerCase())) {
        currentSugerences.add(element);
      }
    });

    return currentSugerences;

  }


}
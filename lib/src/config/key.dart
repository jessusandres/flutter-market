import 'package:flutter/material.dart';
import 'package:gustolact/src/models/product_model.dart';
import 'package:gustolact/src/pages/product_detail_page.dart';
import 'package:gustolact/src/tansitions/fade_transition.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }
  Future<dynamic> navigateToDetail(ProductModel productModel) {
    print("show ${productModel.codi}");
//    return navigatorKey.currentState.pushNamed('product_detail', arguments: productModel);
    return navigatorKey.currentState.push(FadeRoute(page: ProductDetailPage(detailProduct: productModel)));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/models/product_model.dart';
import 'package:gustolact/src/pages/login_page.dart';
import 'package:gustolact/src/providers/cart_provider.dart';
import 'package:gustolact/src/providers/login_provider.dart';
import 'package:gustolact/src/providers/product_provider.dart';
import 'package:gustolact/src/tansitions/slide_transition.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:gustolact/src/themes/light_color.dart';
import 'package:gustolact/src/widgets/product_cards_widget.dart';
import 'package:gustolact/src/widgets/product_related_widget.dart';
import 'package:gustolact/src/widgets/title_text.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel detailProduct;

  ProductDetailPage({Key key, @required this.detailProduct}) : super(key: key);

  @override
  _ProductDetailPageState createState() =>
      _ProductDetailPageState(this.detailProduct);
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  final ProductModel _product;

  AnimationController controller;
  Animation<double> animation;

  _ProductDetailPageState(this._product);

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _productImage(ProductModel product) {
    return AnimatedBuilder(
      builder: (context, child) {
        return AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: animation.value,
          child: child,
        );
      },
      animation: animation,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            child: TitleText(
              text: storeName,
              fontSize: 60,
              color: LightColor.lightGrey,
            ),
          ),
          ProductCards(
            product: product,
          )
        ],
      ),
    );
  }

  Widget _detailWidget(ProductModel product, MediaQueryData media) {
    return DraggableScrollableSheet(
      maxChildSize: .8,
      initialChildSize: .53,
      minChildSize: .53,
      builder: (context, scrollController) {
        return Container(
          padding: AppTheme.padding.copyWith(bottom: 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Colors.white),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: 5),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                        color: LightColor.iconColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: Text(
                          product.name,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              TitleText(
                                text: "S/ ${product.webPrice} ",
                                fontSize: 18,
                                color: LightColor.red,
                              ),
                              TitleText(
                                text: "240",
                                fontSize: 25,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.star,
                                  color: LightColor.yellowColor, size: 17),
                              Icon(Icons.star,
                                  color: LightColor.yellowColor, size: 17),
                              Icon(Icons.star,
                                  color: LightColor.yellowColor, size: 17),
                              Icon(Icons.star,
                                  color: LightColor.yellowColor, size: 17),
                              Icon(Icons.star_border, size: 17),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _description(product, media),
                SizedBox(
                  height: 15,
                ),
                ProductRelatedCards(product: product)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _description(ProductModel product, MediaQueryData media) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 15),
          FittedBox(
            child: Text(
              "Descripción",
              style: TextStyle(
                  fontSize: media.textScaleFactor * 25,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(height: 8),
          Container(
            child: HtmlParser(
              htmlData: product.description,
              shrinkWrap: true,
              style: {
                "p": Style(
                    fontSize:
                        FontSize.percent((media.textScaleFactor * 130).toInt()),
                    textAlign: TextAlign.justify),
                "div": Style(
                    fontSize:
                        FontSize.percent((media.textScaleFactor * 130).toInt()),
                    textAlign: TextAlign.justify),
                "strong": Style(
                    fontSize:
                        FontSize.percent((media.textScaleFactor * 100).toInt()),
                    textAlign: TextAlign.justify),
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);


    _productProvider.getProductImages(_product.codi);
    _productProvider.getRelatedProducts(_product.codi);

    MediaQueryData media = MediaQuery.of(context);

    return Scaffold(
      floatingActionButton: ButtonFll(
        product: widget.detailProduct,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color(0xfffbfbfb),
              Color(0xfff7f7f7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
//                  _appBar(),
                  _productImage(_product),
                ],
              ),
              _detailWidget(_product, media)
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonFll extends StatelessWidget {
  final ProductModel product;

  const ButtonFll({@required this.product});

  @override
  Widget build(BuildContext context) {
    final LoginProvider _loginProvider = Provider.of<LoginProvider>(context);
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);

    return FloatingActionButton(
      onPressed: _cartProvider.executingAction
          ? null
          : () {
              if (_loginProvider.isLogged) {
                addItemToCart(context);
              } else {
                Navigator.push(context,
                    SlideTopRoute(page: LoginPage(showBackbutton: true)));
              }
            },
      backgroundColor: _cartProvider.executingAction ? AppTheme.grey : AppTheme.primaryColor,
      child: Icon(Icons.add_circle, color: AppTheme.white),
    );
  }

  addItemToCart(BuildContext context) async {
    final CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);

    final response =
        await cartProvider.addItemToCart(itemCode: product.codi, ammount: 1.0);
//    print(response);
    if (response["observation"] != null) {
      final osnackBar = SnackBar(
        content: Text(response["observation"]),
        action: SnackBarAction(
          label: 'Aceptar',
          onPressed: () {},
        ),
      );

      Scaffold.of(context).showSnackBar(osnackBar);
    }
    final snackBar = SnackBar(
      content: Text(response["message"]),
      action: SnackBarAction(
        label: 'Ocultar',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }
}

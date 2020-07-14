import 'package:flutter/material.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/models/product_model.dart';
import 'package:gustolact/src/providers/product_provider.dart';
import 'package:gustolact/src/themes/light_color.dart';
import 'package:gustolact/src/themes/theme.dart';
import 'package:gustolact/src/widgets/product_cards_widget.dart';
import 'package:gustolact/src/widgets/product_related_widget.dart';
import 'package:gustolact/src/widgets/title_text.dart';
import 'package:gustolact/src/widgets/extensions.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  ProductDetailPage({Key key}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

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

  bool isLiked = true;

  Widget _icon(
    IconData icon, {
    Color color = LightColor.iconColor,
    double size = 20,
    double padding = 10,
    bool isOutLine = false,
    Function onPressed,
  }) {
    return Container(
      height: 40,
      width: 40,
      padding: EdgeInsets.all(padding),
      // margin: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(
            color: LightColor.iconColor,
            style: isOutLine ? BorderStyle.solid : BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(13)),
        color:
            isOutLine ? Colors.transparent : Theme.of(context).backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Color(0xfff8f8f8),
              blurRadius: 5,
              spreadRadius: 10,
              offset: Offset(5, 5)),
        ],
      ),
      child: Icon(icon, color: color, size: size),
    ).ripple(() {
      if (onPressed != null) {
        onPressed();
      }
    }, borderRadius: BorderRadius.all(Radius.circular(13)));
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
              style: TextStyle(fontSize: media.textScaleFactor * 25, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(height: 8),
          Container(
            child: HtmlParser(
              htmlData: product.description,
              shrinkWrap: true,
              style: {
                "p": Style(fontSize: FontSize.percent((media.textScaleFactor * 130).toInt()), textAlign: TextAlign.justify),
                "div": Style(fontSize: FontSize.percent((media.textScaleFactor * 130).toInt()), textAlign: TextAlign.justify),
                "strong": Style(fontSize: FontSize.percent((media.textScaleFactor * 100).toInt()), textAlign: TextAlign.justify),
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of<ProductProvider>(context);

    ProductModel product = ModalRoute.of(context).settings.arguments;

    productProvider.getProductImages(product.codi);
    productProvider.getRelatedProducts(product.codi);

    MediaQueryData media = MediaQuery.of(context);

    return Scaffold(
      floatingActionButton: ButtonFll(),
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
                  _productImage(product),
                ],
              ),
              _detailWidget(product, media)
            ],
          ),
        ),
      ),
    );
  }


}

class ButtonFll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return FloatingActionButton(
      onPressed: () {

        final snackBar = SnackBar(
          content: Text('Producto agregado!'),
          action: SnackBarAction(
            label: 'Ocultar',
            onPressed: () {
              // Some code to undo the change.

            },
          ),
        );

        Scaffold.of(context).showSnackBar(snackBar);
      },
      backgroundColor: LightColor.orange,
      child: Icon(Icons.add_circle,
          color: Theme.of(context).floatingActionButtonTheme.backgroundColor),
    );
  }
}

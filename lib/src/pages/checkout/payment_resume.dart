import 'package:flutter/material.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/models/culqipaymentresponse_model.dart';
import 'package:gustolact/src/models/paymentItem.dart';
import 'package:gustolact/src/models/quotation_response.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:gustolact/src/widgets/appbar_payment_widget.dart';

class PaymentResumePage extends StatelessWidget {
  final CulqiPaymentResponse culqiPaymentResponse;
  final QuotationPaymentResponse quotationPaymentResponse;
//  final bool isCulqi;


  const PaymentResumePage({this.culqiPaymentResponse, this.quotationPaymentResponse});

  @override
  Widget build(BuildContext context) {

    final items = this.culqiPaymentResponse == null ? this.quotationPaymentResponse.items : this.culqiPaymentResponse.items;
    final isCulqi = this.culqiPaymentResponse == null ? false : true;
    final total = this.culqiPaymentResponse == null ? this.quotationPaymentResponse.total : this.culqiPaymentResponse.total;

    return Scaffold(
      appBar: AppBarPayment(title: 'Resumen de Compra'),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              child: Center(
                  child: Text(
                'Gracias por comprar en $storeName',
                style: AppTheme.title,
              )),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                'Productos facturados:',
                style: AppTheme.caption.copyWith(fontSize: 14),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ItemDetail(item: items[index]);
                    })),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                'Total ${ isCulqi ? 'pagado' : 'por pagar' } : $total',
                style: AppTheme.caption
                    .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemDetail extends StatelessWidget {
  const ItemDetail({
    Key key,
    @required this.item,
  }) : super(key: key);

  final PaymentItem item;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      child: ListTile(
        leading: Container(
          width: size.width * 0.3,
          child: FittedBox(
            fit: BoxFit.fill,
            alignment: Alignment.center,
            child: FadeInImage(
              placeholder: AssetImage('assets/gif/loading.gif'),
              image: NetworkImage(this.item.getImage()),
              fadeInCurve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        title: Text(
          this.item.cartItemDescription,
          style: AppTheme.caption.copyWith(fontSize: 13),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${this.item.cartItemAmmount} x ${this.item.cartItemPrice}'),
            Text(
                '${(this.item.cartItemAmmount * this.item.cartItemPrice).toStringAsFixed(2)}')
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}

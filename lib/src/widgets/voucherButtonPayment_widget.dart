import 'package:flutter/material.dart';
import 'package:gustolact/src/models/quotation_response.dart';
import 'package:gustolact/src/pages/checkout/payment_resume.dart';
import 'package:gustolact/src/providers/steps_provider.dart';
import 'package:gustolact/src/tansitions/fade_transition.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class VoucherButtonPayment extends StatelessWidget {

  final bool enable;
  const VoucherButtonPayment({@required this.enable});

  @override
  Widget build(BuildContext context) {
    final StepsProvider stepsProvider = Provider.of<StepsProvider>(context);

    return Container(
        child: RaisedButton(
          color: AppTheme.primaryColor,
          onPressed: (enable && !stepsProvider.applyPayment) ? (){generateQuotation(stepsProvider, context);} :  null,
          elevation: 0.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: Text(
            'Procesar Compra',
            style: TextStyle(color: AppTheme.white),
          ),
        ));
  }

  void generateQuotation (StepsProvider stepsProvider,BuildContext context) async{
//    print('generate payment e.e');
    final quotationResponse = await stepsProvider.generateQuotation();
    if(quotationResponse is QuotationPaymentResponse) {
      Navigator.pushReplacement(context,
          FadeRoute(page: PaymentResumePage(quotationPaymentResponse: quotationResponse)));
      Toast.show(quotationResponse.message, context,
          duration: 2, gravity: Toast.BOTTOM);
    }else {
      Toast.show(quotationResponse['message'], context,
          duration: 3, gravity: Toast.BOTTOM);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_culqi/flutter_culqi.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/providers/steps_provider.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class CardPaymentPage extends StatefulWidget {
  @override
  _CardPaymentPageState createState() => _CardPaymentPageState();
}

class _CardPaymentPageState extends State<CardPaymentPage> {
  GlobalKey<CulqiPaymentState> _widgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Center(child: Text('CARD PAYMENT PAGE'),),
//    );

    final StepsProvider stepsProvider = Provider.of<StepsProvider>(context);

    return Scaffold(
      body: Container(
        color: AppTheme.white,
        child: ListView(children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.symmetric(horizontal: 115),
            child: Text(
              'DATOS DE TARJETA',
              style: AppTheme.caption.copyWith(fontSize: 20),
            ),
          ),
          Divider(
            color: AppTheme.primaryColor,
            thickness: 1.3,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              maxLines: 1,
              autofocus: false,
              controller: stepsProvider.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                errorText: stepsProvider.emailEntered.error,
                labelText: 'Correo Electrónico',
                helperText: 'Su dirección de correo',
              ),
//                  onChanged: (String value){},
            ),
          ),
          SizedBox(
            height: 15,
          ),
          CulqiPayment(
            _widgetKey,
            locale: "es",
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: RaisedButton(
              color: AppTheme.primaryColor,
              onPressed: () {
                validateForm(context);
              },
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              child: Text(
                'Procesar Compra',
                style: TextStyle(color: AppTheme.white),
              ),
            ),
          )
        ]),
      ),
    );
  }

  validateForm(BuildContext context) {
    final StepsProvider stepsProvider =
        Provider.of<StepsProvider>(context, listen: false);
    final validation = stepsProvider.getAllValidations();
    if (validation) {
      getToken(context);
    }
  }

  void getToken(BuildContext context) async {

    CulqiCard _card = CulqiCard();

    final StepsProvider stepsProvider =
        Provider.of<StepsProvider>(context, listen: false);
    _card.email = stepsProvider.emailEntered.value;
    final email  =_card.email;
    bool success = _widgetKey.currentState.setInfoOn(_card);

    if (success) {

//      print("card ${_card.cardNumber}");
//      print("suc: $success");

      CulqiTokenizer _tokenizer = CulqiTokenizer(_card);

      final response = await _tokenizer.getToken(publicKey: publicCulquiKey);

//      print(response);

      if (response is CulqiToken) {

//        print("token: ${response.token}");
        final token = response.token;
        print("CALL API");
        final payResponse = await stepsProvider.generatePayment(token, email);

        print(payResponse);

        if(!payResponse["ok"]) {
          Toast.show(payResponse["message"], context, duration: 3, gravity: Toast.BOTTOM);
        }else {
          Toast.show(payResponse["message"], context, duration: 2, gravity: Toast.BOTTOM);
        }

      } else if (response is CulqiError) {
        Toast.show(response.errorMessage, context,
            duration: 3, gravity: Toast.BOTTOM);
      }
    }
  }
}

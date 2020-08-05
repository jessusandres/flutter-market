import 'package:flutter/material.dart';
import 'package:flutter_culqi/flutter_culqi.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/themes/app_theme.dart';

class CardPaymentPage extends StatefulWidget {
  @override
  _CardPaymentPageState createState() => _CardPaymentPageState();
}

class _CardPaymentPageState extends State<CardPaymentPage> {
  GlobalKey<CulqiPaymentState> _widgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body:  Container(
        color: AppTheme.white,
        child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 115),
                child: Text('DATOS DE TARJETA', style: AppTheme.caption.copyWith(fontSize: 20),),
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
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    errorText: null,
                    labelText: 'Correo Electrónico',
                    helperText: 'Su dirección de correo',
                  ),
                  onChanged: (String value){},
                ),
              ),
              SizedBox(height: 15,),
              CulqiPayment(_widgetKey),
              RaisedButton(
                // This function will get the token
                // with the fields from CulqiPayment
                  onPressed: getToken,
                  child: Text('Get Token')
              )
            ]
        ),
      ),
    );
  }

  void getToken() async{
    CulqiCard _card = CulqiCard();

    bool success = _widgetKey.currentState.setInfoOn(_card);

    //TODO: email para culqui
    _card.email = 'test@testemail.com';

    CulqiTokenizer _tokenizer = CulqiTokenizer(_card);

    var r = await _tokenizer.getToken(publicKey: publicCulquiKey);

    if(r is CulqiToken){
      print(r.token);
    }else if(r is CulqiError){
      print(r);
    }
  }

}

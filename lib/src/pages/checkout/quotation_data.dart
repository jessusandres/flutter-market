import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/models/store_address_model.dart';
import 'package:gustolact/src/options/payment_options.dart';
import 'package:gustolact/src/providers/steps_provider.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:gustolact/src/widgets/divier_checkout_widget.dart';
import 'package:gustolact/src/widgets/title_checkout.dart';
import 'package:gustolact/src/widgets/voucherButtonPayment_widget.dart';
import 'package:provider/provider.dart';

class QuotationDataStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final StepsProvider _stepsProvider = Provider.of<StepsProvider>(context);

    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 25,
                  ),
                  TitleCheckout(
                    title: 'Datos de Pago:',
                  ),
                  DividerCheckout(),
                  _PaymentOptions(size: size, stepsProvider: _stepsProvider),
                  (_stepsProvider.paymentOptionSelected ==
                          PaymentOptions.efective)
                      ? AnimatedContainer(
                          duration: Duration(milliseconds: 150),
                          curve: Curves.easeIn,
                          margin: EdgeInsets.only(bottom: 10),
                          child: TextField(
                            maxLines: 1,
                            autofocus: false,
                            controller: _stepsProvider.effectiveController,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              errorText: _stepsProvider.effectiveEntered.error,
                              icon: Icon(Icons.attach_money),
                              labelText: 'Monto de Efectivo',
                              helperText: 'Monto de Efectivo para pagar',
                            ),
                          ),
                        )
                      : AnimatedContainer(
                          duration: Duration(milliseconds: 150),
                          curve: Curves.easeIn,
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  TitleCheckout(
                    title: 'Datos de despacho',
                  ),
                  DividerCheckout(),
                  SizedBox(
                    height: 25,
                  ),
                  _StoreAddresses(stepsProvider: _stepsProvider),
                  SizedBox(
                    height: 25,
                  ),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    value: _stepsProvider.voucher,
                    title: Text('Solicitar comprobante'),
                    onChanged: (bool value) {
                      _stepsProvider.voucher = value;
                    },
                  ),
                  Container(
                    width: double.infinity,
                    child: (_stepsProvider.voucher == false &&
                            _stepsProvider.paymentOptionSelected !=
                                PaymentOptions.card)
                        ? VoucherButtonPayment(
                            enable: _stepsProvider.getQuotationValidations(anotherPage: true))
                        : Container(),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ])));
  }
}

class _StoreAddresses extends StatelessWidget {
  const _StoreAddresses({
    Key key,
    @required StepsProvider stepsProvider,
  })  : _stepsProvider = stepsProvider,
        super(key: key);

  final StepsProvider _stepsProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.map,
          color: _stepsProvider.storeAddressSelected == '00'
              ? Colors.redAccent
              : Colors.grey,
        ),
        SizedBox(
          width: 14,
        ),
        Expanded(
          child: StreamBuilder(
            stream: _stepsProvider.storeAddressStrem,
            builder: (BuildContext context,
                AsyncSnapshot<List<StoreAddress>> asyncSnapshot) {
              if (!asyncSnapshot.hasData) {
                return DropdownButton(
                    isExpanded: true,
                    value: 0,
                    items: [
                      DropdownMenuItem(
                        child: Text('Direcciones de $storeName'),
                        value: 0,
                      ),
                    ],
                    onChanged: (int value) {});
              } else {
                final addresses = asyncSnapshot.data;

                final addressesList = [
                  DropdownMenuItem(
                    child: Text('Seleccione una dirección de $storeName'),
                    value: "00",
                  )
                ];
                addresses.forEach((element) {
                  print(element.code);
                  addressesList.add(DropdownMenuItem(
                    child: Text(
                        "${element.wname} ${element.provincia} ${element.departamento}"),
                    value: element.code,
                  ));
                });

                return Container(
                  child: DropdownButton(
                      isDense: false,
                      style: TextStyle(
                        color: AppTheme.nearlyBlack,
                      ),
                      isExpanded: true,
                      value: _stepsProvider.storeAddressSelected,
                      items: addressesList,
                      onChanged: (String value) {
                        _stepsProvider.storeAddressSelected = value;
                      }),
                );
              }
            },
          ),
        )
      ],
    );
  }
}

class _PaymentOptions extends StatelessWidget {
  const _PaymentOptions({
    Key key,
    @required this.size,
    @required StepsProvider stepsProvider,
  })  : _stepsProvider = stepsProvider,
        super(key: key);

  final Size size;
  final StepsProvider _stepsProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size.width * 0.40,
          child: RadioListTile(
              title: Text('Efectivo'),
              groupValue: _stepsProvider.paymentOptionSelected,
              value: PaymentOptions.efective,
              onChanged: (PaymentOptions value) {
                _stepsProvider.paymentOptionSelected = value;
              }),
        ),
        Container(
          width: size.width * 0.40,
          child: RadioListTile(
              title: Text('Tarjeta'),
              groupValue: _stepsProvider.paymentOptionSelected,
              value: PaymentOptions.card,
              onChanged: (PaymentOptions value) {
                _stepsProvider.paymentOptionSelected = value;
              }),
        ),
      ],
    );
  }
}

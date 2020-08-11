import 'package:flutter/material.dart';
import 'package:gustolact/src/options/payment_options.dart';
import 'package:gustolact/src/options/voucher_types.dart';
import 'package:gustolact/src/providers/steps_provider.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:gustolact/src/widgets/title_checkout.dart';
import 'package:gustolact/src/widgets/voucherButtonPayment_widget.dart';
import 'package:provider/provider.dart';

class VoucherData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final StepsProvider stepsProvider = Provider.of<StepsProvider>(context);
    int voucherType = stepsProvider.voucherTypeSelected.index;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 18),
            TitleCheckout(title: 'Datos del Comprante'),
            _VoucherDropDown(stepsProvider: stepsProvider),
            Container(
              child: TextField(
                controller: stepsProvider.voucherNameController,
                autofocus: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    errorText: stepsProvider.voucherNameEntered.error,
                    icon: Icon(Icons.person_outline),
                    labelText: voucherType == 0 ? 'Nombres' : 'Razón Comercial',
                    helperText:
                        'Nombre de registro en la ${(voucherType == 0) ? 'Boleta' : 'Factura'}'),
              ),
            ),
            Container(
              child: TextField(
                controller: stepsProvider.voucherDocController,
                autofocus: false,
                maxLength: voucherType == 0 ? 8 : 11,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    errorText: stepsProvider.voucherDocEntered.error,
                    icon: Icon(Icons.person_outline),
                    labelText: voucherType == 0 ? 'DNI' : 'RUC',
                    helperText:
                        'Documento de registro en la ${(voucherType == 0) ? 'Boleta' : 'Factura'}'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
                child: (stepsProvider.paymentOptionSelected ==
                        PaymentOptions.efective)
                    ? VoucherButtonPayment(enable: stepsProvider.getVoucherValidations(anotherPage: true))
                    : Container())
          ],
        ),
      ),
    );
  }
}



class _VoucherDropDown extends StatelessWidget {
  const _VoucherDropDown({
    Key key,
    @required this.stepsProvider,
  }) : super(key: key);

  final StepsProvider stepsProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.featured_play_list,
          color: Colors.grey,
        ),
        SizedBox(
          width: 14,
        ),
        Expanded(
          child: DropdownButton(
            isExpanded: true,
            items: <DropdownMenuItem>[
              DropdownMenuItem(
                child: Text('Boleta'),
                value: VoucherTypes.boleta,
              ),
              DropdownMenuItem(
                  child: Text('Factura'), value: VoucherTypes.factura),
            ],
            value: stepsProvider.voucherTypeSelected,
            onChanged: (value) {
              stepsProvider.voucherTypeSelected = value;
            },
          ),
        ),
      ],
    );
  }
}

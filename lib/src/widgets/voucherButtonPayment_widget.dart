import 'package:flutter/material.dart';
import 'package:gustolact/src/providers/steps_provider.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:provider/provider.dart';

class VoucherButtonPayment extends StatelessWidget {

  final bool enable;
  const VoucherButtonPayment({@required this.enable});

  @override
  Widget build(BuildContext context) {
    final StepsProvider stepsProvider = Provider.of<StepsProvider>(context);

    return Container(
        child: RaisedButton(
          color: AppTheme.primaryColor,
          onPressed: (enable) ? (){generateQuotation(stepsProvider);} :  null,
          elevation: 0.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: Text(
            'Procesar Compra',
            style: TextStyle(color: AppTheme.white),
          ),
        ));
  }

  void generateQuotation (StepsProvider stepsProvider) {
//    print('generate payment e.e');
    stepsProvider.generateQuotation();
  }
}

import 'package:flutter/material.dart';
import 'package:gustolact/src/themes/app_theme.dart';

class TitleCheckout extends StatelessWidget {

  final String title;

  const TitleCheckout({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Center(
        child: Text(
          title,
          style: AppTheme.caption.copyWith(fontSize: 20),
        ),
      ),
    );
  }
}

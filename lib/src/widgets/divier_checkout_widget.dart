import 'package:flutter/material.dart';
import 'package:gustolact/src/themes/app_theme.dart';

class DividerCheckout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppTheme.primaryColor,
      thickness: 1.3,
    );
  }
}

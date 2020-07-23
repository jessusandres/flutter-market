import 'package:flutter/material.dart';
import 'package:gustolact/src/providers/login_provider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final LoginProvider _loginProvider = Provider.of<LoginProvider>(context);
    _loginProvider.verifyLogin();

    return Scaffold(
      body: Container(
        child: Center(
          child: Text('PAGE : CartPage'),
        ),
      ),
    );
  }
}

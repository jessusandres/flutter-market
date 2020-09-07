import 'package:flutter/material.dart';
import 'package:gustolact/src/widgets/appbar_widget.dart';
import 'package:gustolact/src/widgets/drawer_widget.dart';

class OrdersPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: DrawerMarket(),
      appBar: AppBarMarket(),
      body: Center(
        child: Text('PEDIDOS'),
      ),
    );
  }
}

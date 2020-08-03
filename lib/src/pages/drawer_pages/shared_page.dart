import 'package:flutter/material.dart';
import 'package:gustolact/src/widgets/appbar_widget.dart';
import 'package:gustolact/src/widgets/drawer_widget.dart';

class SharedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMarket(),
      drawer: DrawerMarket(),
      body: Center(
        child: Text('Shared Page'),
      ),
    );
  }
}

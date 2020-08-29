import 'package:flutter/material.dart';
import 'package:gustolact/src/models/userdata_model.dart';
import 'package:gustolact/src/shared_preferences/user_preferences.dart';
import 'package:gustolact/src/widgets/appbar_widget.dart';
import 'package:gustolact/src/widgets/drawer_widget.dart';

class OrdersPage extends StatelessWidget {

  UserPreferences userPreferences = new UserPreferences();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: DrawerMarket(),
      appBar: AppBarMarket(),
      body: Center(
        child: Text('CotizationsPage: ${userPreferences.bgMessage}'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gustolact/src/shared_preferences/user_preferences.dart';
import 'package:gustolact/src/widgets/appbar_widget.dart';
import 'package:gustolact/src/widgets/drawer_widget.dart';

class SharedPage extends StatelessWidget {
  UserPreferences userPreferences = new UserPreferences();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMarket(),
      drawer: DrawerMarket(),
      body: Center(
        child: Text('Shared Page: ${userPreferences.fcmtToken}'),
      ),
    );
  }
}

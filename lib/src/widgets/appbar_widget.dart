import 'package:flutter/material.dart';
import 'package:gustolact/src/config/config.dart';

class AppBarMarket extends PreferredSize{

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.deepOrangeAccent,
      title: Text(storeName),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(
    double.infinity,
    65
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/pages/main_page.dart';
import 'package:gustolact/src/providers/home_provider.dart';
import 'package:gustolact/src/providers/main_provider.dart';
import 'package:gustolact/src/providers/product_provider.dart';
import 'package:gustolact/src/themes/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider( create: (_)=> new MainProvider(), ),
        ChangeNotifierProvider( create: (_)=> new HomeProvider(), ),
        ChangeNotifierProvider( create: (_)=> new ProductProvider(), ),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme.copyWith(
          textTheme: GoogleFonts.muliTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        debugShowCheckedModeBanner: false,
        title: '$storeName APP',
        home: MainPage(),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/config/key.dart';
import 'package:gustolact/src/providers/cart_provider.dart';
import 'package:gustolact/src/providers/home_provider.dart';
import 'package:gustolact/src/providers/login_provider.dart';
import 'package:gustolact/src/providers/main_provider.dart';
import 'package:gustolact/src/providers/product_provider.dart';
import 'package:gustolact/src/providers/search_provider.dart';
import 'package:gustolact/src/routes/main_routes.dart';
import 'package:gustolact/src/shared_preferences/user_preferences.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:provider/provider.dart';

// void setupLocator() {
//   locator.registerLazySingleton(() => NavigationService());
// }

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  final preferences = new UserPreferences();
  await preferences.initPrefences();

  locator.registerLazySingleton(() => NavigationService());
  runApp(MyApp());

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
//        statusBarColor: Color.fromRGBO(52, 54, 101, 0.0),
//        statusBarIconBrightness: Brightness.dark
//    ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MainProvider>(create: (_) => new MainProvider(),),
        ChangeNotifierProvider<HomeProvider>(create: (_) => new HomeProvider(),),
        ChangeNotifierProvider<ProductProvider>(create: (_) => new ProductProvider(),),
        ChangeNotifierProvider<SearchProvider>(create: (_) => new SearchProvider()),
        ChangeNotifierProvider<LoginProvider>(create: (_) => new LoginProvider()),
        ChangeNotifierProvider<CartProvider>(create: (_) => new CartProvider()),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme.copyWith(
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        navigatorKey: locator<NavigationService>().navigatorKey,
        debugShowCheckedModeBanner: false,
        title: '$storeName APP',
        routes: mainRoutes,
        initialRoute: '/',
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gustolact/src/config/config.dart';
import 'package:gustolact/src/config/key.dart';
import 'package:gustolact/src/providers/cart_provider.dart';
import 'package:gustolact/src/providers/home_provider.dart';
import 'package:gustolact/src/providers/login_provider.dart';
import 'package:gustolact/src/providers/main_provider.dart';
import 'package:gustolact/src/providers/product_provider.dart';
import 'package:gustolact/src/providers/push_provider.dart';
import 'package:gustolact/src/providers/search_provider.dart';
import 'package:gustolact/src/routes/main_routes.dart';
import 'package:gustolact/src/shared_preferences/user_preferences.dart';
import 'package:gustolact/src/themes/app_theme.dart';
import 'package:gustolact/src/themes/light_color.dart';
import 'package:provider/provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final preferences = new UserPreferences();
  await preferences.initPrefences();

  locator.registerLazySingleton(() => NavigationService());
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<MainProvider>(
        create: (_) => new MainProvider(),
      ),
      ChangeNotifierProvider<HomeProvider>(
        create: (_) => new HomeProvider(),
      ),
      ChangeNotifierProvider<ProductProvider>(
        create: (_) => new ProductProvider(),
      ),
      ChangeNotifierProvider<SearchProvider>(
          create: (_) => new SearchProvider()),
      ChangeNotifierProvider<LoginProvider>(create: (_) => new LoginProvider()),
      ChangeNotifierProvider<CartProvider>(create: (_) => new CartProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PushNotificationProvider pushNotificationProvider;

  @override
  void initState() {
    super.initState();

    final BuildContext currentContext =
        locator<NavigationService>().navigatorKey.currentContext;

    pushNotificationProvider = new PushNotificationProvider();

    pushNotificationProvider.initNotifications();

    pushNotificationProvider.bgStream.listen((event) {
      final _mainProvider =
          Provider.of<MainProvider>(currentContext, listen: false);
      _mainProvider.drawerPage = 2;
      Navigator.pushReplacementNamed(currentContext, 'orders');
    });

    pushNotificationProvider.messagesStream.listen((event) {
      final LoginProvider loginProvider =
          Provider.of<LoginProvider>(context, listen: false);
      print(event);
      if (loginProvider.isLogged) {

        final BuildContext appContext =
            locator<NavigationService>().navigatorKey.currentContext;

        showDialog(
            barrierDismissible: false,
            context: appContext,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
                title: Text(event['data']['title']),
                content: Text(event['data']['message']),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK',
                        style: TextStyle(color: AppTheme.primaryColor)),
                  )
                ],
              );
            });
      }
    });
  }

  @override
  void dispose() {
    pushNotificationProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    loginProvider.verifyLogin();
    return MaterialApp(
      theme: Theme.of(context).copyWith(
          textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
          backgroundColor: LightColor.background,
          indicatorColor: AppTheme.primaryColor,
          primaryColor: AppTheme.primaryColor,
          accentColor: AppTheme.lightTheme.accentColor),
      navigatorKey: locator<NavigationService>().navigatorKey,
      debugShowCheckedModeBanner: false,
      title: '$storeName APP',
      routes: mainRoutes,
      initialRoute: '/',
    );
  }
}

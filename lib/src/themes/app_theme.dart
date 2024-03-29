import 'package:flutter/material.dart';
import 'package:gustolact/src/themes/light_color.dart';

class AppTheme {
  AppTheme._();
  static ThemeData lightTheme = ThemeData(
      backgroundColor: LightColor.background,
//      primaryColor: LightColor.background,
      primaryColor: Color.fromRGBO(242, 143, 43, 1.0),
      cardTheme: CardTheme(color: LightColor.background),
      textTheme: TextTheme(headline4: TextStyle(color: LightColor.black)),
      iconTheme: IconThemeData(color: LightColor.iconColor),
      indicatorColor: Color.fromRGBO(242, 143, 43, 1.0),
      accentColor: Color.fromRGBO(242, 143, 43, 1.0),
      bottomAppBarColor: LightColor.background,
      dividerColor: LightColor.lightGrey,
      primaryTextTheme: TextTheme(
          bodyText2: TextStyle(color:LightColor.titleTextColor)
      )
  );
  static EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  static const Color bgDrawer = Colors.white;
  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Colors.grey;
  static const Color dark_grey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);
  static const String fontName = 'WorkSans';
  static const Color primaryColor = Color.fromRGBO(242, 143, 43, 1.0);
  static const Color dangerColor = Colors.redAccent;

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle( // h4 -> display1
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle( // h5 -> headline
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle( // h6 -> title
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle( // subtitle2 -> subtitle
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 20,
    letterSpacing: -0.04,
    color: Colors.white,
  );

  static const TextStyle body2 = TextStyle( // body1 -> body2
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle( // body2 -> body1
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle( // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );

}

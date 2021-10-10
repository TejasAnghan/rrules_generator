import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Themes {
  Themes._();

  static const fontFamily = 'Poppins';
  static const Color fbColor = Color(0xff3F51B5);
  static const Color darkColor = Color(0xff000000);
  static const Color lightColor = Color(0xffffffff);
  static const Color greenColor = Color(0xff006837);
  static const Color textColor33 = Color(0xff333333);
  static const Color textColor66 = Color(0xff666666);
  static const Color primaryColor = Color(0xffEE7505);
  static const Color textFieldBorderColor = Color(0xffE2E2E8);
  static const Color errorColor = CupertinoColors.destructiveRed;

  static const double topPadding = 10;
  static const double bottomPadding = 120;
  static const double horizontalPadding = 20;
  static const double buttonPressedOpacity = 0.6;
  //!It's a height of text button or icon button without having border and background color (heightofTextButton)
  static const double heightofTextorIconButton = 20;
  static const ScrollPhysics defaultPhysics = BouncingScrollPhysics();
  static const TextOverflow defaultTextOverflow = TextOverflow.ellipsis;
  static const Border appBarBorder =
      Border.symmetric(horizontal: BorderSide.none);

  static const TextStyle placeholderStyle = TextStyle(
    fontSize: 12,
    color: textColor66,
    fontWeight: FontWeight.w400,
    fontFamily: Themes.fontFamily,
  );

  static final lightTheme = ThemeData(
    fontFamily: fontFamily,
    errorColor: errorColor,
    primaryColor: primaryColor,
    primarySwatch: Colors.orange,
    splashColor: Colors.transparent,
    bottomAppBarColor: primaryColor,
    highlightColor: Colors.transparent,
    scaffoldBackgroundColor: lightColor,
    cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightColor,
      barBackgroundColor: lightColor.withOpacity(0.9),
      textTheme: const CupertinoTextThemeData(
        primaryColor: darkColor,
      ),
    ),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: primaryColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      splashColor: Colors.orange,
      backgroundColor: primaryColor,
    ),
    colorScheme: const ColorScheme.light(primary: primaryColor, error: errorColor),
    textTheme: const  TextTheme(
      headline1: TextStyle(
        fontSize: 24,
        color: primaryColor,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
      ),
      headline2: TextStyle(
        fontSize: 18,
        color: darkColor,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
      ),
      headline3: TextStyle(
        fontSize: 16,
        color: primaryColor,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
      ),
      headline4: TextStyle(
        fontSize: 14,
        color: textColor33,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
      ),
      headline5: TextStyle(
        fontSize: 12,
        color: darkColor,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
      ),
      headline6: TextStyle(
        fontSize: 10,
        color: darkColor,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
      ),
      subtitle1: TextStyle(
        fontSize: 8,
        color: lightColor,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData darkTheme(BuildContext context) => ThemeData(
      primarySwatch: Colors.teal,
      canvasColor: Color(0xff3B2954FF),
      textTheme: Theme.of(context).textTheme,
      cardColor: tealColor,
      backgroundColor: Color(0xFFEAEAEA),
      iconTheme: IconThemeData(
          color: Colors.white
      ),
      appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),

          ));

  static ThemeData lightTheme(BuildContext context) => ThemeData(
      primarySwatch: Colors.teal,
      cardColor: Color(0xFFF6F5F5),
      canvasColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.black
      ),
      backgroundColor: Color(0xFF5E5E5E),
      textTheme: Theme.of(context).textTheme,
      appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          ));
    static Color tealColor = Color(0xFF463E5E);

}

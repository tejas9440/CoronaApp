import 'package:corona_tracker/Screens/countriesScreen.dart';
import 'package:corona_tracker/Screens/homeScreen.dart';
import 'package:corona_tracker/Screens/splashScreen.dart';
import 'package:corona_tracker/Services/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: MyTheme.lightTheme(context),
      darkTheme: MyTheme.darkTheme(context),
      home: HomeScreen(),
    );
  }
}



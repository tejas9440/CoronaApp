import 'dart:async';

import 'package:corona_tracker/Screens/homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: Duration(seconds: 3), vsync: this)
        ..repeat();

  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.001,
          // ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: AnimatedBuilder(
                  animation: _controller,
                  child: Container(
                    height: 300,
                    width: 300,
                    child: Center(
                      child: Image(
                        image: AssetImage(
                            'assets/images/splash_screen_logo_2.png'),
                      ),
                    ),
                  ),
                  builder: (BuildContext context, Widget? child) {
                    return Transform.rotate(
                      angle: _controller.value * 2.0 * math.pi,
                      child: child,
                    );
                  }),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Center(
              child: Text(
                "Covid-!9 \n Tracker App",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).backgroundColor,
                    fontSize: 34,
                    fontWeight: FontWeight.w400),
              ))
        ],
      ),
    );
  }
}

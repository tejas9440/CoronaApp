import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityUtil {
  VoidCallback showDialogCallback;

  ConnectivityUtil(this.showDialogCallback) {
    getConnectivity();
  }

  late StreamSubscription subscription;
  late bool isDeviceConnected;
  bool isAlertSet = false;

  void getConnectivity() async{
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected && !isAlertSet) {
        showDialogCallback(); // Call the callback to show the dialog
        isAlertSet = true;
      }else if (isDeviceConnected && isAlertSet) {
        isAlertSet = false;
      }
    });
  }

  void dispose() {
    subscription.cancel();
  }
}

class YourWidget extends StatefulWidget {
  Object? screenName;
  YourWidget({this.screenName});
  void showDialogBox() {
    _YourWidgetState? state = _YourWidgetState();
    state?.showDialogBox();
  }
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  late ConnectivityUtil connectivityUtil;

  var isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    super.initState();
    connectivityUtil = ConnectivityUtil(showDialogBox);

  }

  @override
  void dispose() {
    connectivityUtil.dispose();
    super.dispose();
  }

  void showDialogBox() {
    if(!isDeviceConnected){
      showDialog(
        context:context,
        builder: (BuildContext context){
          return Dialog(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.wifi_off_outlined,
                    size: 40,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    'No Connection',
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Please check your internet connectivity",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w300, color: Colors.white),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  ElevatedButton(
                      onPressed: () async{
                        await Temp();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Retry",
                            style: TextStyle(color: Colors.white, fontSize: 19),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            CupertinoIcons.refresh_thin,
                            size: 20,
                            color: Colors.white,
                          ),
                        ],
                      ))
                ],
              ),
            ),
          );
        }
      );
      setState(() {
        isAlertSet = true;
      });
    }

  }
  Temp() async {
    Navigator.of(context).pop();
    setState(() {
      isAlertSet = false;
    });

    isDeviceConnected = await InternetConnectionChecker().hasConnection;

    if (!isDeviceConnected) {
      showDialogBox();
      setState(() {
        isAlertSet = true;
      });
    } else {
      setState(() {
        isDeviceConnected = true;
      });
      Navigator.of(context).pop();

    }
  }

  @override
  Widget build(BuildContext context) {
    return Text('');
  }
}

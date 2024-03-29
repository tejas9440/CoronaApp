import 'dart:async';
import 'package:corona_tracker/Screens/splashScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:corona_tracker/Screens/countriesScreen.dart';
import 'package:corona_tracker/Services/states_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:animate_do/animate_do.dart';
import 'package:pie_chart/pie_chart.dart';
import '../Model/WorldStatesModel.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../Services/connectivityutil.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
  StreamSubscription<ConnectivityResult>? subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  late ConnectivityUtil connectivityUtil;


  @override
  void initState() {
    connectivityUtil = ConnectivityUtil(showDialogBox);
    super.initState();
  }

  Future<Widget> checkConnectivity() async {
    isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected) {
      // showDialogBox();
      return YourWidget();
    }
    return Container();
  }

  @override
  void dispose() {
    connectivityUtil.dispose();
    _controller.dispose();
    super.dispose();
  }

  void showDialogBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Theme.of(context).cardColor,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
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
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).backgroundColor),
                ),
                SizedBox(
                  height: 3,
                ),
                ElevatedButton(
                    onPressed: () {
                      Temp();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).cardColor,
                      shadowColor: Colors.teal,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Retry",
                          style: TextStyle(
                              color: Theme.of(context).backgroundColor,
                              fontSize: 19),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          CupertinoIcons.refresh_thin,
                          size: 20,
                          color: Theme.of(context).backgroundColor,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        );
      },
    );
  }

  Temp() async {
    Navigator.pop(context, 'Cancel');
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
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ));
    }
  }

  final colorList = <Color>[
    Color(0xff79fc7b),
    Color(0xff3088d0),
    Color(0xffef1414)
  ];

  @override
  Widget build(BuildContext context) {
    StateServices stateServices = StateServices();
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Theme.of(context).cardColor,
                title: Text(
                  'Are You Sure??',
                  style: TextStyle(color: Theme.of(context).backgroundColor),
                ),
                content: Text(
                  "Do You want to Exit",
                  style: TextStyle(color: Theme.of(context).backgroundColor),
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        "No",
                        style: TextStyle(color: Colors.black),
                      )),
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(),
                      child: Text(
                        "Yes",
                        style: TextStyle(color: Colors.grey.shade600),
                      )),
                ],
              );
            });
        if (value != null) {
          return Future.value(value);
        } else {
          return Future.value(false);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(19.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder(
                        future: stateServices.fetchWordStatesRecords(),
                        builder: (context,
                            AsyncSnapshot<WorldStatesModel> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SplashScreen();
                          } else if (snapshot.hasError) {
                            return YourWidget(
                              screenName: HomeScreen,
                            );
                          } else {
                            return Column(
                              children: [
                                PieChart(
                                  dataMap: {
                                    "Total": double.parse(
                                        snapshot.data!.cases.toString()),
                                    "Recover": double.parse(
                                        snapshot.data!.recovered.toString()),
                                    "Death": double.parse(
                                        snapshot.data!.deaths.toString())
                                  },
                                  legendOptions: LegendOptions(
                                    showLegends: true,
                                    legendPosition: LegendPosition.right,
                                    legendTextStyle: TextStyle(
                                      color: Theme.of(context)
                                          .backgroundColor,
                                    ),
                                  ),
                                  centerTextStyle:
                                      TextStyle(color: Colors.teal),
                                  chartValuesOptions: const ChartValuesOptions(
                                      showChartValuesInPercentage: true),
                                  chartRadius:
                                      MediaQuery.of(context).size.width / 3.0,
                                  animationDuration:
                                      Duration(milliseconds: 1400),
                                  chartType: ChartType.ring,
                                  colorList: colorList,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 28.0),
                                  child: Column(
                                    children: [
                                      ReusableRow(
                                          title: "Total",
                                          value:
                                              snapshot.data!.cases.toString()),
                                      ReusableRow(
                                          title: "Recovered",
                                          value: snapshot.data!.recovered
                                              .toString()),
                                      ReusableRow(
                                          title: "Death",
                                          value:
                                              snapshot.data!.deaths.toString()),
                                      ReusableRow(
                                          title: "Active",
                                          value:
                                              snapshot.data!.active.toString()),
                                      ReusableRow(
                                          title: "Critical",
                                          value: snapshot.data!.critical
                                              .toString()),
                                      ReusableRow(
                                          title: "Today Recovered",
                                          value: snapshot.data!.todayRecovered
                                              .toString()),
                                      ReusableRow(
                                          title: "Today Cases",
                                          value: snapshot.data!.todayCases
                                              .toString()),
                                      FadeInUp(
                                        duration: Duration(seconds: 1),
                                        animate: true,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 13.0),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor:
                                              Color(0xff1aa260),
                                              shadowColor: Colors.teal,
                                              textStyle: TextStyle(
                                                  fontFamily: 'roboto'),
                                              minimumSize: Size(20, 60),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      15.0)),
                                              alignment: Alignment.center,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .push(_createRoute());
                                            },
                                            child: Center(
                                                child: Text(
                                                  'Track Countries',
                                                  style: TextStyle(fontSize: 20),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  late String title, value;

  ReusableRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: Duration(seconds: 1),
      animate: true,
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 10, right: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Theme.of(context).backgroundColor,
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(value,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).backgroundColor,
                        fontWeight: FontWeight.normal,
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const CountriesScreen(),
    transitionDuration: Duration(milliseconds: 1000),
    reverseTransitionDuration: Duration(milliseconds: 1000),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

import 'dart:async';
import 'dart:convert';
import 'package:corona_tracker/Model/countryData.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:corona_tracker/Screens/detailScreen.dart';
import 'package:corona_tracker/Services/states_services.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Services/connectivityutil.dart';
import 'package:http/http.dart' as http;

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({super.key});

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  TextEditingController searchController = TextEditingController();
  late StreamSubscription<ConnectivityResult>? subscription;
  StateServices stateServices = StateServices();
  var isDeviceConnected = false;
  bool isAlertSet = false;
  late ConnectivityUtil connectivityUtil;
  static List<dynamic> allCountriesData = [];
  List<dynamic> searchData = [];
  late List<dynamic> future_country = [];

  @override
  void initState() {
    connectivityUtil = ConnectivityUtil(showDialogBox);
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    List<dynamic> countries = await stateServices.coutriesList();
    setState(() {
      future_country = countries;
    });
  }

  Future<List<CountryData>> fetch_country() async {
    final response =
        await http.get(Uri.parse('https://disease.sh/v3/covid-19/countries'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => CountryData.fromJson(data)).toList();
    } else {
      throw Exception('fetch api error');
    }
  }

  @override
  void dispose() {
    connectivityUtil.dispose();
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
      // Navigator.pop(context, 'Cancel');
      Navigator.of(context).pop();
    }
  }

  void onSearchChange(String value) async {
    List<dynamic> countries = await stateServices.coutriesList();
    List<dynamic> result = [];

    if (value.isEmpty) {
      result = countries;
    } else {
      result = countries
          .where((user) => user['country']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    }

    setState(() {
      future_country = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'Countries',
          style: TextStyle(color: Theme.of(context).backgroundColor),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: searchController,
                cursorColor: Theme.of(context).backgroundColor,
                style: TextStyle(color: Theme.of(context).backgroundColor),
                onChanged: (value) {
                  onSearchChange(value);
                },
                decoration: InputDecoration(
                  fillColor: Theme.of(context).backgroundColor,
                  border: OutlineInputBorder(

                    borderSide: BorderSide(
                      color: Colors.red
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.teal,
                      ),
                      borderRadius: BorderRadius.circular(13)),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 25,
                    color: Theme.of(context).backgroundColor,
                  ),
                  hintStyle:
                      TextStyle(color: Theme.of(context).backgroundColor),
                  hintText: "Search countries..",
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        width: 1, color: Theme.of(context).backgroundColor),
                  ),
                ),
              ),
            ),
            Expanded(
                child: FutureBuilder(
                    future: stateServices.coutriesList(),
                    builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                      return future_country.isNotEmpty
                          ? ListView.builder(
                              itemCount: future_country.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  color: Theme.of(context).cardColor,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(_createRoute(
                                          future_country, index));
                                    },
                                    title: Text(
                                      future_country[index]['country'],
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .backgroundColor),
                                    ),
                                    subtitle: Text(
                                      'Cases: ${future_country[index]['cases'].toString()}',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .backgroundColor),
                                    ),
                                    leading: Image.network(
                                      future_country[index]['countryInfo']
                                          ['flag'],
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                );
                              },
                            )
                          : (snapshot.connectionState ==
                                      ConnectionState.waiting &&
                                  searchController.text.isEmpty)
                              ? ListView.builder(
                                  itemCount: 10,
                                  itemBuilder: (context, index) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey.shade600,
                                      highlightColor: Colors.grey.shade100,
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: Container(
                                              height: 10,
                                              width: 89,
                                              color: Colors.white24,
                                            ),
                                            subtitle: Container(
                                              height: 10,
                                              width: 89,
                                              color: Colors.white30,
                                            ),
                                            leading: Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  color: Colors.white30,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          13)),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  })
                              : (snapshot.hasError)
                                  ? YourWidget()
                                  : (searchController.text.isNotEmpty)
                                      ? Center(
                                          child: Container(
                                            child: Text(
                                              "No Country Found",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 25,
                                                  fontWeight:
                                                      FontWeight.w400),
                                            ),
                                          ),
                                        )
                                      : Container();
                    }))
          ],
        ),
      ),
    );
  }
}

Route _createRoute(List<dynamic> countryList, int index) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => DetailScreen(
      id: countryList[index]['countryInfo']['_id'],
      image: countryList[index]['countryInfo']['flag'],
      name: countryList[index]['country'],
      totalCases: countryList[index]['cases'],
      totalRecovered: countryList[index]['recovered'],
      active: countryList[index]['active'],
      test: countryList[index]['tests'],
      todayRecovered: countryList[index]['todayRecovered'],
      criticle: countryList[index]['critical'],
      totalDeath: countryList[index]['deaths'],
    ),
    transitionDuration: Duration(milliseconds: 870),
    reverseTransitionDuration: Duration(milliseconds: 970),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
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

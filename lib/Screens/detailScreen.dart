import 'package:corona_tracker/Screens/homeScreen.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  String name, image;
  int? id;
  int totalCases,
      totalRecovered,
      active,
      criticle,
      todayRecovered,
      test,
      totalDeath;

  DetailScreen({
    super.key,
    required this.id,
    required this.image,
    required this.name,
    required this.totalCases,
    required this.totalRecovered,
    required this.active,
    required this.criticle,
    required this.todayRecovered,
    required this.test,
    required this.totalDeath,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
        appBar: AppBar(
          title: Text(widget.name,style: TextStyle(color: Theme.of(context).backgroundColor
          ),),
          centerTitle: true,
          backgroundColor: Theme.of(context).cardColor,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
              Padding(
                padding:
                      EdgeInsets.only(top: 160,left: 0,right: 0),
                  child: Container(
                    child: Card(
                      color: Theme.of(context).cardColor,
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.13,
                          ),
                          ReusableRow(
                              title: 'Cases', value: widget.totalCases.toString()),
                          ReusableRow(
                              title: 'Today Recovered',
                              value: widget.todayRecovered.toString()),
                          ReusableRow(
                              title: 'Criticle', value: widget.criticle.toString()),
                          ReusableRow(title: 'Tests', value: widget.test.toString()),
                          ReusableRow(title: 'Active', value: widget.active.toString()),
                          ReusableRow(
                              title: 'Death', value: widget.totalDeath.toString()),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 300,
                  child: ClipPath(
                    clipper: CustomClipPath(),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 38.0),
                        child: Image.network(
                          widget.image,
                          width: double.infinity,
                          height: 100,
                          fit: BoxFit.fill,
                        )
                      )),
                ),

              ],
            ),
          ),
        ),
    );

  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;
    final path = Path();

    path.lineTo(0, h * 0.85);
    path.quadraticBezierTo(w * 0.25, h * 0.59, w * 0.5, h * 0.75);
    path.quadraticBezierTo(w * 0.75, h * 0.9, w * 1, h * 0.70);
    path.lineTo(w, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

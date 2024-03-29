import 'package:flutter/material.dart';

import '../custom/custom_widgets/app_bar_widget.dart';
import '../custom/helper_widgets/helper_functions.dart';
import 'model_service_screen.dart';

enum ChartType { Bar, Line, Pie }

class DesktopHomeScreen extends StatefulWidget {
  const DesktopHomeScreen({super.key});

  @override
  _DesktopHomeScreenState createState() => _DesktopHomeScreenState();
}

class _DesktopHomeScreenState extends State<DesktopHomeScreen> {
  List<Map<String, dynamic>> data = [];
  List<List<dynamic>> csvData = [];
  HelperFunctions helperFunctions = HelperFunctions();
  bool isLoaded = false;
  String fileName = '';

  ChartType selectedChartType = ChartType.Bar;

  // Declare GifController

  @override
  void initState() {
    // controller = FlutterGifController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white30,
      appBar: desktopAppBar(context, true),
      body: ListView(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ModelServiceScreen(),
              // VisualizationIntroWidget(),
              // Container(
              //   height: 550,
              //   width: 900,
              //   decoration: BoxDecoration(
              //     color: Colors.indigo.shade50,
              //     borderRadius: BorderRadius.circular(10),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black.withOpacity(0.2),
              //         spreadRadius: 5,
              //         blurRadius: 8,
              //         offset: Offset(2, 2),
              //       ),
              //     ],
              //   ),
              //   child: ,
              // ),
              // SizedBox(
              //     height: 600,
              //     width: 600,
              //     child: Image.network('asset/cubics.gif')),
            ],
          ),
          // Container(
          //   height: 250,
          //   width: MediaQuery.of(context).size.width * 0.5,
          //   padding: EdgeInsets.all(32),
          //   decoration: BoxDecoration(
          //     color: Colors.indigo.shade50,
          //     borderRadius: BorderRadius.circular(10),
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black.withOpacity(0.2),
          //         spreadRadius: 5,
          //         blurRadius: 8,
          //         offset: Offset(2, 2),
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}

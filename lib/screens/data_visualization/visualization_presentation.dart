import 'package:flutter/material.dart';

import '../../custom/custom_widgets/app_bar_widget.dart';
import '../../custom/custom_widgets/display_chart_widget.dart';
import '../../custom/custom_widgets/display_table.dart';
import '../../custom/helper_widgets/helper_functions.dart';

enum ChartType { Bar, Line, Pie }

class PresentationWidget extends StatefulWidget {
  const PresentationWidget({super.key});

  @override
  State<PresentationWidget> createState() => _PresentationWidgetState();
}

class _PresentationWidgetState extends State<PresentationWidget> {
  List<Map<String, dynamic>> data = [];
  List<List<dynamic>> csvData = [];
  HelperFunctions helperFunctions = HelperFunctions();
  bool isLoaded = false;
  String fileName = '';
  bool isDarkMode = true;
  ChartType selectedChartType = ChartType.Bar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: desktopAppBar(context, isDarkMode),
      body: ListView(
        children: <Widget>[
          const SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    HelperFunctions helperFunctions = HelperFunctions();
                    List<List<dynamic>> newData =
                        await helperFunctions.uploadCSVToServerHelper(csvData);
                    setState(() {
                      csvData = newData;
                    });
                  },
                  child: const Text('Upload & Generate Table'),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: 1500,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 8,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Expanded(child: DisplayTable(csvData: csvData)),
                  )),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () async {
                    String resultFileName =
                        await helperFunctions.pickCSVFileHelper(data);
                    setState(() {
                      fileName = resultFileName;
                    });
                  },
                  child: const Text('Upload & Generate Graphs'),
                ),
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: 1500,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 8,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('Selected File: $fileName'),
                        DropdownButton<ChartType>(
                          value: selectedChartType,
                          onChanged: (newValue) {
                            setState(() {
                              selectedChartType = newValue!;
                            });
                          },
                          items: ChartType.values.map((chartType) {
                            return DropdownMenuItem<ChartType>(
                              value: chartType,
                              child: Text(chartType.toString().split('.').last),
                            );
                          }).toList(),
                        ),
                        DisplayChartWidget(
                          data: data,
                          isDarkMode: true,
                        )
                      ],
                    ),
                  )),
                ),
                // ElevatedButton(
                //     onPressed: () {
                //       Navigator.of(context)
                //           .push(MaterialPageRoute(builder: (_) {
                //         return LinearModel();
                //       }));
                //     },
                //     child: const Text('Linear Model')),
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../custom/helper_widgets/helper_functions.dart';
import 'chart_builder_widget.dart';

class DataVisualization extends StatefulWidget {
  @override
  _DataVisualizationState createState() => _DataVisualizationState();
}

class _DataVisualizationState extends State<DataVisualization> {
  HelperFunctions helperFunctions = HelperFunctions();
  List<String> csvFileNames = [];
  List<String> columnNames = [];
  String selectedFileName = '';
  String selectedChartType = 'Line Chart';
  String xAxisColumn = '';
  String yAxisColumn = '';
  String xAxisLabel = '';
  String yAxisLabel = '';
  String graphTitle = '';
  String timePeriod = 'Normal';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCsvFileNames();
  }

  Future<void> fetchCsvFileNames() async {
    await helperFunctions.fetchCsvFileNames();
    setState(() {
      csvFileNames = helperFunctions.csvFileNames;
    });
  }

  Future<void> loadColumns(String fileName) async {
    setState(() {
      isLoading = true;
    });
    columnNames = (await helperFunctions.loadCsvAndExtractColumns(fileName))!;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            //
            height: MediaQuery.of(context).size.height * 0.93,
            width: MediaQuery.of(context).size.width * 0.93,
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0),
                  spreadRadius: 5,
                  blurRadius: 8,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  //
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.91,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      // BoxShadow(
                      //   color: Colors.indigo.shade900.withOpacity(0.3),
                      //   spreadRadius: 5,
                      //   blurRadius: 8,
                      //   offset: const Offset(2, 2),
                      // ),
                    ],
                  ),
                  child: const Center(
                      child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Alphacentauric Interactive Visualization Dashboard",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      height: MediaQuery.of(context).size.height * 0.75,
                      width: MediaQuery.of(context).size.width * 0.23,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.shade900.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 8,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Select Chart Type',
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 8.0),
                                  ),
                                  value: selectedChartType,
                                  items: [
                                    'Line Chart',
                                    'Bar Chart',
                                    'Column Chart',
                                    'Scatter Chart',
                                    'Area Chart',
                                  ].map((chartType) {
                                    return DropdownMenuItem<String>(
                                      value: chartType,
                                      child: Text(chartType,
                                          style: TextStyle(fontSize: 12)),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedChartType = value!;
                                    });
                                  },
                                ),
                                SizedBox(height: 8.0),
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Select Time Period',
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 8.0),
                                  ),
                                  value: timePeriod,
                                  items:
                                      ['Normal', 'Month', 'Year'].map((period) {
                                    return DropdownMenuItem<String>(
                                      value: period,
                                      child: Text(period,
                                          style: TextStyle(fontSize: 12)),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      timePeriod = value!;
                                    });
                                  },
                                ),
                                SizedBox(height: 8.0),
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Select CSV File',
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 8.0),
                                  ),
                                  value: selectedFileName.isEmpty
                                      ? null
                                      : selectedFileName,
                                  items: csvFileNames.map((fileName) {
                                    return DropdownMenuItem<String>(
                                      value: fileName,
                                      child: Text(fileName,
                                          style: TextStyle(fontSize: 12)),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedFileName = value!;
                                      loadColumns(selectedFileName);
                                    });
                                  },
                                ),
                                if (isLoading)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                if (!isLoading && columnNames.isNotEmpty) ...[
                                  SizedBox(height: 8.0),
                                  DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Select X Axis Column',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 8.0),
                                    ),
                                    value: xAxisColumn.isEmpty
                                        ? null
                                        : xAxisColumn,
                                    items: columnNames.map((column) {
                                      return DropdownMenuItem<String>(
                                        value: column,
                                        child: Text(column,
                                            style: TextStyle(fontSize: 12)),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        xAxisColumn = value!;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 8.0),
                                  DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Select Y Axis Column',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 8.0),
                                    ),
                                    value: yAxisColumn.isEmpty
                                        ? null
                                        : yAxisColumn,
                                    items: columnNames.map((column) {
                                      return DropdownMenuItem<String>(
                                        value: column,
                                        child: Text(column,
                                            style: TextStyle(fontSize: 12)),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        yAxisColumn = value!;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 8.0),
                                  TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Enter Graph Title',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 8.0),
                                    ),
                                    style: TextStyle(fontSize: 12),
                                    onChanged: (value) {
                                      setState(() {
                                        graphTitle = value;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 8.0),
                                  TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Enter X Axis Label',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 8.0),
                                    ),
                                    style: TextStyle(fontSize: 12),
                                    onChanged: (value) {
                                      setState(() {
                                        xAxisLabel = value;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 8.0),
                                  TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Enter Y Axis Label',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 8.0),
                                    ),
                                    style: TextStyle(fontSize: 12),
                                    onChanged: (value) {
                                      setState(() {
                                        yAxisLabel = value;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 8.0),
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChartBuilder(
                                              fileName: selectedFileName,
                                              xAxisColumn: xAxisColumn,
                                              yAxisColumn: yAxisColumn,
                                              chartType: selectedChartType,
                                              timePeriod: timePeriod,
                                              graphTitle: graphTitle,
                                              xAxisLabel: xAxisLabel,
                                              yAxisLabel: yAxisLabel,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text('Expand the view',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      //
                      height: MediaQuery.of(context).size.height * 0.75,
                      width: MediaQuery.of(context).size.width * 0.65,
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ChartBuilder(
                          fileName: selectedFileName,
                          xAxisColumn: xAxisColumn,
                          yAxisColumn: yAxisColumn,
                          chartType: selectedChartType,
                          timePeriod: timePeriod,
                          graphTitle: graphTitle,
                          xAxisLabel: xAxisLabel,
                          yAxisLabel: yAxisLabel,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Center(
          //   child: Padding(
          //     padding: const EdgeInsets.all(16.0),
          //     child: Column(
          //       children: [
          //         DropdownButton<String>(
          //           hint: Text('Select CSV File'),
          //           value: selectedFileName.isEmpty ? null : selectedFileName,
          //           items: csvFileNames.map((fileName) {
          //             return DropdownMenuItem<String>(
          //               value: fileName,
          //               child: Text(fileName),
          //             );
          //           }).toList(),
          //           onChanged: (value) {
          //             setState(() {
          //               selectedFileName = value!;
          //               loadColumns(selectedFileName);
          //             });
          //           },
          //         ),
          //         if (isLoading) CircularProgressIndicator(),
          //         if (!isLoading && columnNames.isNotEmpty) ...[
          //           DropdownButton<String>(
          //             hint: Text('Select X Axis Column'),
          //             value: xAxisColumn.isEmpty ? null : xAxisColumn,
          //             items: columnNames.map((column) {
          //               return DropdownMenuItem<String>(
          //                 value: column,
          //                 child: Text(column),
          //               );
          //             }).toList(),
          //             onChanged: (value) {
          //               setState(() {
          //                 xAxisColumn = value!;
          //               });
          //             },
          //           ),
          //           DropdownButton<String>(
          //             hint: Text('Select Y Axis Column'),
          //             value: yAxisColumn.isEmpty ? null : yAxisColumn,
          //             items: columnNames.map((column) {
          //               return DropdownMenuItem<String>(
          //                 value: column,
          //                 child: Text(column),
          //               );
          //             }).toList(),
          //             onChanged: (value) {
          //               setState(() {
          //                 yAxisColumn = value!;
          //               });
          //             },
          //           ),
          //           DropdownButton<String>(
          //             hint: Text('Select Time Period'),
          //             value: timePeriod,
          //             items: [
          //               'Normal',
          //               'Month',
          //               'Year',
          //             ].map((period) {
          //               return DropdownMenuItem<String>(
          //                 value: period,
          //                 child: Text(period),
          //               );
          //             }).toList(),
          //             onChanged: (value) {
          //               setState(() {
          //                 timePeriod = value!;
          //               });
          //             },
          //           ),
          //           TextField(
          //             decoration:
          //                 InputDecoration(hintText: 'Enter Graph Title'),
          //             onChanged: (value) {
          //               setState(() {
          //                 graphTitle = value;
          //               });
          //             },
          //           ),
          //           TextField(
          //             decoration:
          //                 InputDecoration(hintText: 'Enter X Axis Label'),
          //             onChanged: (value) {
          //               setState(() {
          //                 xAxisLabel = value;
          //               });
          //             },
          //           ),
          //           TextField(
          //             decoration:
          //                 InputDecoration(hintText: 'Enter Y Axis Label'),
          //             onChanged: (value) {
          //               setState(() {
          //                 yAxisLabel = value;
          //               });
          //             },
          //           ),
          //           DropdownButton<String>(
          //             hint: Text('Select Chart Type'),
          //             value: selectedChartType,
          //             items: [
          //               'Line Chart',
          //               'Bar Chart',
          //               'Column Chart',
          //               'Scatter Chart',
          //               'Area Chart',
          //             ].map((chartType) {
          //               return DropdownMenuItem<String>(
          //                 value: chartType,
          //                 child: Text(chartType),
          //               );
          //             }).toList(),
          //             onChanged: (value) {
          //               setState(() {
          //                 selectedChartType = value!;
          //               });
          //             },
          //           ),
          //           ElevatedButton(
          //             onPressed: () {
          //               Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                   builder: (context) => ChartBuilder(
          //                     fileName: selectedFileName,
          //                     xAxisColumn: xAxisColumn,
          //                     yAxisColumn: yAxisColumn,
          //                     chartType: selectedChartType,
          //                     timePeriod: timePeriod,
          //                     graphTitle: graphTitle,
          //                     xAxisLabel: xAxisLabel,
          //                     yAxisLabel: yAxisLabel,
          //                   ),
          //                 ),
          //               );
          //             },
          //             child: Text('Generate Chart'),
          //           ),
          //         ],
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

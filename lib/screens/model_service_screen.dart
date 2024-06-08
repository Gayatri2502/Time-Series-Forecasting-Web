import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import '../custom/custom_widgets/build_chart_widget.dart';
import '../custom/custom_widgets/display_chart_widget.dart';
import '../custom/custom_widgets/display_table.dart';
import '../custom/helper_widgets/helper_functions.dart';

class ModelServiceScreen extends StatefulWidget {
  const ModelServiceScreen({super.key});

  @override
  State<ModelServiceScreen> createState() => _ModelServiceScreenState();
}

class _ModelServiceScreenState extends State<ModelServiceScreen> {
  List<Map<String, dynamic>> data = [];
  List<List<dynamic>> csvData = [];
  TextEditingController _controller = TextEditingController();

  late Timer timer;
  HelperFunctions helperFunctions = HelperFunctions();
  bool isLoaded = false;
  String fileName = '';
  int selectedService = -1;
  ChartType selectedChartType = ChartType.Bar;
  bool _isDropdownVisible = false;

  @override
  void initState() {
    super.initState();
    helperFunctions.fetchCsvFileNames();
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Future<void> _refreshCSVData() async {
  //   try {
  //     var newData = await helperFunctions.getAllCSVData();
  //     setState(() {
  //       csvDataMap = newData;
  //     });
  //   } catch (e) {
  //     print("Error fetching CSV data: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            //
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.93,
            decoration: BoxDecoration(
                // color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.indigo.shade200)
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.indigo.withOpacity(0.2),
                //     spreadRadius: 5,
                //     blurRadius: 8,
                //     offset: const Offset(2, 2),
                //   ),
                // ],
                ),
            child: ListTile(
              title: const Text(
                  "Time Series Forecasting: ARIMA & SARIMA Model Creation and Training "),
              titleTextStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              subtitle: const Text(
                  "Dive into the Future with Precision Predictions and Seasonal Insight"),
              subtitleTextStyle: const TextStyle(
                fontSize: 15,
              ),
              trailing: Container(
                width: 300,
                child: Row(
                  children: [
                    ElevatedButton(
                        style: const ButtonStyle(),
                        onPressed: () {},
                        child: const Text("Downloads")),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {}, child: const Text("Guidelines"))
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
              //
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.932,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white70, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  buildServiceContainer(
                      1, "Data Collection", "asset/ml (1).png"),
                  const SizedBox(
                    width: 20,
                  ),
                  buildServiceContainer(2, "Upload Data", "asset/ml (5).png"),
                  const SizedBox(
                    width: 20,
                  ),
                  buildServiceContainer(3, "Visualization", "asset/ml (7).png"),
                  const SizedBox(
                    width: 20,
                  ),
                  buildServiceContainer(4, "Models", "asset/ml (11).png"),
                  const SizedBox(
                    width: 20,
                  ),
                  // buildServiceContainer(3, "Transfer data", "asset/ml (2).png"),
                  // const SizedBox(
                  //   width: 20,
                  // ),
                  buildServiceContainer(5, "Prediction", "asset/ml (10).png"),
                ],
              )),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Column(
                children: [
                  Visibility(
                    visible: selectedService == 1,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.95,
                      width: MediaQuery.of(context).size.width * 0.72,
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.indigo.shade900),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  //
                                  height: MediaQuery.of(context).size.height *
                                      0.683,
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
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
                                        const SizedBox(
                                          height: 50,
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            //_refreshCSVData;
                                          },
                                          icon: const Icon(Icons.refresh),
                                          tooltip: "Load all CSV file",
                                        ),
                                        const SizedBox(
                                          height: 50,
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            HelperFunctions helperFunctions =
                                                HelperFunctions();
                                            List<List<dynamic>> newData =
                                                await helperFunctions
                                                    .uploadCSVToServerHelper(
                                                        csvData);
                                            setState(() {
                                              csvData = newData;
                                            });
                                          },
                                          icon: const Icon(Icons.upload),
                                          tooltip: "upload CSV file",
                                        ),
                                      ],
                                    ),
                                  )),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(6),
                                width:
                                    MediaQuery.of(context).size.width * 0.653,
                                height:
                                    MediaQuery.of(context).size.height * 0.68,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.white10,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FutureBuilder<
                                            List<Map<String, dynamic>>>(
                                          future:
                                              helperFunctions.getAllCSVData(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              return Center(
                                                  child: Text(
                                                      'Error: ${snapshot.error}'));
                                            } else {
                                              List<Map<String, dynamic>>
                                                  uploads = snapshot.data!;

                                              return GridView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                // Set the scroll direction to vertical (default)
                                                itemCount: uploads.length,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 4,
                                                  // Number of columns in the grid
                                                  mainAxisSpacing: 4.0,
                                                  // Spacing between rows
                                                  crossAxisSpacing: 4.0,
                                                  // Spacing between columns
                                                  childAspectRatio: 1 /
                                                      3, // Aspect ratio of each item
                                                ),
                                                itemBuilder: (context, index) {
                                                  Map<String, dynamic> upload =
                                                      uploads[index];
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Container(
                                                      height: 10,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            color:
                                                                Colors.white12,
                                                            width: 2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            spreadRadius: 2,
                                                            blurRadius: 5,
                                                            offset:
                                                                const Offset(
                                                                    0, 3),
                                                          ),
                                                        ],
                                                      ),
                                                      child: ListTile(
                                                        title: Text(
                                                            '[${index}] ${upload['fileName']}',
                                                            style: const TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700)),
                                                        subtitle: Text(
                                                            "click to open ${upload['fileName']} file",
                                                            style: const TextStyle(
                                                                fontSize: 11.0,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w100)),
                                                        trailing: const Icon(
                                                          Icons
                                                              .grid_view_outlined,
                                                          color: Colors.black54,
                                                        ),
                                                        onTap: () async {
                                                          try {
                                                            List<List<dynamic>>
                                                                data =
                                                                await helperFunctions
                                                                    .fetchCSVData(
                                                                        upload[
                                                                            'fileUrl']);
                                                            setState(() {
                                                              csvData = data;
                                                            });
                                                          } catch (e) {
                                                            developer.log(
                                                                'Error in onTap: $e');
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            //
                            height: MediaQuery.of(context).size.height * 0.18,
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                                // color: Colors.indigo.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.indigo.shade900)
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.indigo.withOpacity(0.2),
                                //     spreadRadius: 5,
                                //     blurRadius: 8,
                                //     offset: const Offset(2, 2),
                                //   ),
                                // ],
                                ),
                            child: const ListTile(
                              title: Text(
                                  "See Your Predictions: Upload, Visualize, and Perfect Your Data with AlphaCentauric's Seamless Data Visualization"),
                              titleTextStyle: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              subtitle: Text(
                                  "\nUnlock the potential of your time series data with AlphaCentauric's cutting-edge service. Before creating your ARIMA or SARIMA forecasting model, take the first step by uploading your training data. Our seamless data visualization technique provides a crystal-clear view of your data patterns, enabling you to make informed decisions and optimize your forecasting model. Dive into the world of precision forecasting—start by visualizing your data with AlphaCentauric."),
                              subtitleTextStyle: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: selectedService == 2,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.95,
                      width: MediaQuery.of(context).size.width * 0.72,
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.indigo.shade900),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  //
                                  height: MediaQuery.of(context).size.height *
                                      0.683,
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
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
                                        const SizedBox(
                                          height: 50,
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            HelperFunctions helperFunctions =
                                                HelperFunctions();
                                            List<List<dynamic>> newData =
                                                await helperFunctions
                                                    .uploadCSVToServerHelper(
                                                        csvData);
                                            setState(() {
                                              csvData = newData;
                                            });
                                          },
                                          icon: const Icon(Icons.upload),
                                          tooltip: "upload CSV file",
                                        ),
                                        const SizedBox(
                                          height: 50,
                                        ),
                                      ],
                                    ),
                                  )),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(6),
                                width:
                                    MediaQuery.of(context).size.width * 0.653,
                                height:
                                    MediaQuery.of(context).size.height * 0.68,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.white10,
                                  ),
                                ),
                                child: SingleChildScrollView(
                                    child: Expanded(
                                        child: DisplayTable(csvData: csvData))),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            //
                            height: MediaQuery.of(context).size.height * 0.18,
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                                // color: Colors.indigo.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.indigo.shade900)
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.indigo.withOpacity(0.2),
                                //     spreadRadius: 5,
                                //     blurRadius: 8,
                                //     offset: const Offset(2, 2),
                                //   ),
                                // ],
                                ),
                            child: const ListTile(
                              title: Text(
                                  "See Your Predictions: Upload, Visualize, and Perfect Your Data with AlphaCentauric's Seamless Data Visualization"),
                              titleTextStyle: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              subtitle: Text(
                                  "\nUnlock the potential of your time series data with AlphaCentauric's cutting-edge service. Before creating your ARIMA or SARIMA forecasting model, take the first step by uploading your training data. Our seamless data visualization technique provides a crystal-clear view of your data patterns, enabling you to make informed decisions and optimize your forecasting model. Dive into the world of precision forecasting—start by visualizing your data with AlphaCentauric."),
                              subtitleTextStyle: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: selectedService == 3,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                //
                                height:
                                    MediaQuery.of(context).size.height * 0.9,
                                width: MediaQuery.of(context).size.width * 0.05,
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
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          String resultFileName =
                                              await helperFunctions
                                                  .pickCSVFileHelper(data);
                                          setState(() {
                                            fileName = resultFileName;
                                          });
                                        },
                                        icon: const Icon(
                                            Icons.auto_graph_outlined),
                                        tooltip: "Visualization",
                                      ),
                                    ],
                                  ),
                                )),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              width: MediaQuery.of(context).size.width * 0.653,
                              height: MediaQuery.of(context).size.height * 0.9,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white10,
                                ),
                              ),
                              child: Expanded(
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
                                        items:
                                            ChartType.values.map((chartType) {
                                          return DropdownMenuItem<ChartType>(
                                            value: chartType,
                                            child: Text(chartType
                                                .toString()
                                                .split('.')
                                                .last),
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: selectedService == 4,
                    child: Container(
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.indigo.shade900.withOpacity(0.3),
                                  spreadRadius: 5,
                                  blurRadius: 8,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: const Center(
                                child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                "AlphaCentauric Business Intelligence Management",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
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
                                //
                                height:
                                    MediaQuery.of(context).size.height * 0.75,
                                width: MediaQuery.of(context).size.width * 0.05,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.indigo.shade900
                                          .withOpacity(0.3),
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
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                            Icons.model_training_outlined),
                                        tooltip: "Model creation",
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.timelapse),
                                        tooltip: "Training model",
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                            Icons.account_tree_outlined),
                                        tooltip: "Tuning parameters",
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                            Icons.auto_graph_outlined),
                                        tooltip: "Prediction",
                                      )
                                    ],
                                  ),
                                )),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                //
                                height:
                                    MediaQuery.of(context).size.height * 0.75,
                                width: MediaQuery.of(context).size.width * 0.85,
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
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      //
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.indigo.withOpacity(0.2),
                                            spreadRadius: 5,
                                            blurRadius: 8,
                                            offset: const Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: ListView(
                                          children: [
                                            const Text(
                                              "Intelligence",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            ListTile(
                                              title: const Text(
                                                  "PREDICTIVE MODELS "),
                                              trailing: IconButton(
                                                onPressed: () {},
                                                icon: const Icon(Icons.add),
                                                tooltip: "create new model",
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const ListTile(
                                              title: Text("Model 1"),
                                              leading:
                                                  Icon(Icons.model_training),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const ListTile(
                                              title: Text("Model 2"),
                                              leading:
                                                  Icon(Icons.model_training),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const ListTile(
                                              title: Text("Model 3"),
                                              leading:
                                                  Icon(Icons.model_training),
                                            )
                                          ],
                                        ),
                                      )),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      //
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      width: MediaQuery.of(context).size.width *
                                          0.624,
                                      decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.indigo.withOpacity(0.2),
                                            spreadRadius: 5,
                                            blurRadius: 8,
                                            offset: const Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Text("New Model",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 250,
                                                  child: ListTile(
                                                    title: Text('Model Name'),
                                                    titleTextStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    subtitle: Text(
                                                        'The unique name of this model.'),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                SizedBox(
                                                  width: 500,
                                                  height: 40,
                                                  child: TextFormField(
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          'name your model',
                                                      labelStyle: TextStyle(
                                                          fontSize: 12),
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Please enter model name.';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {},
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  width: 250,
                                                  child: ListTile(
                                                    title: Text(
                                                        'Select your training dataset'),
                                                    titleTextStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    subtitle: Text(
                                                        'Choose a table that has your training data in it.'),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                      width: 500,
                                                      height: 40,
                                                      child: TextFormField(
                                                        controller: _controller,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            helperFunctions
                                                                .filterCsvFileNames(
                                                                    value);
                                                            _isDropdownVisible =
                                                                value
                                                                    .isNotEmpty;
                                                          });
                                                        },
                                                        decoration:
                                                            const InputDecoration(
                                                          suffixIcon: Icon(Icons
                                                              .arrow_drop_down),
                                                          labelText:
                                                              'Select your dataset',
                                                          labelStyle: TextStyle(
                                                              fontSize: 12),
                                                          border:
                                                              OutlineInputBorder(),
                                                        ),
                                                      ),
                                                    ),
                                                    if (_isDropdownVisible)
                                                      Container(
                                                        width: 500,
                                                        height: 200,
                                                        // Adjust the height as needed
                                                        child: ListView.builder(
                                                          itemCount: helperFunctions
                                                              .filteredCsvFileNames
                                                              .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return ListTile(
                                                              title: Text(
                                                                  helperFunctions
                                                                          .filteredCsvFileNames[
                                                                      index],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14)),
                                                              onTap: () {
                                                                setState(() {
                                                                  _controller
                                                                          .text =
                                                                      helperFunctions
                                                                              .filteredCsvFileNames[
                                                                          index];
                                                                  _isDropdownVisible =
                                                                      false;
                                                                });
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 250,
                                                  child: ListTile(
                                                    title: Text(
                                                        'Column to Predict'),
                                                    titleTextStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    subtitle: Text(
                                                        'Choose a column that you want to predict.'),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                SizedBox(
                                                  width: 500,
                                                  height: 40,
                                                  child: TextFormField(
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          'select a column to predict',
                                                      labelStyle: TextStyle(
                                                          fontSize: 12),
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Please enter model name.';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {},
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 250,
                                                  child: ListTile(
                                                    title: Text('Model Inputs'),
                                                    isThreeLine: true,
                                                    titleTextStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    subtitle: Text(
                                                      'Choose a columns that are relevant your prediction problem. If left blank, AlphaCentauric will Automatically select model inputs.',
                                                      maxLines: 5,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                SizedBox(
                                                  width: 500,
                                                  height: 40,
                                                  child: TextFormField(
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          'select any category',
                                                      labelStyle: TextStyle(
                                                          fontSize: 12),
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Please enter model name.';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {},
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Visibility(
                visible: selectedService == 1,
                child: Container(
                    //
                    height: MediaQuery.of(context).size.height * 0.95,
                    width: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.indigo.shade900),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 8,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("asset/ai (6).jpg"),
                        ),
                      ],
                    )

                    // Center(
                    //     child: Padding(
                    //   padding: const EdgeInsets.all(16.0),
                    //   child: Column(
                    //     children: [
                    //       Text('Selected File: $fileName'),
                    //       DropdownButton<ChartType>(
                    //         value: selectedChartType,
                    //         onChanged: (newValue) {
                    //           setState(() {
                    //             selectedChartType = newValue!;
                    //           });
                    //         },
                    //         items: ChartType.values.map((chartType) {
                    //           return DropdownMenuItem<ChartType>(
                    //             value: chartType,
                    //             child: Text(chartType.toString().split('.').last),
                    //           );
                    //         }).toList(),
                    //       ),
                    //       DisplayChartWidget(data: data)
                    //     ],
                    //   ),
                    // )),
                    ),
              ),
              Visibility(
                visible: selectedService == 2,
                child: Container(
                  //
                  height: MediaQuery.of(context).size.height * 0.95,
                  width: MediaQuery.of(context).size.width * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.indigo.shade900),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 8,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: helperFunctions.getAllCSVData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            List<Map<String, dynamic>> uploads = snapshot.data!;

                            return GridView.builder(
                              scrollDirection: Axis.vertical,
                              // Set the scroll direction to vertical (default)
                              itemCount: uploads.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    1, // Number of columns in the grid
                                mainAxisSpacing: 4.0, // Spacing between rows
                                crossAxisSpacing:
                                    4.0, // Spacing between columns
                                childAspectRatio:
                                    9 / 2, // Aspect ratio of each item
                              ),
                              itemBuilder: (context, index) {
                                Map<String, dynamic> upload = uploads[index];
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.white12, width: 2),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      title: Text(
                                          '[${index}] ${upload['fileName']}',
                                          style: const TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      trailing: const Icon(
                                        Icons.edit_attributes,
                                        color: Colors.black54,
                                      ),
                                      onTap: () async {
                                        try {
                                          List<List<dynamic>> data =
                                              await helperFunctions
                                                  .fetchCSVData(
                                                      upload['fileUrl']);
                                          setState(() {
                                            csvData = data;
                                          });
                                        } catch (e) {
                                          developer.log('Error in onTap: $e');
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // const SizedBox(
          //   height: 25,
          // ),
          // Container(
          //   //
          //   height: MediaQuery.of(context).size.height * 0.93,
          //   width: MediaQuery.of(context).size.width * 0.93,
          //   decoration: BoxDecoration(
          //     color: Colors.indigo.shade50,
          //     borderRadius: BorderRadius.circular(10),
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.indigo.withOpacity(0.2),
          //         spreadRadius: 5,
          //         blurRadius: 8,
          //         offset: const Offset(2, 2),
          //       ),
          //     ],
          //   ),
          //   child: const Center(),
          // ),
        ],
      ),
    );
  }

  Widget buildServiceContainer(int index, String serviceTitle, String path) {
    return InkWell(
      // hoverColor: Colors.red,
      // hoverDuration: Duration(milliseconds: 200),
      onTap: () {
        setState(() {
          selectedService = index;
        });

        print(index);
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.1,
        decoration: BoxDecoration(
          color:
              selectedService == index ? Colors.black26 : Colors.indigo.shade50,
          borderRadius: BorderRadius.circular(10),
          border: selectedService == index
              ? Border.all(
                  color: Colors.indigo.shade50,
                )
              : Border.all(color: Colors.indigo.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.shade900.withOpacity(1),
              spreadRadius: selectedService == index ? 0 : 2,
              blurRadius: selectedService == index ? 0 : 3,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Image.asset(
                "${path}",
                height: 90,
              ),
              Padding(
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    serviceTitle,
                    style: TextStyle(
                        fontSize: 13,
                        color: selectedService == index
                            ? Colors.white
                            : Colors.black),
                  ))
            ],
          ),
        )),
      ),
    );
  }
}

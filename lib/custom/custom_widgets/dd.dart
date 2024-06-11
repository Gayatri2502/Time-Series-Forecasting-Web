import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../helper_widgets/helper_functions.dart';

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  TextEditingController _controller = TextEditingController();
  List<String> columns = [];
  String? selectedMonthColumn;
  String? selectedSalesColumn;
  String selectedSeasonality = 'Monthly';
  Uint8List? fileBytes;
  String? fileName;
  bool isLoading = false;
  Map<String, dynamic>? serverResponse;
  bool _isDropdownVisible = false;
  HelperFunctions helperFunctions = HelperFunctions();
  List<Map<String, dynamic>> data = [];
  List<List<dynamic>> csvData = [];

  // Function to load CSV and update columns
  Future<void> _loadCsvAndUpdateColumns(String fileName) async {
    List<String>? extractedColumns =
        await helperFunctions.loadCsvAndExtractColumns(fileName);
    setState(() {
      helperFunctions.columnNames = extractedColumns!;
      selectedMonthColumn = null; // Reset selected column
    });
  }

  @override
  void initState() {
    super.initState();
    helperFunctions.fetchCsvFileNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload CSV'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
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
                              height: MediaQuery.of(context).size.height * 0.75,
                              width: MediaQuery.of(context).size.width * 0.05,
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
                                      icon:
                                          const Icon(Icons.auto_graph_outlined),
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
                              height: MediaQuery.of(context).size.height * 0.75,
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
                                    height: MediaQuery.of(context).size.height *
                                        0.7,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    decoration: BoxDecoration(
                                      color: Colors.white70,
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
                                            title: Text("SARIMA MODEL"),
                                            leading: Icon(Icons.model_training),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const ListTile(
                                            title: Text("Model 2"),
                                            leading: Icon(Icons.model_training),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const ListTile(
                                            title: Text("Model 3"),
                                            leading: Icon(Icons.model_training),
                                          )
                                        ],
                                      ),
                                    )),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
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
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text("New Model",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  const Spacer(),
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Colors
                                                                  .black54), // Set your desired background color
                                                    ),
                                                    onPressed: () async {
                                                      if (_controller
                                                              .text.isNotEmpty &&
                                                          selectedMonthColumn !=
                                                              null &&
                                                          selectedSalesColumn !=
                                                              null) {
                                                        setState(() {
                                                          isLoading = true;
                                                        });

                                                        // Assuming the file is fetched based on the file name in _controller.text
                                                        String fileName =
                                                            _controller.text;

                                                        await helperFunctions
                                                            .postToFlaskServer(
                                                          fileName: fileName,
                                                          selectedMonthColumn:
                                                              selectedMonthColumn!,
                                                          selectedSalesColumn:
                                                              selectedSalesColumn!,
                                                          selectedSeasonality:
                                                              selectedSeasonality,
                                                          onSuccess:
                                                              (response) {
                                                            setState(() {
                                                              isLoading = false;
                                                              serverResponse =
                                                                  response;
                                                            });
                                                          },
                                                          onError: (error) {
                                                            setState(() {
                                                              isLoading = false;
                                                            });
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                  content: Text(
                                                                      error)),
                                                            );
                                                          },
                                                        );
                                                      } else {
                                                        print(
                                                            'Please select all fields');
                                                      }
                                                    },
                                                    child: const Text(
                                                      'SUBMIT',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.white70),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 30),
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
                                                  const SizedBox(width: 20),
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        width: 500,
                                                        height: 50,
                                                        child: TextFormField(
                                                          controller:
                                                              _controller,
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
                                                            labelStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        12),
                                                            border:
                                                                OutlineInputBorder(),
                                                          ),
                                                        ),
                                                      ),
                                                      if (_isDropdownVisible)
                                                        Container(
                                                          width: 500,
                                                          height: 100,
                                                          child:
                                                              ListView.builder(
                                                            itemCount:
                                                                helperFunctions
                                                                    .filteredCsvFileNames
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return ListTile(
                                                                title: Text(
                                                                  helperFunctions
                                                                          .filteredCsvFileNames[
                                                                      index],
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                                onTap: () {
                                                                  setState(() {
                                                                    _controller
                                                                        .text = helperFunctions
                                                                            .filteredCsvFileNames[
                                                                        index];
                                                                    _isDropdownVisible =
                                                                        false;
                                                                  });
                                                                  // Load the CSV and extract columns here
                                                                  // You need to implement this functionality
                                                                  _loadCsvAndUpdateColumns(
                                                                      _controller
                                                                          .text);
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 250,
                                                    child: ListTile(
                                                      title: Text(
                                                          'Select Temporal Column'),
                                                      titleTextStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      subtitle: Text(
                                                          'Choose the column that represents time-based records for temporal analysis.'),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  SizedBox(
                                                    width: 500,
                                                    height: 50,
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      value:
                                                          selectedMonthColumn,
                                                      items: helperFunctions
                                                          .columnNames
                                                          .map((String column) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: column,
                                                          child: Text(
                                                            column,
                                                          ),
                                                        );
                                                      }).toList(),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          selectedMonthColumn =
                                                              newValue;
                                                        });
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText:
                                                            'Select Time Column',
                                                        labelStyle: TextStyle(
                                                            fontSize: 12),
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
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
                                                          'Choose the column containing sales figures for trend analysis and forecasting.'),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  SizedBox(
                                                    width: 500,
                                                    height: 50,
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      value:
                                                          selectedSalesColumn,
                                                      hint: const Text(
                                                          'Select Sales Column'),
                                                      items: helperFunctions
                                                          .columnNames
                                                          .map((String column) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: column,
                                                          child: Text(column),
                                                        );
                                                      }).toList(),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          selectedSalesColumn =
                                                              newValue;
                                                        });
                                                      },
                                                      selectedItemBuilder:
                                                          (BuildContext
                                                              context) {
                                                        return helperFunctions
                                                            .columnNames
                                                            .map<Widget>((String
                                                                column) {
                                                          return Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              column,
                                                            ),
                                                          );
                                                        }).toList();
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText:
                                                            'Select Sales Column',
                                                        labelStyle: TextStyle(
                                                            fontSize: 12),
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 250,
                                                    child: ListTile(
                                                      title: Text(
                                                          'Seasonality Configuration'),
                                                      isThreeLine: true,
                                                      titleTextStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      subtitle: Text(
                                                        'Select columns that capture seasonal patterns to improve prediction accuracy.',
                                                        maxLines: 5,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  SizedBox(
                                                    width: 500,
                                                    height: 50,
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      value:
                                                          selectedSeasonality,
                                                      hint: const Text(
                                                          'Select Seasonality'),
                                                      items: [
                                                        'Monthly',
                                                        'Quarterly',
                                                        'Daily'
                                                      ].map(
                                                          (String seasonality) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: seasonality,
                                                          child:
                                                              Text(seasonality),
                                                        );
                                                      }).toList(),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          selectedSeasonality =
                                                              newValue!;
                                                        });
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText:
                                                            'Select Seasonality',
                                                        labelStyle: TextStyle(
                                                            fontSize: 12),
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              if (isLoading)
                                                const CircularProgressIndicator(),
                                              if (serverResponse != null)
                                                _buildResultsDisplay(),
                                            ],
                                          ),
                                        ),
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
                  const SizedBox(
                    height: 100,
                  ),
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     await _pickFile();
                  //   },
                  //   child: Text(fileName ?? 'Select CSV File'),
                  // ),
                  // if (columns.isNotEmpty) ...[
                  //   DropdownButtonFormField<String>(
                  //     value: selectedMonthColumn,
                  //     hint: Text('Select Month Column'),
                  //     items: columns.map((String column) {
                  //       return DropdownMenuItem<String>(
                  //         value: column,
                  //         child: Text(column),
                  //       );
                  //     }).toList(),
                  //     onChanged: (newValue) {
                  //       setState(() {
                  //         selectedMonthColumn = newValue;
                  //       });
                  //     },
                  //   ),
                  //   DropdownButtonFormField<String>(
                  //     value: selectedSalesColumn,
                  //     hint: Text('Select Sales Column'),
                  //     items: columns.map((String column) {
                  //       return DropdownMenuItem<String>(
                  //         value: column,
                  //         child: Text(column),
                  //       );
                  //     }).toList(),
                  //     onChanged: (newValue) {
                  //       setState(() {
                  //         selectedSalesColumn = newValue;
                  //       });
                  //     },
                  //   ),
                  //   DropdownButtonFormField<String>(
                  //     value: selectedSeasonality,
                  //     hint: Text('Select Seasonality'),
                  //     items: ['Monthly', 'Quarterly', 'Daily']
                  //         .map((String seasonality) {
                  //       return DropdownMenuItem<String>(
                  //         value: seasonality,
                  //         child: Text(seasonality),
                  //       );
                  //     }).toList(),
                  //     onChanged: (newValue) {
                  //       setState(() {
                  //         selectedSeasonality = newValue!;
                  //       });
                  //     },
                  //   ),
                  //   ElevatedButton(
                  //     onPressed: () async {
                  //       if (fileBytes != null &&
                  //           selectedMonthColumn != null &&
                  //           selectedSalesColumn != null) {
                  //         setState(() {
                  //           isLoading = true;
                  //         });
                  //         await csvHelper.loadCSVAndUpload(
                  //           fileBytes: fileBytes!,
                  //           fileName: fileName!,
                  //           selectedMonthColumn: selectedMonthColumn!,
                  //           selectedSalesColumn: selectedSalesColumn!,
                  //           selectedSeasonality: selectedSeasonality,
                  //           onSuccess: (response) {
                  //             setState(() {
                  //               isLoading = false;
                  //               serverResponse = response;
                  //             });
                  //           },
                  //           onError: (error) {
                  //             setState(() {
                  //               isLoading = false;
                  //             });
                  //             ScaffoldMessenger.of(context).showSnackBar(
                  //               SnackBar(content: Text(error)),
                  //             );
                  //           },
                  //         );
                  //       } else {
                  //         print('Please select all fields');
                  //       }
                  //     },
                  //     child: Text('Submit'),
                  //   ),
                  // ],
                  // if (isLoading) CircularProgressIndicator(),
                  // if (serverResponse != null) _buildResultsDisplay(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.bytes != null) {
        PlatformFile file = result.files.first;
        Uint8List bytes = result.files.single.bytes!;
        String csvString = String.fromCharCodes(bytes);
        List<List<dynamic>> csvData =
            const CsvToListConverter().convert(csvString);

        if (csvData.isNotEmpty) {
          setState(() {
            fileBytes = bytes;
            fileName = file.name;
            columns = csvData.first.map((e) => e.toString()).toList();
          });
        }
      }
    } catch (e) {
      print("Error picking or reading CSV file: $e");
    }
  }

  Widget _buildResultsDisplay() {
    final forecastSeries = serverResponse?['forecast_series'] ?? '';
    final acfImgBase64 = serverResponse?['acf_img'] ?? '';
    final mae = (serverResponse?['mae'] ?? '').toString();
    final rmse = (serverResponse?['rmse'] ?? '').toString();
    final comparisonPlotBase64 = serverResponse?['comparison_plot'] ?? '';
    final forecastPlotBase64 = serverResponse?['forecast_plot'] ?? '';

    return Column(
      children: [
        _buildHeadline(
            "Cautionary Forecasts: Insights for Consideration, Not Concrete Decisions"),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Error Metrics in Time Series Analysis',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Error metrics in time series analysis are essential for evaluating the accuracy of forecasting models. They provide quantitative measures of the difference between actual observed values and the values predicted by the model. These metrics help in understanding the model\'s performance and in comparing different models to select the best one for forecasting future values.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Mean Absolute Error (MAE)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildMetric('Mean Absolute Error', mae),
              const SizedBox(height: 10),
              const Text(
                'The MAE is the average of the absolute differences between the actual values and the predicted values.\nInterpretation: MAE measures the average magnitude of errors in a set of forecasts, without considering their direction. It provides a straightforward measure of forecast accuracy, where lower values indicate better model performance.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Root Mean Square Error (RMSE)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildMetric('Root Mean Squared Error', rmse),
              const SizedBox(height: 10),
              const Text(
                'The RMSE is the square root of the average of the squared differences between the actual and predicted values.\nInterpretation: RMSE gives a relatively high weight to large errors because the errors are squared before they are averaged. This means that RMSE is more sensitive to outliers compared to MAE. A lower RMSE indicates a better fit of the model to the data.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Why We Need Error Metrics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: '• Model Evaluation: ',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text:
                          'Error metrics help in assessing how well a forecasting model is performing. They provide a numerical value that summarizes the model\'s accuracy.\n',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                      ),
                    ),
                    TextSpan(
                      text: '• Model Comparison: ',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text:
                          'Different forecasting models can be compared using these metrics. The model with the lower error metric is generally considered better.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Evaluating Metrics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'To evaluate the performance of a forecasting model using MAE and RMSE:\n1. Calculate Forecasts: Use the model to generate forecasts for a set of historical data.\n2. Compute Errors: Calculate the difference between the actual values and the forecasted values for each time point.\n3. Apply Metrics: Compute MAE and RMSE using the formulas provided.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Analyze Results',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: '• MAE: ',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text:
                          'Check the average magnitude of errors. Lower MAE indicates fewer errors on average.\n',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                      ),
                    ),
                    TextSpan(
                      text: '• RMSE: ',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text:
                          'Assess the presence of large errors. A significantly higher RMSE compared to MAE indicates that there are some large errors impacting the performance.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Compare Models',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'If you have multiple models, compute these metrics for each and compare. The model with the lowest MAE and RMSE generally performs best.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Forecasting Series Output:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (forecastSeries.isNotEmpty)
                _buildForecastSeries(forecastSeries),
              const SizedBox(height: 10),
              const Text(
                'The received forecasting series output represents the predicted values generated by the forecasting model for future time periods based on historical data. These predicted values provide insights into the expected trends, patterns, and behavior of the target variable over time. Typically, the forecasting series output includes a sequence of forecasted values for each time point in the forecast horizon.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // ACF Plot Section
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ACF Plot',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'The ACF plot displays the autocorrelation coefficients of the time series data at different lags.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Look for significant spikes at specific lags, which indicate strong autocorrelation.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Seasonal patterns can be identified by observing regular spikes at fixed intervals, such as seasonal lags (e.g., lag 12 for monthly data).',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'The decay of autocorrelation with increasing lags can indicate the presence of trends or seasonality.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        if (acfImgBase64.isNotEmpty)
          _buildImageSection('Autocorrelation Function Plot', acfImgBase64),
        const SizedBox(height: 20),
        const SizedBox(height: 20),
        // Forecast Plot Series Output Section
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Forecast Plot Series Output',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'The forecast plot series output provides predictions for future values based on the forecasting model.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Compare the forecasted values with the actual values to assess the accuracy of the model.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Look for trends, seasonality, or any deviation from expected patterns in the forecasted series.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (forecastPlotBase64.isNotEmpty)
          _buildImageSection('Forecast Plot', forecastPlotBase64),
        // Assumptions and Conclusion Section
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Assumptions and Conclusion',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '• If the ACF plot shows strong autocorrelation at lag 1 and gradually decays with increasing lags, it suggests a trend or seasonality in the data. In such cases, forecasting models like ARIMA (AutoRegressive Integrated Moving Average) could be suitable.\n',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                      ),
                    ),
                    TextSpan(
                      text:
                          '• Seasonal spikes at specific lags in the ACF plot imply seasonality in the data, guiding the selection of appropriate seasonal models such as SARIMA (Seasonal ARIMA) for forecasting.\n',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                      ),
                    ),
                    TextSpan(
                      text:
                          '• If the forecast plot series output closely follows the observed data without significant deviations, it indicates that the forecasting model captures the data dynamics well, enabling reliable future predictions.\n',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (comparisonPlotBase64.isNotEmpty)
          _buildImageSection('Actual vs Predicted Plot', comparisonPlotBase64),
      ],
    );
  }

  Widget _buildHeadline(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.red.shade800),
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildForecastSeries(String series) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Forecast Series:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(series),
        ],
      ),
    );
  }

  Widget _buildImageSection(String title, String base64Image) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Image.memory(base64Decode(base64Image)),
        ],
      ),
    );
  }
}

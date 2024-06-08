import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CSVHelper {
  final String flaskApiUrl;

  CSVHelper({required this.flaskApiUrl});

  Future<void> loadCSVAndUpload({
    required Uint8List fileBytes,
    required String fileName,
    required String selectedMonthColumn,
    required String selectedSalesColumn,
    required String selectedSeasonality,
    required void Function(Map<String, dynamic>) onSuccess,
    required void Function(String) onError,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(flaskApiUrl));
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: fileName,
        ),
      );
      request.fields['time_column'] = selectedMonthColumn;
      request.fields['sales_column'] = selectedSalesColumn;
      request.fields['seasonality'] = selectedSeasonality;

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);
      print('Uploading to Flask server');
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = await Future.delayed(
          Duration(seconds: 1),
          () => responseData.body.isNotEmpty
              ? json.decode(responseData.body)
              : {},
        );

        print('CSV file uploaded successfully to Flask server');
        print('Response from server: $responseJson');

        onSuccess(responseJson);
      } else {
        String errorResponse =
            'Failed to upload CSV file to Flask server: ${responseData.body}';
        print(errorResponse);
        onError(errorResponse);
      }
    } catch (e) {
      String errorResponse = 'Error picking or uploading CSV file: $e';
      print(errorResponse);
      onError(errorResponse);
    }
  }
}

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final CSVHelper csvHelper =
      CSVHelper(flaskApiUrl: 'http://127.0.0.1:5000/predict');
  List<String> columns = [];
  String? selectedMonthColumn;
  String? selectedSalesColumn;
  String selectedSeasonality = 'Monthly';
  Uint8List? fileBytes;
  String? fileName;
  bool isLoading = false;
  Map<String, dynamic>? serverResponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload CSV'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: 600,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await _pickFile();
                    },
                    child: Text(fileName ?? 'Select CSV File'),
                  ),
                  if (columns.isNotEmpty) ...[
                    DropdownButtonFormField<String>(
                      value: selectedMonthColumn,
                      hint: Text('Select Month Column'),
                      items: columns.map((String column) {
                        return DropdownMenuItem<String>(
                          value: column,
                          child: Text(column),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedMonthColumn = newValue;
                        });
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedSalesColumn,
                      hint: Text('Select Sales Column'),
                      items: columns.map((String column) {
                        return DropdownMenuItem<String>(
                          value: column,
                          child: Text(column),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedSalesColumn = newValue;
                        });
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedSeasonality,
                      hint: Text('Select Seasonality'),
                      items: ['Monthly', 'Quarterly', 'Daily']
                          .map((String seasonality) {
                        return DropdownMenuItem<String>(
                          value: seasonality,
                          child: Text(seasonality),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedSeasonality = newValue!;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (fileBytes != null &&
                            selectedMonthColumn != null &&
                            selectedSalesColumn != null) {
                          setState(() {
                            isLoading = true;
                          });
                          await csvHelper.loadCSVAndUpload(
                            fileBytes: fileBytes!,
                            fileName: fileName!,
                            selectedMonthColumn: selectedMonthColumn!,
                            selectedSalesColumn: selectedSalesColumn!,
                            selectedSeasonality: selectedSeasonality,
                            onSuccess: (response) {
                              setState(() {
                                isLoading = false;
                                serverResponse = response;
                              });
                            },
                            onError: (error) {
                              setState(() {
                                isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error)),
                              );
                            },
                          );
                        } else {
                          print('Please select all fields');
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ],
                  if (isLoading) CircularProgressIndicator(),
                  if (serverResponse != null) _buildResultsDisplay(),
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
    final mae = serverResponse?['mae'] ?? '';
    final rmse = serverResponse?['rmse'] ?? '';
    final comparisonPlotBase64 = serverResponse?['comparison_plot'] ?? '';
    final forecastPlotBase64 = serverResponse?['forecast_plot'] ?? '';

    return Column(
      children: [
        Text('Mean Absolute Error: $mae'),
        Text('Root Mean Squared Error: $rmse'),
        SizedBox(height: 20),
        if (forecastSeries.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Forecast Series:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(forecastSeries),
            ],
          ),
        SizedBox(height: 20),
        if (acfImgBase64.isNotEmpty) ...[
          Text('Autocorrelation Function Plot:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Image.memory(base64Decode(acfImgBase64)),
        ],
        SizedBox(height: 20),
        if (forecastPlotBase64.isNotEmpty) ...[
          Text('Forecast Plot:', style: TextStyle(fontWeight: FontWeight.bold)),
          Image.memory(base64Decode(forecastPlotBase64)),
        ],
        SizedBox(height: 20),
        if (comparisonPlotBase64.isNotEmpty) ...[
          Text('Actual vs Predicted Plot:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Image.memory(base64Decode(comparisonPlotBase64)),
        ],
      ],
    );
  }
}

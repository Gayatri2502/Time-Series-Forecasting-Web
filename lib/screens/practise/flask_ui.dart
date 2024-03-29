import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../model_service_screen.dart';

class SalesPredictionPage extends StatefulWidget {
  @override
  _SalesPredictionPageState createState() => _SalesPredictionPageState();
}

class _SalesPredictionPageState extends State<SalesPredictionPage> {
  bool _isDarkMode = false;
  String _selectedSalesColumn = '';
  String _selectedTimeColumn = '';
  String _selectedSeasonality = '';
  String _filePath = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Prediction'),
        actions: [
          IconButton(
            icon: Icon(Icons.lightbulb_outline),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Our Sales Prediction App',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Sales Prediction Form',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                String? filePath = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['csv'],
                ).then((value) => value?.files.single.path);

                setState(() {
                  _filePath = filePath ?? '';
                });
              },
              child: Text('Select CSV File'),
            ),
            SizedBox(height: 20.0),
            _buildDropdown(
              'Select Sales Column',
              ['Column A', 'Column B', 'Column C'],
              (value) {
                setState(() {
                  _selectedSalesColumn = value as String;
                });
              },
            ),
            SizedBox(height: 10.0),
            _buildDropdown(
              'Select Time Column',
              ['Column 1', 'Column 2', 'Column 3'],
              (value) {
                setState(() {
                  _selectedTimeColumn = value as String;
                });
              },
            ),
            SizedBox(height: 10.0),
            _buildDropdown(
              'Select Seasonality',
              ['Monthly', 'Quarterly', 'Daily'],
              (value) {
                setState(() {
                  _selectedSeasonality = value as String;
                });
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ModelServiceScreen();
                }));
                // Implement code to send data to server and handle response
              },
              child: Text('Predict'),
            ),
            SizedBox(height: 20.0),
            Text(
              'File Path: $_filePath',
              style: TextStyle(fontSize: 16.0),
            ),
            // Implement Autocorrelation plot, Forecast plot, Comparison plot as needed.
            // Implement Review this Prediction section with star ratings.
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
      String label, List<String> options, Function onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        DropdownButton(
          value: options.isNotEmpty ? options[0] : null,
          items: options.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: onChanged as void Function(String?)?,
        ),
      ],
    );
  }
}

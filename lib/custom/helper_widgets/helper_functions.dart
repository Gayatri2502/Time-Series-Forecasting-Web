import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:alpha_forecast_app/url/api_url.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class HelperFunctions {
  String fileName = '';
  Uint8List? fileBytes;
  List<String> uploadedFiles = [];
  ApiUrl _apiUrl = ApiUrl();
  List<String> csvFileNames = [];
  List<String> filteredCsvFileNames = [];

  // Display names of uploaded csv files
  Future<List<Map<String, dynamic>>> getAllCSVData() async {
    CollectionReference csvFilesRef =
        FirebaseFirestore.instance.collection('csvFiles');
    List<Map<String, dynamic>> uploads = [];

    try {
      QuerySnapshot querySnapshot = await csvFilesRef.get();

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data()
            as Map<String, dynamic>?; // Casting to Map<String, dynamic>?
        if (data != null) {
          // Check if data is not null
          uploads.add({
            'fileName': data['fileName'],
            'fileUrl': data['fileUrl'],
          });
        }
      });

      return uploads;
    } catch (e) {
      print("Error fetching CSV data: $e");
      return [];
    }
  }

  // fetch csv data from file path
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<List<List<dynamic>>> fetchCSVData(String fileUrl) async {
    try {
      final Reference ref = storage.refFromURL(fileUrl);
      final String downloadUrl = await ref.getDownloadURL();

      final http.Response response = await http.get(Uri.parse(downloadUrl));

      if (response.statusCode == 200) {
        final List<List<dynamic>> csvData =
            const CsvToListConverter().convert(response.body);
        return csvData;
      } else {
        developer.log(
            'Failed to load CSV file with status code: ${response.statusCode}');
        throw Exception('Failed to load CSV file');
      }
    } catch (e) {
      developer.log('Error fetching CSV data: $e');
      throw Exception('Error fetching CSV data: $e');
    }
  }

  //dropdown csv list names
  Future<void> fetchCsvFileNames() async {
    List<Map<String, dynamic>> csvData = await getAllCSVData();
    csvFileNames = csvData.map((data) => data['fileName'] as String).toList();
  }

  //to filter dropdown list names
  void filterCsvFileNames(String query) {
    filteredCsvFileNames = csvFileNames
        .where(
            (fileName) => fileName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<List<dynamic>>> loadCSVHelper(List<List<dynamic>> csvData) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;

        print(file.name);
        print(file.size);
        print(file.extension);

        if (result.files.single.bytes != null) {
          List<int> fileBytes = result.files.single.bytes!;
          String fileName = result.files.single.name;
          final csvString = String.fromCharCodes(fileBytes);
          List<List<dynamic>> decodedData =
              const CsvToListConverter().convert(csvString);

          try {
            print('Uploading file to Flask...');
            var request = http.MultipartRequest(
              'POST',
              Uri.parse(_apiUrl.csvUpload),
            );
            request.files.add(
              http.MultipartFile.fromBytes(
                'file',
                fileBytes,
                filename: fileName,
              ),
            );
            var response = await request.send();
            if (response.statusCode == 200) {
              print('CSV file uploaded successfully to Flask server');

              try {
                print('Uploading file to Firebase Cloud Storage...');
                Reference storageReference = FirebaseStorage.instance
                    .ref()
                    .child('TimeSeriesData/$fileName');

                // Uint8List fileBytes = Uint8List.fromList(result.files.single.bytes!);

                // Upload file to Firebase Cloud Storage
                await storageReference.putData(Uint8List.fromList(fileBytes));

                // File uploaded successfully to Cloud Storage, now save reference to Realtime Database
                String fileUrl = await storageReference.getDownloadURL();

                // Save reference to Realtime Database
                CollectionReference filesCollection =
                    FirebaseFirestore.instance.collection('csvFiles');
                await filesCollection.add({
                  'fileName': fileName,
                  'fileUrl': fileUrl,
                  'fileData': Uint8List.fromList(fileBytes),
                });

                print(
                    'File uploaded to Firebase Cloud Storage and reference saved to Realtime Database');
              } catch (e) {
                print('Error uploading file to Firebase: $e');
              }
            } else {
              print(
                  'Failed to upload CSV file to Flask server: ${response.reasonPhrase}');
            }
          } catch (e) {
            print('Error uploading file to flask: $e');
          }
          return decodedData;
        }
      }
    } catch (e) {
      print("Error picking or uploading CSV file: $e");
    }
    return [];
  }

  // Future<List<String>> getUploadedFiles() async {
  //   try {
  //     // Reference to the folder in Firebase Storage where CSV files are stored
  //     Reference storageReference =
  //         FirebaseStorage.instance.ref().child('TimeSeriesData/');
  //
  //     // List all items (files) in the folder
  //     ListResult result = await storageReference.listAll();
  //
  //     // Extract file names from the list result
  //     for (Reference ref in result.items) {
  //       uploadedFiles.add(ref.name);
  //     }
  //   } catch (e) {
  //     print('Error fetching uploaded files from Firebase: $e');
  //   }
  //
  //   return uploadedFiles;
  // }
//------------------------------------------------------------------------------------------------
//   Future loadCSVHelper(List<List<dynamic>> csvData) async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['csv'],
//       );
//
//       if (result != null) {
//         PlatformFile file = result.files.first;
//
//         print(file.name);
//         print(file.size);
//         print(file.extension);
//
//         //----------------------------------------------------------------
//         // flask upload
//
//         if (result.files.single.bytes != null) {
//           fileBytes = result.files.single.bytes;
//           fileName = result.files.single.name;
//           final csvString = String.fromCharCodes(fileBytes!);
//           List<List<dynamic>> decodedData =
//               const CsvToListConverter().convert(csvString);
//
//           if (fileBytes != null) {
//             try {
//               print('Uploading file to Flask...');
//               var request = http.MultipartRequest(
//                 'POST',
//                 Uri.parse(_apiUrl.csvUpload),
//               );
//               request.files.add(
//                 http.MultipartFile.fromBytes(
//                   'file',
//                   fileBytes!.toList(),
//                   filename: fileName,
//                 ),
//               );
//               var response = await request.send();
//               if (response.statusCode == 200) {
//                 //----------------------------------------------------------------
//                 //Firebase upload
//
//                 print('CSV file uploaded successfully to Flask server');
//                 if (fileBytes != null) {
//                   // File picked successfully, now upload to Firebase
//                   try {
//                     print('Uploading file to Firebase...');
//                     // Reference storageReference = FirebaseStorage.instance.ref().child(
//                     //     'csv_files/${DateTime.now().millisecondsSinceEpoch}.csv');
//
//                     Reference storageReference = FirebaseStorage.instance
//                         .ref()
//                         .child('TimeSeriesData/${fileName}');
//
//                     await storageReference.putData(fileBytes!);
//
//                     // File uploaded successfully
//                     print('File uploaded to Firebase Cloud Storage');
//                   } catch (e) {
//                     print('Error uploading file to Firebase: $e');
//                   }
//                 }
//               } else {
//                 print(
//                     'Failed to upload CSV file to Flask server: ${response.reasonPhrase}');
//               }
//             } catch (e) {
//               print('Error uploading file to flask: $e');
//             }
//           }
//           return decodedData;
//         }
//       }
//     } catch (e) {
//       print("Error picking or uploading CSV file: $e");
//     }
//   }
//------------------------------------------------------------------------------------------------
  // Future loadCSVHelper(List<List<dynamic>> csvData) async {
  //   FilePickerResult? result;
  //   List<List<dynamic>> decodedData = [];
  //
  //   try {
  //     result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['csv'],
  //     );
  //   } catch (e) {
  //     print('Error picking a file: $e');
  //   }
  //
  //   if (result != null) {
  //     if (result.isSinglePick) {
  //       final file = result.files.single.bytes;
  //       final csvString = String.fromCharCodes(file!);
  //       decodedData = const CsvToListConverter().convert(csvString);
  //     } else {
  //       print('Multiple file picks are not supported in this example.');
  //     }
  //
  //     // Instead of returning csvData, you can return decodedData directly
  //     return decodedData;
  //   }
  //
  //   // If there's no result, return an empty list or null based on your use case
  //   return [];
  // }

  Future pickCSVFileHelper(List<Map<String, dynamic>> data) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result != null) {
      fileName = result.files.single.name;
      Uint8List fileBytes = result.files.single.bytes!;
      String csvString = String.fromCharCodes(fileBytes);

      List<List<dynamic>> csvTable =
          const CsvToListConverter().convert(csvString);

      int numRows = csvTable.length;
      int numColumns = csvTable.isNotEmpty ? csvTable[0].length : 0;

      data.clear();

      if (numRows > 0) {
        List<dynamic> headers = csvTable[0];
        int lastColumnIndex = headers.length - 1; // Index of the last column

        for (int i = 1; i < numRows; i++) {
          List<dynamic> row = csvTable[i];

          if (row.length >= numColumns) {
            Map<String, dynamic> rowData = {
              'Category': row.sublist(0, lastColumnIndex).toString(),
              'Value': double.tryParse(row[lastColumnIndex].toString()) ?? 0.0,
            };
            data.add(rowData);
          }
        }
      }

      return fileName;
    }
  }
}

import 'dart:convert';
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
  List<String> columnNames = [];
  List<String> filteredCsvFileNames = [];

  Future<List<Map<String, dynamic>>> getAllCSVData() async {
    CollectionReference csvFilesRef =
        FirebaseFirestore.instance.collection('csvFiles');
    List<Map<String, dynamic>> uploads = [];

    try {
      QuerySnapshot querySnapshot = await csvFilesRef.get();

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
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

  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<List<List<dynamic>>> fetchCSVData(String fileUrl) async {
    try {
      // Validate URL format
      if (!fileUrl.startsWith('gs://') && !fileUrl.startsWith('https://')) {
        throw FormatException('Invalid URL format: $fileUrl');
      }

      // Debug log to verify URL
      print('Fetching CSV data from URL: $fileUrl');

      // Get the download URL directly without re-decoding it
      final Reference ref = storage.refFromURL(fileUrl);
      final String downloadUrl = await ref.getDownloadURL();

      // Debug log to verify download URL
      print('Download URL: $downloadUrl');

      // Fetch CSV file data
      final http.Response response = await http.get(Uri.parse(downloadUrl));

      if (response.statusCode == 200) {
        final List<List<dynamic>> csvData =
            const CsvToListConverter().convert(utf8.decode(response.bodyBytes));
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

  Future<void> fetchCsvFileNames() async {
    List<Map<String, dynamic>> csvData = await getAllCSVData();
    csvFileNames = csvData.map((data) => data['fileName'] as String).toList();
  }

  void filterCsvFileNames(String query) {
    filteredCsvFileNames = csvFileNames
        .where(
            (fileName) => fileName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<List<dynamic>>> uploadCSVToServerHelper(
      List<List<dynamic>> csvData) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;

        if (result.files.single.bytes != null) {
          List<int> fileBytes = result.files.single.bytes!;
          String fileName = result.files.single.name;
          final csvString = String.fromCharCodes(fileBytes);
          List<List<dynamic>> decodedData =
              const CsvToListConverter().convert(csvString);

          try {
            Reference storageReference = FirebaseStorage.instance
                .ref()
                .child('TimeSeriesData/$fileName');
            await storageReference.putData(Uint8List.fromList(fileBytes));

            String fileUrl = await storageReference.getDownloadURL();

            CollectionReference filesCollection =
                FirebaseFirestore.instance.collection('csvFiles');
            await filesCollection.add({
              'fileName': fileName,
              'fileUrl': fileUrl,
              'fileData': Uint8List.fromList(fileBytes),
            });
          } catch (e) {
            print('Error uploading file to Firebase: $e');
          }
          return decodedData;
        }
      }
    } catch (e) {
      print("Error picking or uploading CSV file: $e");
    }
    return [];
  }

  Future<List<String>?> loadCsvAndExtractColumns(String fileName) async {
    try {
      List<Map<String, dynamic>> csvData = await getAllCSVData();
      String? fileUrl;

      for (var data in csvData) {
        if (data['fileName'] == fileName) {
          fileUrl = data['fileUrl'];
          break;
        }
      }

      if (fileUrl != null) {
        // Debug log to verify file URL
        print('File URL: $fileUrl');

        List<List<dynamic>> csvContent = await fetchCSVData(fileUrl);

        if (csvContent.isNotEmpty && csvContent.first.isNotEmpty) {
          List<String> extractedColumns =
              csvContent.first.map((value) => value.toString()).toList();
          bool isColumnNames =
              extractedColumns.every((column) => column is String);

          if (isColumnNames) {
            return extractedColumns;
          } else {
            print('Error: The first row does not contain valid column names.');
          }
        } else {
          print('Error: CSV content is empty or the first row is empty.');
        }
      } else {
        throw Exception('File URL not found for the selected file name.');
      }
    } catch (e) {
      print('Error loading and extracting columns: $e');
    }
    return null;
  }

  Future<void> postToFlaskServer({
    required String fileName,
    required String selectedMonthColumn,
    required String selectedSalesColumn,
    required String selectedSeasonality,
    required void Function(Map<String, dynamic>) onSuccess,
    required void Function(String) onError,
  }) async {
    try {
      String? fileUrl = await getFileUrlByName(fileName);
      if (fileUrl == null) {
        onError('File URL not found for the selected file name.');
        return;
      }

      Uint8List? fileBytes = await fetchFileData(fileUrl);
      if (fileBytes == null) {
        onError('Failed to fetch file data from Firebase Storage.');
        return;
      }

      var request = http.MultipartRequest('POST', Uri.parse(_apiUrl.csvUpload));
      request.files.add(
          http.MultipartFile.fromBytes('file', fileBytes, filename: fileName));
      request.fields['time_column'] = selectedMonthColumn;
      request.fields['sales_column'] = selectedSalesColumn;
      request.fields['seasonality'] = selectedSeasonality;

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = await Future.delayed(
          Duration(seconds: 1),
          () => responseData.body.isNotEmpty
              ? json.decode(responseData.body)
              : {},
        );

        onSuccess(responseJson);
      } else {
        String errorResponse =
            'Failed to upload CSV file to Flask server: ${responseData.body}';
        onError(errorResponse);
      }
    } catch (e) {
      String errorResponse = 'Error picking or uploading CSV file: $e';
      onError(errorResponse);
    }
  }

  Future<String?> getFileUrlByName(String fileName) async {
    List<Map<String, dynamic>> csvData = await getAllCSVData();
    for (var data in csvData) {
      if (data['fileName'] == fileName) {
        final fileUrl = data['fileUrl'];
        if (fileUrl != null &&
            (fileUrl.startsWith('gs://') || fileUrl.startsWith('https://'))) {
          // Debug log to verify URL
          print('Found file URL: $fileUrl');
          return fileUrl;
        } else {
          // Log invalid URL
          print('Invalid file URL: $fileUrl');
        }
      }
    }
    return null;
  }

  Future<Uint8List?> fetchFileData(String fileUrl) async {
    try {
      final Reference ref = storage.refFromURL(fileUrl);
      final String downloadUrl = await ref.getDownloadURL();

      final http.Response response = await http.get(Uri.parse(downloadUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print(
            'Failed to load CSV file with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching CSV data: $e');
      return null;
    }
  }
}

// Future<List<List<dynamic>>> loadCSVHelper2(
//     List<List<dynamic>> csvData) async {
//   try {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['csv'],
//     );
//
//     if (result != null) {
//       PlatformFile file = result.files.first;
//
//       print(file.name);
//       print(file.size);
//       print(file.extension);
//
//       if (result.files.single.bytes != null) {
//         List<int> fileBytes = result.files.single.bytes!;
//         String fileName = result.files.single.name;
//         final csvString = String.fromCharCodes(fileBytes);
//         List<List<dynamic>> decodedData =
//             const CsvToListConverter().convert(csvString);
//
//         try {
//           print('Uploading file to Flask...');
//           var request = http.MultipartRequest(
//             'POST',
//             Uri.parse(_apiUrl.csvUpload),
//           );
//           request.files.add(
//             http.MultipartFile.fromBytes(
//               'file',
//               fileBytes,
//               filename: fileName,
//             ),
//           );
//           var response = await request.send();
//           var responseData = await http.Response.fromStream(response);
//
//           if (response.statusCode == 200) {
//             print('CSV file uploaded successfully to Flask server');
//
//             try {
//               print('Uploading file to Firebase Cloud Storage...');
//               Reference storageReference = FirebaseStorage.instance
//                   .ref()
//                   .child('TimeSeriesData/$fileName');
//
//               await storageReference.putData(Uint8List.fromList(fileBytes));
//
//               String fileUrl = await storageReference.getDownloadURL();
//
//               CollectionReference filesCollection =
//                   FirebaseFirestore.instance.collection('csvFiles');
//               await filesCollection.add({
//                 'fileName': fileName,
//                 'fileUrl': fileUrl,
//                 'fileData': Uint8List.fromList(fileBytes),
//               });
//
//               print(
//                   'File uploaded to Firebase Cloud Storage and reference saved to Realtime Database');
//             } catch (e) {
//               print('Error uploading file to Firebase: $e');
//             }
//           } else {
//             print(
//                 'Failed to upload CSV file to Flask server: ${responseData.body}');
//           }
//         } catch (e) {
//           print('Error uploading file to Flask: $e');
//         }
//         return decodedData;
//       }
//     }
//   } catch (e) {
//     print("Error picking or uploading CSV file: $e");
//   }
//   return [];
// }

// -------------------------------------------------------------------------------------------

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

//---------------------- LOAD CSV TO FLASK, FIREBASE COLLECTION & STORAGE
// Future<List<List<dynamic>>> loadCSVHelper2(List<List<dynamic>> csvData) async {
//   try {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['csv'],
//     );
//
//     if (result != null) {
//       PlatformFile file = result.files.first;
//
//       if (result.files.single.bytes != null) {
//         List<int> fileBytes = result.files.single.bytes!;
//         String fileName = result.files.single.name;
//         final csvString = String.fromCharCodes(fileBytes);
//         List<List<dynamic>> decodedData =
//         const CsvToListConverter().convert(csvString);
//
//         try {
//           print('Uploading file to Flask...');
//           var request = http.MultipartRequest(
//             'POST',
//             Uri.parse(_apiUrl.csvUpload),
//           );
//           request.files.add(
//             http.MultipartFile.fromBytes(
//               'file',
//               fileBytes,
//               filename: fileName,
//             ),
//           );
//           request.fields['sales_column'] =
//           'sales'; // Adjust field names as required
//           request.fields['time_column'] = 'time';
//           request.fields['seasonality'] = 'Monthly'; // Adjust as needed
//
//           var response = await request.send();
//           var responseData = await http.Response.fromStream(response);
//
//           if (response.statusCode == 200) {
//             print('CSV file uploaded successfully to Flask server');
//
//             try {
//               print('Uploading file to Firebase Cloud Storage...');
//               Reference storageReference = FirebaseStorage.instance
//                   .ref()
//                   .child('TimeSeriesData/$fileName');
//
//               await storageReference.putData(Uint8List.fromList(fileBytes));
//
//               String fileUrl = await storageReference.getDownloadURL();
//
//               CollectionReference filesCollection =
//               FirebaseFirestore.instance.collection('csvFiles');
//               await filesCollection.add({
//                 'fileName': fileName,
//                 'fileUrl': fileUrl,
//                 'fileData': Uint8List.fromList(fileBytes),
//               });
//
//               print(
//                   'File uploaded to Firebase Cloud Storage and reference saved to Realtime Database');
//             } catch (e) {
//               print('Error uploading file to Firebase: $e');
//             }
//           } else {
//             print(
//                 'Failed to upload CSV file to Flask server: ${responseData.body}');
//           }
//         } catch (e) {
//           print('Error uploading file to Flask: $e');
//         }
//         return decodedData;
//       }
//     }
//   } catch (e) {
//     print("Error picking or uploading CSV file: $e");
//   }
//   return [];
// }

//-------------------------------------------------------------------------

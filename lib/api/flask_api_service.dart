import 'dart:convert';

import 'package:http/http.dart' as http;

fetchData(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  print(response.body);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}

sendCSV(String url) async {
  http.Response response = await http.post(Uri.parse(url));
  print(response.body);
}

import 'package:alpha_forecast_app/api/flask_api_service.dart';
import 'package:flutter/material.dart';

class FlaskDemo extends StatefulWidget {
  const FlaskDemo({super.key});

  @override
  State<FlaskDemo> createState() => _FlaskDemoState();
}

class _FlaskDemoState extends State<FlaskDemo> {
  String url = 'http://127.0.0.1:5000/dm';
  var data;
  TextEditingController controllerA = TextEditingController();
  TextEditingController controllerB = TextEditingController();
  String output1 = '';
  String output2 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: controllerA,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'A'),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: controllerB,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'B'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 100),
            ElevatedButton(
                onPressed: () async {
                  final a = controllerA.text;
                  final b = controllerB.text;
                  final newUrl = '$url?a=$a&b=$b';
                  data = await fetchData(newUrl);
                  print(data);
                  setState(() {
                    output1 = data['addition'];
                    output2 = data['subtraction'];
                  });

                  print('$output1, $output2');
                },
                child: Text('Output')),
            Text(output1),
            Text(output2)
          ],
        ),
      ),
    );
  }
}

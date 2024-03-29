import 'dart:convert';

import 'package:alpha_forecast_app/custom/helper_widgets/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_speech/text_to_speech.dart';

import '../api/openai_api_service.dart';
import '../custom/custom_widgets/build_chart_widget.dart';
import '../custom/custom_widgets/display_chart_widget.dart';
import '../custom/custom_widgets/display_table.dart';

class ModelServiceScreen extends StatefulWidget {
  const ModelServiceScreen({super.key});

  @override
  State<ModelServiceScreen> createState() => _ModelServiceScreenState();
}

class _ModelServiceScreenState extends State<ModelServiceScreen> {
  List<Map<String, dynamic>> data = [];
  List<List<dynamic>> csvData = [];
  HelperFunctions helperFunctions = HelperFunctions();
  bool isLoaded = false;
  String fileName = '';
  int selectedService = -1;
  ChartType selectedChartType = ChartType.Bar;

  TextEditingController userInputTextEditingController =
      TextEditingController();
  final SpeechToText speechToTextInstance = SpeechToText();
  final TextToSpeech textToSpeechInstance = TextToSpeech();
  bool speakMOMO = true;
  String recordedAudioString = "";
  bool isLoading = false;
  String modeOpenAI = "chat";
  String imageUrlFromOpenAI = "";
  String answerTextFromOpenAI = "";
  String displayUserQuestion = " ";

  double rate = 2;

  double volume = 50;

  double pitch = 1;

  void initializeSpeechToText() async {
    await speechToTextInstance.initialize();

    setState(() {});
  }

  void startListeningNow() async {
    FocusScope.of(context).unfocus();

    await speechToTextInstance.listen(onResult: onSpeechToTextResult);

    setState(() {});
  }

  void stopListeningNow() async {
    await speechToTextInstance.stop();

    setState(() {});
  }

  void onSpeechToTextResult(SpeechRecognitionResult recognitionResult) {
    recordedAudioString = recognitionResult.recognizedWords;

    speechToTextInstance.isListening
        ? null
        : sendRequestToOpenAI(recordedAudioString);

    print("Speech Result:");
    print(recordedAudioString);
  }

  Future<void> sendRequestToOpenAI(String userInput) async {
    stopListeningNow();

    setState(() {
      isLoading = true;
    });

    //send the request to openAI using our APIService
    await APIService().requestOpenAI(userInput, modeOpenAI, 2000).then((value) {
      setState(() {
        isLoading = false;
      });

      if (value.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Api Key you are/were using expired or it is not working anymore.",
            ),
          ),
        );
      }

      userInputTextEditingController.clear();

      final responseAvailable = jsonDecode(value.body);

      if (modeOpenAI == "chat") {
        setState(() {
          answerTextFromOpenAI = utf8.decode(
              responseAvailable["choices"][0]["text"].toString().codeUnits);

          print(displayUserQuestion);
          print("ChatGPT Chat-bot: ");

          print(answerTextFromOpenAI);

          if (speakMOMO == true) {
            textToSpeechInstance.setVolume(volume);
            textToSpeechInstance.setRate(rate);
            textToSpeechInstance.setPitch(pitch);
            textToSpeechInstance.speak(answerTextFromOpenAI);
          }
        });
      } else {
        //image generation
        setState(() {
          imageUrlFromOpenAI = responseAvailable["data"][0]["url"];

          print("Generated Dale E Image Url: ");
          print(imageUrlFromOpenAI);
        });
      }
    }).catchError((errorMessage) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error: $errorMessage",
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    displayUserQuestion = userInputTextEditingController.text;
    initializeSpeechToText();
  }

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
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.indigo,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          textStyle: TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 4,
                          shadowColor: Colors.grey,
                          minimumSize: Size(100, 40),
                        ),
                        onPressed: () {},
                        child: const Text("Downloads")),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.indigo,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          textStyle: TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 4,
                          shadowColor: Colors.grey,
                          minimumSize: Size(100, 40),
                        ),
                        onPressed: () {},
                        child: const Text("Guidelines"))
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
                    color: Colors.indigo.shade100.withOpacity(0.8),
                    spreadRadius: 5,
                    blurRadius: 10,
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
              Container(
                  //
                  height: MediaQuery.of(context).size.height * 0.95,
                  width: MediaQuery.of(context).size.width * 0.72,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 2,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Visibility(
                        visible: selectedService == 1,
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
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
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
                                              helperFunctions
                                                  .getUploadedFiles();
                                            },
                                            icon: const Icon(Icons.list_alt),
                                            tooltip: "Load all CSV file",
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
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      Expanded(
                                        child: ListView.builder(
                                          // gridDelegate:
                                          //     const SliverGridDelegateWithFixedCrossAxisCount(
                                          //   crossAxisCount: 2,
                                          //   crossAxisSpacing: 8.0,
                                          //   mainAxisSpacing: 8.0,
                                          // ),
                                          itemCount: helperFunctions
                                              .uploadedFiles.length,
                                          itemBuilder: (context, index) {
                                            return ElevatedButton(
                                              onPressed: () {
                                                print(
                                                    'Button pressed for file: ${helperFunctions.uploadedFiles[index]}');
                                              },
                                              child: Expanded(
                                                child: Text(helperFunctions
                                                    .uploadedFiles[index]),
                                              ),
                                            );
                                          },
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
                                    "Unlock the potential of your time series data with AlphaCentauric's cutting-edge service. Before creating your ARIMA or SARIMA forecasting model, take the first step by uploading your training data. Our seamless data visualization technique provides a crystal-clear view of your data patterns, enabling you to make informed decisions and optimize your forecasting model. Dive into the world of precision forecasting—start by visualizing your data with AlphaCentauric."),
                                subtitleTextStyle: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: selectedService == 2,
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
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
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
                                                      .loadCSVHelper(csvData);
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
                                          child:
                                              DisplayTable(csvData: csvData))),
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
                                    "Unlock the potential of your time series data with AlphaCentauric's cutting-edge service. Before creating your ARIMA or SARIMA forecasting model, take the first step by uploading your training data. Our seamless data visualization technique provides a crystal-clear view of your data patterns, enabling you to make informed decisions and optimize your forecasting model. Dive into the world of precision forecasting—start by visualizing your data with AlphaCentauric."),
                                subtitleTextStyle: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
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
                                    height: MediaQuery.of(context).size.height *
                                        0.9,
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.653,
                                  height:
                                      MediaQuery.of(context).size.height * 0.9,
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
                                            items: ChartType.values
                                                .map((chartType) {
                                              return DropdownMenuItem<
                                                  ChartType>(
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
                    ],
                  )),
              const SizedBox(
                width: 10,
              ),
              Container(
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
                      Center(
                        child: InkWell(
                          onTap: () {
                            speechToTextInstance.isListening
                                ? stopListeningNow()
                                : startListeningNow();
                          },
                          child: speechToTextInstance.isListening
                              ? Center(
                                  child: LoadingAnimationWidget.fallingDot(
                                    size: 400,
                                    color: speechToTextInstance.isListening
                                        ? Colors.purple.shade700
                                        : isLoading
                                            ? Colors.deepPurple[400]!
                                            : Colors.deepPurple[200]!,
                                  ),
                                )
                              : Image.asset(
                                  "asset/ai (6).jpg",
                                  height: 400,
                                  width: MediaQuery.of(context).size.width,
                                ),
                        ),
                      ),
                      Row(
                        children: [
                          //text field
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: TextField(
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'codeFontFamily',
                                  color: Colors.white70,
                                  fontSize: 15),
                              controller: userInputTextEditingController,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0.3, color: Colors.cyan),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      width: 0.3, color: Colors.purple),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3, color: Colors.white),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: "\t how can i help you?",
                                hintTextDirection: TextDirection.ltr,
                                hintStyle:
                                    const TextStyle(color: Colors.white54),
                                filled: true,
                                fillColor: Colors.white12,
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          //button
                          InkWell(
                            onTap: () {
                              if (userInputTextEditingController
                                  .text.isNotEmpty) {
                                sendRequestToOpenAI(
                                    userInputTextEditingController.text
                                        .toString());
                              }
                            },
                            child: AnimatedContainer(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.indigo.shade900),
                              duration: const Duration(
                                milliseconds: 1000,
                              ),
                              curve: Curves.bounceInOut,
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
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
            ],
          ),
          const SizedBox(
            height: 20,
          ),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                            color: Colors.indigo.shade900.withOpacity(0.3),
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
                              icon: const Icon(Icons.model_training_outlined),
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
                              icon: const Icon(Icons.account_tree_outlined),
                              tooltip: "Tuning parameters",
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.auto_graph_outlined),
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
                            height: MediaQuery.of(context).size.height * 0.7,
                            width: MediaQuery.of(context).size.width * 0.2,
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
                                    title: const Text("PREDICTIVE MODELS "),
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
                          Container(
                            //
                            height: MediaQuery.of(context).size.height * 0.7,
                            width: MediaQuery.of(context).size.width * 0.624,
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
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text("New Model",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)),
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
                                              fontWeight: FontWeight.bold),
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
                                          decoration: const InputDecoration(
                                            labelText: 'name your model',
                                            labelStyle: TextStyle(fontSize: 12),
                                            border: OutlineInputBorder(),
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
                                          title: Text(
                                              'Select your training dataset'),
                                          titleTextStyle: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          subtitle: Text(
                                              'Choose a table that has your training data in it.'),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      SizedBox(
                                        width: 500,
                                        height: 40,
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'select your dataset',
                                            labelStyle: TextStyle(fontSize: 12),
                                            border: OutlineInputBorder(),
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
                                          title: Text('Column to Predict'),
                                          titleTextStyle: TextStyle(
                                              fontWeight: FontWeight.bold),
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
                                          decoration: const InputDecoration(
                                            labelText:
                                                'select a column to predict',
                                            labelStyle: TextStyle(fontSize: 12),
                                            border: OutlineInputBorder(),
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
                                              fontWeight: FontWeight.bold),
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
                                          decoration: const InputDecoration(
                                            labelText: 'select any category',
                                            labelStyle: TextStyle(fontSize: 12),
                                            border: OutlineInputBorder(),
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
          const SizedBox(
            height: 25,
          ),
          Container(
            //
            height: MediaQuery.of(context).size.height * 0.93,
            width: MediaQuery.of(context).size.width * 0.93,
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
            child: const Center(),
          ),
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

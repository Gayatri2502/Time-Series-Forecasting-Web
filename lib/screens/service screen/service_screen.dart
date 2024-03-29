import 'package:alpha_forecast_app/screens/service%20screen/service_list_widget.dart';
import 'package:flutter/material.dart';

import '../../custom/custom_widgets/app_bar_widget.dart';


class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: desktopAppBarOpen(context, true),
      body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(150, 20, 150, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('All Services',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ServiceListWidget()),
            ],
          )),
    );
  }
}

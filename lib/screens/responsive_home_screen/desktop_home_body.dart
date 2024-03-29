import 'package:flutter/material.dart';

import '../../custom/custom_widgets/app_bar_widget.dart';
import '../../custom/custom_widgets/feature_widget.dart';
import '../../custom/custom_widgets/happy_customer_widgets.dart';
import '../../custom/custom_widgets/intro_widget.dart';
import '../../custom/custom_widgets/services_widget.dart';
import '../../custom/custom_widgets/team_widget.dart';

class DesktopHomePage extends StatefulWidget {
  const DesktopHomePage({super.key});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: desktopAppBarOpen(context, true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(150, 20, 150, 100),
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50.0),
              const IntroWidget(),
              const SizedBox(height: 24.0),
              ServicesWidget(),
              const SizedBox(height: 24.0),
              const FeatureWidget(),
              TeamWidget(),
              const HappyCustomerWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

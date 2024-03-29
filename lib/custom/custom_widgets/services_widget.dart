import 'package:flutter/material.dart';

import 'designer_container_widget.dart';
// Assuming you have your custom theme provider class in a file named custom_theme_provider.dart

class ServicesWidget extends StatefulWidget {
  ServicesWidget({
    Key? key,
  }) : super(key: key);
  @override
  State<ServicesWidget> createState() => _ServicesWidgetState();
}

class _ServicesWidgetState extends State<ServicesWidget> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Our Services',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 15),
        BeautifiedContainer(
          height: 700,
          width: 0.005,
          color: Colors.indigo.shade50,
          child: Row(
            children: [
              const SizedBox(width: 40),
              _buildServiceContainer(
                imagePath: 'asset/2.jpg',
                title: 'ML-Models [Classification, Regression]',
                description:
                    'Our AI Marketing Tools provide businesses with advanced analytics, personalized messaging, and automated campaigns for effective marketing strategies.',
                buttonText: 'Read More',
                isDarkMode: isDarkMode,
              ),
              const SizedBox(width: 50),
              _buildServiceContainer(
                imagePath: 'asset/3.jpg',
                title:
                    'Time Series Forecasting Strategy for Predictive Analytics',
                description:
                    'Our Predictive Analytics service utilizes advanced algorithms to analyze historical data and forecast future trends, enabling informed decision-making for businesses',
                buttonText: 'Read More',
                isDarkMode: isDarkMode,
              ),
              const SizedBox(width: 50),
              _buildServiceContainer(
                imagePath: 'asset/1.jpg',
                title: 'AI-Powered Marketing Strategy Tools & Analytics',
                description:
                    'Our Workflow Automation service streamlines and automates repetitive tasks, improving efficiency and productivity in your business operations.',
                buttonText: 'Read More',
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceContainer({
    required String imagePath,
    required String title,
    required String description,
    required String buttonText,
    required bool isDarkMode,
  }) {
    return Container(
      height: 600,
      width: 350,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.blueGrey[900] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 3), // changes the shadow position
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            scale: 1.4,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {},
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: isDarkMode
                      ? Colors.indigo.shade100
                      : Colors.indigo.shade900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

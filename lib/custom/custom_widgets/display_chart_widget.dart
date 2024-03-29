import 'package:flutter/material.dart';

import 'build_chart_widget.dart';

class DisplayChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final bool _isDarkMode;

  DisplayChartWidget({Key? key, required this.data, required bool isDarkMode})
      : _isDarkMode = isDarkMode,
        super(key: key);

  final BuildChartWidget buildChartWidget = BuildChartWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        if (data.isNotEmpty)
          SizedBox(
            height: 500,
            width: 700,
            child: Container(
              padding: const EdgeInsets.all(45),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: _isDarkMode
                        ? Colors.grey.withOpacity(0.5)
                        : Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
                color: _isDarkMode ? Colors.grey[900] : Colors.white,
                border: Border.all(
                  color: _isDarkMode ? Colors.blue : Colors.transparent,
                ),
              ),
              child: Expanded(child: buildChartWidget.buildChart(data)),
            ),
          ),
      ],
    );
  }
}

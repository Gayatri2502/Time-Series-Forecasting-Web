import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../custom/helper_widgets/helper_functions.dart';

class ChartBuilder extends StatelessWidget {
  final String fileName;
  final String xAxisColumn;
  final String yAxisColumn;
  final String chartType;
  final String timePeriod;
  final String graphTitle;
  final String xAxisLabel;
  final String yAxisLabel;

  ChartBuilder({
    required this.fileName,
    required this.xAxisColumn,
    required this.yAxisColumn,
    required this.chartType,
    required this.timePeriod,
    required this.graphTitle,
    required this.xAxisLabel,
    required this.yAxisLabel,
  });

  Future<String?> _getFileUrlByName(String fileName) async {
    return await HelperFunctions().getFileUrlByName(fileName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chart',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo.shade900,
      ),
      body: Center(
        child: FutureBuilder<String?>(
          future: _getFileUrlByName(fileName),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('No data available'));
            }

            final fileUrl = snapshot.data!;
            return FutureBuilder<List<List<dynamic>>>(
              future: HelperFunctions().fetchCSVData(fileUrl),
              builder: (context, csvSnapshot) {
                if (csvSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (csvSnapshot.hasError) {
                  return Center(child: Text('Error: ${csvSnapshot.error}'));
                } else if (!csvSnapshot.hasData || csvSnapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                }

                final csvData = csvSnapshot.data!;
                final xIndex = csvData[0].indexOf(xAxisColumn);
                final yIndex = csvData[0].indexOf(yAxisColumn);

                final chartData = _aggregateData(
                  csvData.skip(1).map((row) {
                    return ChartData(
                      xValue: _parseDate(row[xIndex].toString()),
                      yValue: num.tryParse(row[yIndex].toString()) ?? 0,
                    );
                  }).toList(),
                );

                return SfCartesianChart(
                  backgroundColor: Colors.black,
                  primaryXAxis: timePeriod == 'Normal'
                      ? DateTimeAxis(
                          dateFormat: DateFormat.yMd(),
                          title: AxisTitle(
                            text: xAxisLabel,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : CategoryAxis(
                          title: AxisTitle(
                            text: xAxisLabel,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(
                      text: yAxisLabel,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: ChartTitle(
                    text: graphTitle,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  legend: Legend(
                    isVisible: true,
                    textStyle: TextStyle(color: Colors.white),
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: _getChartSeries(chartData),
                  enableAxisAnimation: true,
                );
              },
            );
          },
        ),
      ),
    );
  }

  DateTime _parseDate(String dateString) {
    // Parsing various date formats
    List<String> dateFormats = [
      "yyyy-MM-dd",
      "MM/dd/yyyy",
      "dd/MM/yyyy",
      "dd-MMM-yyyy",
      "MMM dd, yyyy",
      "yyyy/MM/dd",
      "MM-yyyy", // For month-year combination
      "yyyy" // For year only
    ];
    for (String format in dateFormats) {
      try {
        return DateFormat(format).parse(dateString);
      } catch (_) {}
    }
    // If parsing fails, return current date
    return DateTime.now();
  }

  List<ChartData> _aggregateData(List<ChartData> data) {
    if (timePeriod == 'Month') {
      return _aggregateByMonth(data);
    } else if (timePeriod == 'Year') {
      return _aggregateByYear(data);
    } else {
      return data;
    }
  }

  List<ChartData> _aggregateByMonth(List<ChartData> data) {
    Map<String, List<ChartData>> groupedData = {};
    data.forEach((element) {
      final month = DateFormat('MM-yyyy').format(element.xValue);
      groupedData.putIfAbsent(month, () => []).add(element);
    });
    return groupedData.entries.map((entry) {
      final avgYValue =
          entry.value.map((e) => e.yValue).reduce((a, b) => a + b) /
              entry.value.length;
      return ChartData(
        xValue: DateFormat('MM-yyyy').parse(entry.key),
        yValue: avgYValue,
        label: entry.key,
      );
    }).toList();
  }

  List<ChartData> _aggregateByYear(List<ChartData> data) {
    Map<int, List<ChartData>> groupedData = {};
    data.forEach((element) {
      final year = element.xValue.year;
      groupedData.putIfAbsent(year, () => []).add(element);
    });
    return groupedData.entries.map((entry) {
      final avgYValue =
          entry.value.map((e) => e.yValue).reduce((a, b) => a + b) /
              entry.value.length;
      return ChartData(
        xValue: DateTime(entry.key, 1, 1),
        yValue: avgYValue,
        label: entry.key.toString(),
      );
    }).toList();
  }

  List<ChartSeries<ChartData, dynamic>> _getChartSeries(List<ChartData> data) {
    switch (chartType) {
      case 'Line Chart':
        return [
          LineSeries<ChartData, dynamic>(
            dataSource: data,
            xValueMapper: (ChartData data, _) =>
                timePeriod == 'Normal' ? data.xValue : data.label,
            yValueMapper: (ChartData data, _) => data.yValue,
            dataLabelSettings: DataLabelSettings(
                isVisible: true, textStyle: TextStyle(color: Colors.white)),
            enableTooltip: true,
          ),
        ];
      case 'Bar Chart':
        return [
          BarSeries<ChartData, dynamic>(
            dataSource: data,
            xValueMapper: (ChartData data, _) =>
                timePeriod == 'Normal' ? data.xValue : data.label,
            yValueMapper: (ChartData data, _) => data.yValue,
            dataLabelSettings: DataLabelSettings(
                isVisible: true, textStyle: TextStyle(color: Colors.white)),
            enableTooltip: true,
          ),
        ];
      case 'Column Chart':
        return [
          ColumnSeries<ChartData, dynamic>(
            dataSource: data,
            xValueMapper: (ChartData data, _) =>
                timePeriod == 'Normal' ? data.xValue : data.label,
            yValueMapper: (ChartData data, _) => data.yValue,
            dataLabelSettings: DataLabelSettings(
                isVisible: true, textStyle: TextStyle(color: Colors.white)),
            enableTooltip: true,
          ),
        ];
      case 'Scatter Chart':
        return [
          ScatterSeries<ChartData, dynamic>(
            dataSource: data,
            xValueMapper: (ChartData data, _) =>
                timePeriod == 'Normal' ? data.xValue : data.label,
            yValueMapper: (ChartData data, _) => data.yValue,
            dataLabelSettings: DataLabelSettings(
                isVisible: true, textStyle: TextStyle(color: Colors.white)),
            enableTooltip: true,
          ),
        ];
      case 'Area Chart':
        return [
          AreaSeries<ChartData, dynamic>(
            dataSource: data,
            xValueMapper: (ChartData data, _) =>
                timePeriod == 'Normal' ? data.xValue : data.label,
            yValueMapper: (ChartData data, _) => data.yValue,
            dataLabelSettings: DataLabelSettings(
                isVisible: true, textStyle: TextStyle(color: Colors.white)),
            enableTooltip: true,
          ),
        ];
      default:
        return [];
    }
  }
}

class ChartData {
  final DateTime xValue;
  final num yValue;
  final String? label;

  ChartData({required this.xValue, required this.yValue, this.label});
}

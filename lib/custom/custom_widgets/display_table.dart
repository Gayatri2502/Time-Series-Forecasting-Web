import 'package:flutter/material.dart';

class DisplayTable extends StatelessWidget {
  final List<List<dynamic>> csvData;
  final bool isDarkMode;

  DisplayTable({
    Key? key,
    required this.csvData,
    this.isDarkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = isDarkMode ? Colors.black87 : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (csvData.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Expanded(
                child: DataTable(
                  showBottomBorder: true,
                  border: TableBorder(),
                  headingRowColor: MaterialStateProperty.all(backgroundColor),
                  headingTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  columns: _buildTableHeaders(),
                  rows: _buildTableRows(),
                ),
              ),
            ),
          ),
      ],
    );
  }

  List<DataColumn> _buildTableHeaders() {
    return csvData[0]
        .map((header) => DataColumn(label: Text("$header")))
        .toList();
  }

  List<DataRow> _buildTableRows() {
    final dataRows = <DataRow>[];
    for (var i = 1; i < csvData.length; i++) {
      final row = csvData[i];
      final cells = row.map((cell) => DataCell(Text('$cell'))).toList();
      dataRows.add(DataRow(cells: cells));
    }
    return dataRows;
  }
}

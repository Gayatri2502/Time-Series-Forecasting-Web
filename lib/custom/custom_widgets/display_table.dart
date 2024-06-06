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
              child: DataTable(
                showBottomBorder: true,
                dividerThickness: 1.5,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                headingRowColor: MaterialStateProperty.all(backgroundColor),
                headingTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                dataRowColor: MaterialStateProperty.all(backgroundColor),
                dataTextStyle: TextStyle(
                  color: textColor,
                ),
                columns: _buildTableHeaders(textColor),
                rows: _buildTableRows(textColor),
              ),
            ),
          ),
      ],
    );
  }

  List<DataColumn> _buildTableHeaders(Color textColor) {
    return csvData[0].map((header) {
      return DataColumn(
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "$header",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      );
    }).toList();
  }

  List<DataRow> _buildTableRows(Color textColor) {
    final dataRows = <DataRow>[];
    for (var i = 1; i < csvData.length; i++) {
      final row = csvData[i];
      final cells = row.map((cell) {
        return DataCell(
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              '$cell',
              style: TextStyle(
                color: textColor,
              ),
            ),
          ),
        );
      }).toList();
      dataRows.add(DataRow(cells: cells));
    }
    return dataRows;
  }
}

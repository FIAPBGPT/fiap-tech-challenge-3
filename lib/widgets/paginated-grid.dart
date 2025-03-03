import 'package:flutter/material.dart';

class DynamicDataTable extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final List<String> columnNames;
  final void Function(Map<String, dynamic>)? onEdit;
  final void Function(Map<String, dynamic>)? onView;
  final void Function(Map<String, dynamic>)? onDelete;

  const DynamicDataTable({
    super.key,
    required this.data,
    required this.columnNames,
    this.onEdit,
    this.onView,
    this.onDelete,
  });

  @override
  _DynamicDataTableState createState() => _DynamicDataTableState();
}

class _DynamicDataTableState extends State<DynamicDataTable> {
  late List<Map<String, dynamic>> _filteredData;
  String _searchQuery = "";
  final int _rowsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _filteredData = List.from(widget.data);
  }

  void _applyFilter(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredData = widget.data;
      } else {
        _filteredData = widget.data.where((row) {
          return row.values.any((value) =>
              value.toString().toLowerCase().contains(query.toLowerCase()));
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔍 Search Field
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: "Search",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: _applyFilter,
          ),
        ),

        // 📊 Paginated DataTable
        Expanded(
          child: SingleChildScrollView(
            child: PaginatedDataTable(
              header: Text("Data Table"),
              columns: [
                ...widget.columnNames
                    .map((col) => DataColumn(label: Text(col))),
                DataColumn(label: Text("Actions")),
              ],
              source: _DynamicDataSource(
                _filteredData,
                widget.columnNames,
                widget.onEdit,
                widget.onView,
                widget.onDelete,
              ),
              rowsPerPage: _rowsPerPage,
            ),
          ),
        ),
      ],
    );
  }
}

// 📌 Data Source for Dynamic Table
class _DynamicDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  final List<String> columnNames;
  final void Function(Map<String, dynamic>)? onEdit;
  final void Function(Map<String, dynamic>)? onView;
  final void Function(Map<String, dynamic>)? onDelete;

  _DynamicDataSource(
      this.data, this.columnNames, this.onEdit, this.onView, this.onDelete);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final row = data[index];

    return DataRow(cells: [
      ...columnNames.map((col) => DataCell(Text(row[col].toString()))),
      DataCell(Row(
        children: [
          if (onEdit != null)
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () => onEdit!(row),
            ),
          if (onView != null)
            IconButton(
              icon: Icon(Icons.visibility, color: Colors.green),
              onPressed: () => onView!(row),
            ),
          if (onDelete != null)
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => onDelete!(row),
            ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

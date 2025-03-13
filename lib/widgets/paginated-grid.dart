import 'package:bytebank/config/auth_service.dart';
import 'package:bytebank/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DynamicDataTable extends StatefulWidget {
  final void Function(Map<String, dynamic>)? onEdit;
  final void Function(Map<String, dynamic>)? onView;
  final void Function(Map<String, dynamic>)? onDelete;

  const DynamicDataTable({
    super.key,
    this.onEdit,
    this.onView,
    this.onDelete,
  });

  @override
  _DynamicDataTableState createState() => _DynamicDataTableState();
}

class _DynamicDataTableState extends State<DynamicDataTable> {
  late List<Map<String, dynamic>> _filteredData;
  late List<String> _columnNames;
  String _searchQuery = "";
  final int _rowsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _applyFilter(String query) {
    setState(() {
      _searchQuery = query;

      // If the query is empty, show all the fetched data
      if (query.isEmpty) {
        _filteredData =
            List.from(_filteredData); // Reset to original fetched data
      } else {
        // Filter the data based on the query
        _filteredData = _filteredData.where((row) {
          return row.values.any((value) =>
              value.toString().toLowerCase().contains(query.toLowerCase()));
        }).toList();
      }
    });
  }

  Future<void> _fetchData() async {
    AuthService authService = AuthService();

    // Retrieve the token and userId from SharedPreferences
    String? token = await authService.getToken();
    String? userId = await authService.getUserId();

    // Define the API endpoint based on the action
    String url = '${AppConstants.apiBaseUrl}/api/users/$userId/transactions';

    try {
      final dio = Dio();
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token', // Add token to headers
          },
        ),
      );
      print(response);
      // Check if the request was successful
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> fetchedData =
            List<Map<String, dynamic>>.from(response.data['result']);

        // Extract column names from the first item in the fetched data (using keys)
        final List<String> columnNames =
            fetchedData.isNotEmpty ? fetchedData[0].keys.toList() : [];

        setState(() {
          _filteredData = fetchedData;
          _columnNames = columnNames;
        });
      } else {
        // Handle the case where the API response is not successful
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching transactions: $e");
    }
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
                ..._columnNames.map((col) => DataColumn(label: Text(col))),
                DataColumn(label: Text("Actions")),
              ],
              source: _DynamicDataSource(
                _filteredData,
                _columnNames,
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

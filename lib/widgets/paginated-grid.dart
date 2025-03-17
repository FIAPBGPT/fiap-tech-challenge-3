import 'package:bytebank/config/auth_service.dart';
import 'package:bytebank/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class DynamicDataTable extends StatefulWidget {
  final void Function(Map<String, dynamic>)? onEdit;
  final void Function(Map<String, dynamic>)? onView;
  final void Function(Map<String, dynamic>)? onDelete;
  final ValueNotifier<bool>? reloadNotifier;

  const DynamicDataTable({
    super.key,
    this.onEdit,
    this.onView,
    this.onDelete,
    this.reloadNotifier,
  });

  @override
  _DynamicDataTableState createState() => _DynamicDataTableState();
}

class _DynamicDataTableState extends State<DynamicDataTable> {
  late List<Map<String, dynamic>> _filteredData;
  late List<String> _columnNames;
  String _searchQuery = "";
  final int _rowsPerPage = 5;
  bool _hasData = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
    widget.reloadNotifier?.addListener(_onReload);
  }

  @override
  void dispose() {
    widget.reloadNotifier
        ?.removeListener(_onReload); // Remove listener when disposed
    super.dispose();
  }

  // Called when the reloadNotifier is triggered
  void _onReload() {
    _fetchData();
  }

  void _applyFilter(String query) {
    setState(() {
      _searchQuery = query;

      // If the query is empty, show all the fetched data
      if (query.isEmpty) {
        _filteredData =
            List.from(_filteredData); // Reset to original fetched data
        _fetchData();
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
    setState(() {
      _isLoading = true;
    });
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

        fetchedData.length == 0 ? _hasData = false : _hasData = true;

        print(fetchedData);
        print(columnNames);

        setState(() {
          _filteredData = fetchedData;
          _columnNames = columnNames;
          _isLoading = false;
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
        if (_isLoading) CircularProgressIndicator(),
        if (!_isLoading)
          if (_hasData) ...[
            // 🔍 Search Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Pesquisar",
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
                  header: Text("Transações"),
                  columns: [
                    DataColumn(label: Text("Ações")),
                    DataColumn(label: Text("Valor")),
                    DataColumn(label: Text("Tipo de Transação")),
                    DataColumn(label: Text("Data")),
                  ],
                  source: _DynamicDataSource(
                    _filteredData,
                    widget.onEdit,
                    widget.onView,
                    widget.onDelete,
                  ),
                  rowsPerPage: _rowsPerPage,
                ),
              ),
            ),
          ] else ...[
            // Show a message when there are no transactions to display
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                    "Nenhuma transação encontrada. Realize transações, para que elas apareçam aqui."),
              ),
            ),
          ]
      ],
    );
  }
}

// 📌 Data Source for Dynamic Table
class _DynamicDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  final void Function(Map<String, dynamic>)? onEdit;
  final void Function(Map<String, dynamic>)? onView;
  final void Function(Map<String, dynamic>)? onDelete;

  _DynamicDataSource(this.data, this.onEdit, this.onView, this.onDelete);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final row = data[index];

    // Format the date
    DateTime date = DateTime.parse(row['date']);
    String formattedDate = DateFormat('dd/MM/yyyy - HH:mm').format(date);

    // Format the amount based on transaction type
    String amountFormatted = row['amount'].toString();
    if (row['transactionType'] != 'deposito') {
      amountFormatted =
          '-$amountFormatted'; // Add minus sign for non-'deposito' transactions
    }

    return DataRow(cells: [
      // Display formatted amount, transactionType, and date
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
      DataCell(Text(amountFormatted)),
      DataCell(Text(row['transactionType'])),
      DataCell(Text(formattedDate)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

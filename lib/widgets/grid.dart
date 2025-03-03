import 'package:flutter/material.dart';

class GridScreen extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const GridScreen({super.key, required this.data});

  @override
  _GridScreenState createState() => _GridScreenState();
}

class _GridScreenState extends State<GridScreen> {
  late List<Map<String, dynamic>> tableData;

  @override
  void initState() {
    super.initState();
    tableData = List.from(widget.data); // Initialize with passed data
  }

  void editRow(int id) {
    print("Edit row with ID: $id");
  }

  void viewRow(int id) {
    print("View row with ID: $id");
  }

  void deleteRow(int id) {
    setState(() {
      tableData.removeWhere((item) => item["id"] == id);
    });
    print("Deleted row with ID: $id");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        columns: [
          DataColumn(label: Text("Ações")),
          DataColumn(label: Text("ID")),
          DataColumn(label: Text("Name")),
          DataColumn(label: Text("Email")),
        ],
        rows: tableData.map((item) {
          return DataRow(cells: [
            DataCell(Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => editRow(item["id"]),
                ),
                IconButton(
                  icon: Icon(Icons.visibility, color: Colors.green),
                  onPressed: () => viewRow(item["id"]),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteRow(item["id"]),
                ),
              ],
            )),
            DataCell(Text(item["id"].toString())),
            DataCell(Text(item["name"])),
            DataCell(Text(item["email"])),
          ]);
        }).toList(),
      ),
    );
  }
}

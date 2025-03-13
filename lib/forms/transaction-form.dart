// import 'package:bytebank/utils/constants.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';

// class TransactionForm extends StatefulWidget {
//   final Function(String, double, DateTime) onSubmit;

//   const TransactionForm({Key? key, required this.onSubmit}) : super(key: key);

//   @override
//   _TransactionFormState createState() => _TransactionFormState();
// }

// class _TransactionFormState extends State<TransactionForm> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _amountController = TextEditingController();
//   DateTime? _selectedDate = DateTime.now();
//   String _selectedTransactionType = 'credito';
//   bool _isDatePickerEnabled = true;
//   bool _isSubmitting = false;

//   final Dio _dio = Dio(
//       BaseOptions(baseUrl: "https://yourapi.com")); // Replace with your API URL

//   final List<String> transactionTypes = [
//     'credito',
//     'deposito',
//     'debito',
//     'pix',
//     'ted',
//     'tef'
//   ];

//   Future<void> _pickDate(BuildContext context) async {
//     if (!_isDatePickerEnabled) return;

//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );

//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   Future<void> _submitForm() async {
//     if (!_formKey.currentState!.validate()) return;

//     final double amount = double.parse(_amountController.text);
//     final DateTime date = _selectedDate!;

//     final Map<String, dynamic> transactionData = {
//       "type": _selectedTransactionType,
//       "amount": amount,
//       "date": date.toIso8601String(), // Convert date to a standard format
//     };

//     setState(() {
//       _isSubmitting = true;
//     });

//     try {
//       Response response =
//           await _dio.post("/transactions", data: transactionData);
//       print("Transaction created: ${response.data}");

//       // Call parent onSubmit callback
//       widget.onSubmit(_selectedTransactionType, amount, date);

//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Transaction successfully created!"),
//         backgroundColor: Colors.green,
//       ));

//       // Clear form fields
//       _amountController.clear();
//       setState(() {
//         _selectedTransactionType = 'credito';
//         _selectedDate = DateTime.now();
//         _isDatePickerEnabled = true;
//       });
//     } catch (e) {
//       print("Error submitting transaction: $e");
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Failed to create transaction."),
//         backgroundColor: Colors.red,
//       ));
//     } finally {
//       setState(() {
//         _isSubmitting = false;
//       });
//     }
//   }

//   ableDisableDatePicker() {
//     // if (widget.pageOrigin == 'dashboard') {
//     //   setState(() {
//     //     _isDatePickerEnabled = true;
//     //   });
//     // } else {
//     //   setState(() {
//     //     _isDatePickerEnabled = false;
//     //     _selectedDate = DateTime.now();
//     //   });
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           DropdownButtonFormField<String>(
//             value: _selectedTransactionType,
//             items: transactionTypes.map((String type) {
//               return DropdownMenuItem<String>(
//                 value: type,
//                 child: Text(type.toUpperCase()),
//               );
//             }).toList(),
//             onChanged: (value) {
//               setState(() {
//                 _selectedTransactionType = value!;
//               });
//             },
//             decoration: InputDecoration(
//               labelText: "Tipo de Transação",
//               filled: true,
//               fillColor: AppConstants.fieldsBackround,
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(9),
//                 borderSide: BorderSide(
//                   color: AppConstants.fieldsBorders,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: AppConstants.link,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 16),
//           TextFormField(
//             controller: _amountController,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//               labelText: "Valor",
//               filled: true,
//               fillColor: AppConstants.fieldsBackround,
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(9),
//                 borderSide: BorderSide(
//                   color: AppConstants.fieldsBorders,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: AppConstants.link,
//                 ),
//               ),
//             ),
//             validator: (value) {
//               if (value == null || value.isEmpty)
//                 return "Por favor, informe um valor!";
//               if (double.tryParse(value) == null)
//                 return "Informe um número válido!";
//               return null;
//             },
//           ),
//           SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("Enable Date Picker"),
//               Switch(
//                 value: _isDatePickerEnabled,
//                 onChanged: (value) {
//                   setState(() {
//                     _isDatePickerEnabled = value;
//                     if (!value) {
//                       _selectedDate = DateTime.now();
//                     }
//                   });
//                 },
//               ),
//             ],
//           ),
//           TextField(
//             controller: TextEditingController(
//               text:
//                   "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
//             ),
//             readOnly: true,
//             decoration: InputDecoration(
//               labelText: "Transaction Date",
//               suffixIcon: _isDatePickerEnabled
//                   ? IconButton(
//                       icon: Icon(Icons.calendar_today),
//                       onPressed: () => _pickDate(context),
//                     )
//                   : null,
//               filled: true,
//               fillColor: AppConstants.fieldsBackround,
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(9),
//                 borderSide: BorderSide(
//                   color: AppConstants.fieldsBorders,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: AppConstants.link,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: _isSubmitting ? null : _submitForm,
//             child: _isSubmitting
//                 ? CircularProgressIndicator(color: Colors.white)
//                 : Text("Submit"),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:bytebank/config/auth_service.dart';
import 'package:bytebank/utils/constants.dart';
import 'package:bytebank/widgets/button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'dart:convert'; // For encoding the data to JSON
import 'package:http/http.dart' as http;

class TransactionForm extends StatefulWidget {
  final bool isPage1; // To differentiate between page 1 and page 2
  final String userId; // User ID for transaction (can be passed as a parameter)
  final String pageName; // Name of the page for the description
  final String
      formMode; // Mode to determine if it's for viewing or editing (e.g., 'view', 'edit', 'add', 'delete')
  final transaction;

  const TransactionForm({
    Key? key,
    required this.isPage1,
    required this.userId,
    required this.pageName,
    required this.formMode, // Pass form mode here
    this.transaction,
  }) : super(key: key);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _amountController = TextEditingController();
  String _description = ''; // Will be filled automatically
  String _date = ''; // Will be filled automatically
  String _transactionId =
      ''; // Will be filled automatically by the transaction object
  String? _transactionType; // Default value

  // List of transaction types with custom labels and internal values
  final List<Map<String, String>> transactionTypes = [
    {'value': 'credito', 'label': 'Crédito'},
    {'value': 'deposito', 'label': 'Depósito'},
    {'value': 'debito', 'label': 'Débito'},
    {'value': 'pix', 'label': 'PIX'},
    {'value': 'ted', 'label': 'TED'},
    {'value': 'tef', 'label': 'TEF'},
  ];

  @override
  void initState() {
    super.initState();
    _description = widget
        .pageName; // Description is automatically filled with the page name
    _date = DateFormat('yyyy-MM-dd')
        .format(DateTime.now()); // Current date for initial value

    // Fetch transaction data for 'edit', 'view', or 'delete'
    if (widget.formMode != 'add') {
      _fetchTransactionData();
    }
  }

  // Function to fetch transaction details for 'edit', 'view', or 'delete'
  Future<void> _fetchTransactionData() async {
    AuthService authService = AuthService();
    String? token = await authService.getToken();
    String? userId = await authService.getUserId();

    if (token == null || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Token or User ID is missing. Please log in again.')),
      );
      return;
    }

    // Get the transaction ID from the widget
    String transactionId = widget.transaction;

    final dio = Dio();
    final url =
        '${AppConstants.apiBaseUrl}/api/users/transactions/$transactionId';

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token', // Add token to headers
          },
        ),
      );

      if (response.statusCode == 200) {
        // Populate fields with transaction data
        var transaction = response.data;
        setState(() {
          _transactionId = transaction['id']; // Save the transaction ID
          _amountController.text =
              transaction['amount'].toString(); // Populate amount
          _transactionType =
              transaction['transactionType']; // Populate transaction type
          _description =
              transaction['description']; // Populate description (if needed)
          _date = transaction['date']; // Populate the date
        });
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load transaction details.')),
        );
      }
    } catch (error) {
      // Handle exception or network error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  // Function to submit the form and make the POST request
  Future<void> _submitForm() async {
    AuthService authService = AuthService();

    // Retrieve the token and userId from SharedPreferences
    String? token = await authService.getToken();
    String? userId = await authService.getUserId();

    if (token == null || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Token or User ID is missing. Please log in again.')),
      );
      return;
    }

    final transactionData = {
      'userId': userId, // Use the passed userId or retrieved userId
      'amount': int.parse(_amountController.text),
      'transactionType': _transactionType,
      'description': _description, // This is filled automatically
      'date': _date,
    };

    try {
      final dio = Dio(); // Initialize Dio instance

      // Define the API endpoint based on the action
      String url = '${AppConstants.apiBaseUrl}/api/users/transactions';

      // Prepare the Dio request
      Response response;
      if (widget.formMode == 'add') {
        // POST request for adding a transaction
        response = await dio.post(
          url,
          data: json.encode(transactionData),
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token', // Add token to headers
            },
          ),
        );
      } else if (widget.formMode == 'edit') {
        // PUT request for editing a transaction
        String transactionId =
            widget.transaction; // You will need to get this from the UI
        url = '$url/$transactionId'; // URL for editing a specific transaction
        response = await dio.put(
          url,
          data: json.encode(transactionData),
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token', // Add token to headers
            },
          ),
        );
      } else if (widget.formMode == 'delete') {
        // DELETE request for deleting a transaction
        String transactionId =
            "your_transaction_id"; // You will need to get this from the UI
        url = '$url/$transactionId'; // URL for deleting a specific transaction
        response = await dio.delete(
          url,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token', // Add token to headers
            },
          ),
        );
      } else {
        throw Exception('Invalid form mode');
      }

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Handle success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Transaction successfully ${widget.formMode}!')),
        );

        // Reset fields after successful submission
        _resetFields();
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to ${widget.formMode} the transaction.')),
        );
      }
    } catch (error) {
      // Handle exception or network error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  // Function to reset the form fields
  void _resetFields() {
    _amountController.clear();
    setState(() {
      _transactionType = 'credito'; // Reset to default value
      _description =
          widget.pageName; // Reset description based on the page name
      _date = DateFormat('yyyy-MM-dd')
          .format(DateTime.now()); // Reset to current date
    });
  }

  // Function to open the DatePicker dialog
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _date = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSubmitButtonVisible =
        widget.formMode != 'view'; // Only show the button if not in 'view' mode

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Transaction Type Dropdown (only for Page 1 and when the form is editable)
        if (widget.isPage1 && widget.formMode != 'view')
          DropdownButtonFormField<String>(
            value: _transactionType, // Initial value
            items: transactionTypes.map((item) {
              return DropdownMenuItem<String>(
                value:
                    item['value']!, // or you can use another value if necessary
                child: Text(item['label']!), // display the label from the map
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _transactionType = newValue!;
              });
            },
            decoration: InputDecoration(
              labelText: "Tipo de Transação",
              filled: true,
              fillColor: AppConstants.fieldsBackround,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: BorderSide(
                  color: AppConstants.fieldsBorders,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppConstants.link,
                ),
              ),
            ),
          ),
        SizedBox(height: 16),

        // Amount Text Field (Editable for Page 1, Read-only for Page 2)
        TextField(
          controller: _amountController,
          decoration: InputDecoration(
            labelText: 'Valor',
            filled: true,
            fillColor: AppConstants.fieldsBackround,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: BorderSide(
                color: AppConstants.fieldsBorders,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppConstants.link,
              ),
            ),
          ),
          keyboardType: TextInputType.number,
          readOnly: widget.formMode == 'view', // Disable input if in view mode
        ),
        SizedBox(height: 16),

        // Date Text Field (opens DatePicker)
        GestureDetector(
          onTap: () => widget.formMode != 'view' ? _selectDate(context) : null,
          child: AbsorbPointer(
            child: TextField(
              controller: TextEditingController(text: _date),
              decoration: InputDecoration(
                labelText: "Data da Transação",
                hintText: 'Selecione uma Data',
                filled: true,
                fillColor: AppConstants.fieldsBackround,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                  borderSide: BorderSide(
                    color: AppConstants.fieldsBorders,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppConstants.link,
                  ),
                ),
              ),
              readOnly:
                  true, // Make it read-only since the user picks the date via DatePicker
            ),
          ),
        ),
        SizedBox(height: 20),

        // Submit Button (Visible only if not in 'view' mode)
        if (isSubmitButtonVisible)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton(
                text: 'Concluir transação',
                onPressed: () => _submitForm(),
                type: ButtonType.elevated,
                color: AppConstants.baseBlueBytebank,
              ),
              SizedBox(height: 10),
            ],
          )
      ],
    );
  }
}

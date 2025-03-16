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
  final Function() doExtraAction;

  const TransactionForm({
    Key? key,
    required this.isPage1,
    required this.userId,
    required this.pageName,
    required this.formMode, // Pass form mode here
    this.transaction,
    required this.doExtraAction,
  }) : super(key: key);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _amountController = TextEditingController();
  final _transactionController = TextEditingController();
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
    if (widget.formMode != 'add' && widget.formMode != 'delete') {
      _fetchTransactionData();
    }
  }

  handleTransactionType(String value) {
    switch (value) {
      case 'credito':
        return _transactionController.text = 'Crédito';
      case 'deposito':
        return _transactionController.text = 'Depósito';
      case 'debito':
        return _transactionController.text = 'Débito';
      case 'pix':
        return _transactionController.text = 'PIX';
      case 'ted':
        return _transactionController.text = 'TED';
      case 'tef':
        return _transactionController.text = 'TEF';
      default:
        return _transactionController.text =
            ''; // Clear the field if invalid value is passed
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
    String transactionId = widget.transaction['_id'];

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
          _transactionId = transaction['_id']; // Save the transaction ID
          _amountController.text =
              transaction['amount'].toString(); // Populate amount
          _transactionController.text = handleTransactionType(
              transaction['transactionType']
                  .toString()); // Populate transaction type
          _transactionType = transaction['transactionType']
              .toString(); // Populate transaction type
          _description = transaction['description']; // Populate description
          _date = DateFormat('yyyy-MM-dd')
              .format(DateTime.parse(transaction['date']))
              .toString(); // Populate the date
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

    if (widget.formMode == 'delete') {
      // Proceed with deletion
      await _deleteTransaction(token);
    } else {
      // Handle other actions like add/edit
      double amount;
      try {
        amount = double.parse(
            _amountController.text); // Try parsing the amount as a double
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Invalid amount. Please enter a valid number.')),
        );
        return;
      }

      final transactionData = {
        'userId': userId, // Use the passed userId or retrieved userId
        'amount': amount, // Use the parsed double value for amount
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
          String transactionId = widget
              .transaction['_id']; // You will need to get this from the UI
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
        } else {
          throw Exception('Invalid form mode');
        }

        if (response.statusCode == 201 || response.statusCode == 200) {
          // Handle success
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Transaction successfully ${widget.formMode}!')),
          );

          widget
              .doExtraAction(); // Perform extra action after successful submission

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
  }

  // Function to delete a transaction
  Future<void> _deleteTransaction(String token) async {
    final dio = Dio();
    String transactionId = widget.transaction['_id']; // Get transaction ID

    try {
      final response = await dio.delete(
        '${AppConstants.apiBaseUrl}/api/users/transactions/$transactionId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transaction deleted successfully!')),
        );

        widget.doExtraAction(); // Trigger extra action after deletion

        // Reset fields after deletion
        _resetFields();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete the transaction.')),
        );
      }
    } catch (error) {
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
        // Show confirmation message and submit button if in 'delete' mode
        if (widget.formMode == 'delete')
          Column(
            children: [
              Text(
                'Tem certeza que deseja remover essa transação?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.fieldsBackround),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    text: 'Deletar',
                    onPressed: () => _submitForm(),
                    type: ButtonType.elevated,
                    color: AppConstants.baseGreenBytebank,
                  ),
                ],
              ),
            ],
          ),

        // Hide fields when in 'delete' mode
        if (widget.formMode != 'delete')
          Column(
            children: [
              // Transaction Type Dropdown (only for Page 1 and when the form is editable)
              if (widget.isPage1 && widget.formMode != 'view')
                DropdownButtonFormField<String>(
                  value: _transactionType,
                  items: transactionTypes.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['value']!,
                      child: Text(item['label']!),
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

              // Transaction Type Text Field
              if (widget.formMode == 'view')
                TextField(
                  controller: _transactionController,
                  decoration: InputDecoration(
                    labelText: 'Tipo de Transação',
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
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  readOnly: widget.formMode == 'view',
                ),
              SizedBox(height: 16),

              // Amount Text Field
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
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                readOnly: widget.formMode == 'view',
              ),
              SizedBox(height: 16),

              // Date Text Field (opens DatePicker)
              GestureDetector(
                onTap: () =>
                    widget.formMode != 'view' ? _selectDate(context) : null,
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
                    readOnly: true,
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
                ),
            ],
          ),
      ],
    );
  }
}

import 'package:bytebank/utils/constants.dart';
import 'package:bytebank/widgets/button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  final Function(String, double, DateTime) onSubmit;
  final String? pageOrigin;

  const TransactionForm({Key? key, required this.onSubmit, this.pageOrigin})
      : super(key: key);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  String _selectedTransactionType = 'credito';
  bool _isDatePickerEnabled = true;
  bool _isSubmitting = false;

  final Dio _dio = Dio(
      BaseOptions(baseUrl: "https://yourapi.com")); // Replace with your API URL

  final List<String> transactionTypes = [
    'credito',
    'deposito',
    'debito',
    'pix',
    'ted',
    'tef'
  ];

  Future<void> _pickDate(BuildContext context) async {
    if (!_isDatePickerEnabled) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final double amount = double.parse(_amountController.text);
    final DateTime date = _selectedDate!;

    final Map<String, dynamic> transactionData = {
      "type": _selectedTransactionType,
      "amount": amount,
      "date": date.toIso8601String(), // Convert date to a standard format
    };

    setState(() {
      _isSubmitting = true;
    });

    try {
      Response response =
          await _dio.post("/transactions", data: transactionData);
      print("Transaction created: ${response.data}");

      // Call parent onSubmit callback
      widget.onSubmit(_selectedTransactionType, amount, date);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Transaction successfully created!"),
        backgroundColor: Colors.green,
      ));

      // Clear form fields
      _amountController.clear();
      setState(() {
        _selectedTransactionType = 'credito';
        _selectedDate = DateTime.now();
        _isDatePickerEnabled = true;
      });
    } catch (e) {
      print("Error submitting transaction: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to create transaction."),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  ableDisableDatePicker() {
    if (widget.pageOrigin == 'dashboard') {
      setState(() {
        _isDatePickerEnabled = true;
      });
    } else {
      setState(() {
        _isDatePickerEnabled = false;
        _selectedDate = DateTime.now();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedTransactionType,
            items: transactionTypes.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type.toUpperCase()),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedTransactionType = value!;
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
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Valor",
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
            validator: (value) {
              if (value == null || value.isEmpty)
                return "Por favor, informe um valor!";
              if (double.tryParse(value) == null)
                return "Informe um número válido!";
              return null;
            },
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Enable Date Picker"),
              Switch(
                value: _isDatePickerEnabled,
                onChanged: (value) {
                  setState(() {
                    _isDatePickerEnabled = value;
                    if (!value) {
                      _selectedDate = DateTime.now();
                    }
                  });
                },
              ),
            ],
          ),
          TextField(
            controller: TextEditingController(
              text:
                  "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
            ),
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Transaction Date",
              suffixIcon: _isDatePickerEnabled
                  ? IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _pickDate(context),
                    )
                  : null,
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
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isSubmitting ? null : () => _submitForm(),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 80,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
              backgroundColor: AppConstants.baseBlueBytebank,
            ),
            child: _isSubmitting
                ? CircularProgressIndicator()
                : Text(
                    'Concluir transação',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppConstants.submitButtonText,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

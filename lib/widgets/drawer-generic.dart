import 'package:flutter/material.dart';

class DrawerContent extends StatelessWidget {
  final String transactionType;
  final Widget formWidget; // The form widget will be passed to this

  DrawerContent({
    required this.transactionType,
    required this.formWidget,
  });

  @override
  Widget build(BuildContext context) {
    switch (transactionType) {
      case 'add':
      case 'edit':
      case 'view':
        return formWidget; // Use the passed form widget for these types
      case 'delete':
        return _buildMessage(context);
      default:
        return _buildMessage(context);
    }
  }

  Widget _buildMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Icon(Icons.warning, size: 100, color: Colors.orange),
          SizedBox(height: 20),
          Text(
            'Are you sure you want to delete this item?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Handle the delete action
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Item deleted')));
            },
            child: Text('Confirm Deletion'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}

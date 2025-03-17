import 'package:bytebank/utils/constants.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsets padding;
  final double elevation;

  const TransactionCard({
    Key? key,
    this.title, // Optional title
    required this.child, // Required child widget
    this.padding = const EdgeInsets.all(16.0),
    this.elevation = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: AppConstants.baseDarkGreyBytebank,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) // Display title only if it's provided
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  title!,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.baseBlueBytebank,
                  ),
                ),
              ),
            child, // Render the passed widget inside the card
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

enum ButtonType { elevated, outlined, text, icon }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type; // Defines button type
  final Color? color; // Custom button color
  final IconData? icon; // Optional icon parameter
  final bool iconOnRight;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.elevated, // Default type is ElevatedButton
    this.color,
    this.icon, // Default is null (no icon)
    this.iconOnRight = false, // Default: Icon on the left
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonChild = icon != null
        ? text != ''
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: iconOnRight
                    ? [
                        Text(text, style: TextStyle(fontSize: 16)),
                        SizedBox(width: 8),
                        Icon(icon, size: 20)
                      ]
                    : [
                        Icon(icon, size: 20),
                        SizedBox(width: 8),
                        Text(text, style: TextStyle(fontSize: 16))
                      ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: iconOnRight
                    ? [Icon(icon, size: 25)]
                    : [Icon(icon, size: 25)])
        : Text(text, style: TextStyle(fontSize: 16));

    switch (type) {
      case ButtonType.elevated:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              // Rectangle shape
              borderRadius: BorderRadius.circular(
                  8), // No border radius for sharp corners
            ),
          ),
          child: buttonChild,
        );

      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: color ?? Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            side: BorderSide(color: color ?? Colors.blue), // Border color
            shape: RoundedRectangleBorder(
              // Rectangle shape
              borderRadius: BorderRadius.circular(
                  8), // No border radius for sharp corners
            ),
          ),
          child: buttonChild,
        );

      case ButtonType.text:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: color ?? Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
          child: buttonChild,
        );

      case ButtonType.icon:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            backgroundColor: color ?? Colors.blue,
            iconColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          ),
          child: buttonChild,
        );
    }
  }
}

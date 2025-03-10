import 'package:bytebank/utils/constants.dart';
import 'package:flutter/material.dart';

class HoverMenu extends StatefulWidget {
  final String label;
  final Function() onTap;

  const HoverMenu({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  _HoverMenuState createState() => _HoverMenuState();
}

class _HoverMenuState extends State<HoverMenu> {
  bool _isPressed = false;

  BorderSide _getBorderBottom() {
    if ("Outros serviços" == widget.label) {
      return BorderSide.none;
    }
    return BorderSide(color: AppConstants.baseBlackBytebank, width: 1);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: Center(
        child: AnimatedContainer(
          width: 165,
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
              color:
                  _isPressed ? const Color.fromARGB(255, 217, 228, 217) : null,
              border: Border(
                  bottom: _isPressed
                      ? BorderSide(
                          color: AppConstants.baseOrangeBytebank,
                          width: 1.0,
                        )
                      : _getBorderBottom())),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: AppConstants.menuTextStyle.copyWith(
                  color: _isPressed
                      ? AppConstants.baseOrangeBytebank
                      : AppConstants.menuTextStyle.color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class CreditCardWidget extends StatefulWidget {
  const CreditCardWidget({super.key});

  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isFront = true;
  String? name;
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: pi).animate(_controller);
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  String formatName(String? name) {
    if (name == null || name.trim().isEmpty)
      return ''; // Verifica se é nulo ou vazio
    return name
        .trim() // Remove espaços extras no início e no fim
        .split(RegExp(r'\s+')) // Divide considerando múltiplos espaços
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : '')
        .join(' '); // Junta as palavras formatadas
  }

  void _flipCard() {
    if (isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      isFront = !isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Meus cartões",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text("Cartão físico", style: TextStyle(fontSize: 16)),
        SizedBox(height: 20),
        GestureDetector(
          onTap: _flipCard,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final isFlipped = _animation.value >= pi / 2;
              final transform = Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(_animation.value);

              return Transform(
                alignment: Alignment.center,
                transform: transform,
                child: isFlipped
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..scale(-1.0, 1.0, 1.0), // Inverte horizontalmente
                        child: _buildBackCard(),
                      )
                    : _buildFrontCard(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFrontCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Byte",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  color: Colors.white)),
          SizedBox(height: 10),
          Text("Platinum", style: TextStyle(fontSize: 16, color: Colors.white)),
          Spacer(),
          Text(formatName(name),
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
      icon: Icons.sync,
    );
  }

  Widget _buildBackCard() {
    return _buildCard(
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text("6404 6258 XXXX XXX-X",
            style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
      icon: Icons.sync,
    );
  }

  Widget _buildCard({required Widget child, required IconData icon}) {
    return Container(
      width: 300,
      height: 180,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          child,
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(icon, color: Colors.white),
              onPressed: _flipCard,
            ),
          ),
        ],
      ),
    );
  }
}

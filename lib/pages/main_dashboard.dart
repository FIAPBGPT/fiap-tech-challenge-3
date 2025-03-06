import 'package:bytebank/widgets/menu/appbar.dart';
import 'package:flutter/material.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: AppBarComponent(),
      ),
    );
  }
}

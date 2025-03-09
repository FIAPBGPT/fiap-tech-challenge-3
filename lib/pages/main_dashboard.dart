import 'package:bytebank/pages/weather_screen.dart';
import 'package:bytebank/widgets/menu/drawer.dart';
import 'package:flutter/material.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "",
                  textAlign: TextAlign.center,
                ),
                const Icon(
                  Icons.account_circle_outlined,
                  size: 35,
                ),
              ],
            ),
          ),
        ),
        toolbarHeight: 60,
      ),
      drawer: DrawerComponent(),
      body: Column(
        children: [
          WeatherScreen(),
        ],
      ),
    );
  }
}

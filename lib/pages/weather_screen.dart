import 'package:bytebank/utils/constants_keys.dart';
import 'package:bytebank/widgets/weather-widget.dart';
import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: WeatherWidget(
        apiKey: ConstantsKeys.MY_APY_KEY,
      ),
    );
  }
}

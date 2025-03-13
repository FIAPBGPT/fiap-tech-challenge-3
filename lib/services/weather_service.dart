import 'package:weather/weather.dart';

class WeatherService {
  final String apiKey;
  late final WeatherFactory _weatherFactory;

  WeatherService(this.apiKey) {
    _weatherFactory = WeatherFactory(apiKey);
  }

  Future<Weather> getWeatherByLocation(
      double latitude, double longitude) async {
    try {
      return await _weatherFactory.currentWeatherByLocation(
          latitude, longitude);
    } catch (e) {
      throw Exception('Falha ao obter dados meteorológicos: $e');
    }
  }
}

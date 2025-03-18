import 'package:bytebank/services/location_service.dart';
import 'package:bytebank/services/weather_service.dart';
import 'package:bytebank/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

class WeatherWidget extends StatefulWidget {
  final String apiKey;

  const WeatherWidget({
    super.key,
    required this.apiKey,
  });

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  final LocationService _locationService = LocationService();
  late final WeatherService _weatherService;

  bool _isLoading = true;
  String _errorMessage = '';
  Weather? _currentWeather;

  @override
  void initState() {
    super.initState();
    _weatherService = WeatherService(widget.apiKey);
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final position = await _locationService.getCurrentLocation();

      final weather = await _weatherService.getWeatherByLocation(
          position.latitude, position.longitude);

      setState(() {
        _currentWeather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          height: 350,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    'lib/assets/images/noaa-ZVhm6rEKEX8-unsplash.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x974489FF),
                        Color.fromARGB(218, 152, 233, 225),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: _buildContentInfo(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentInfo() {
    if (_isLoading) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const CircularProgressIndicator(color: AppConstants.baseBlueBytebank),
          const SizedBox(height: 16),
          Text(
            'Obtendo informações meteorológicas...',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppConstants.baseBlueBytebank,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Erro ao obter dados meteorológicos:',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadWeatherData,
              child: const Text(
                'Tentar novamente',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    if (_currentWeather == null) {
      return Center(
        child: Text(
          'Nenhuma informação meteorológica disponível.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppConstants.baseBlueBytebank,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      // Wrapping the entire content in SingleChildScrollView to avoid overflow
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Wrap these in Expanded to prevent overflow
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentWeather!.areaName ?? 'Localização desconhecida',
                        textAlign: TextAlign.center,
                        style: AppConstants.weatherTitStyle.copyWith(
                          color: AppConstants.baseBlueBytebank,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _currentWeather!.country ?? '',
                        style: AppConstants.weatherSubtitStyle.copyWith(
                          color: AppConstants.baseBlueBytebank,
                        ),
                      ),
                    ],
                  ),
                ),
                // Wrap these in Expanded to prevent overflow
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${_currentWeather!.temperature?.celsius?.toStringAsFixed(1)}°C',
                        style: AppConstants.weatherTitStyle.copyWith(
                            color: AppConstants.baseBackgroundBytebank),
                      ),
                      Text(
                        _currentWeather!.weatherDescription ?? '',
                        style: AppConstants.weatherSubtitStyle.copyWith(
                            color: AppConstants.baseBackgroundBytebank),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(color: Color(0xFF4D4D4D), height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildWeatherInfo(
                  'Umidade',
                  '${_currentWeather!.humidity?.toStringAsFixed(0)}%',
                  Icons.water_drop_outlined,
                ),
                _buildWeatherInfo(
                  'Vento',
                  '${_currentWeather!.windSpeed?.toStringAsFixed(1)} km/h',
                  Icons.air,
                ),
                _buildWeatherInfo(
                  'Sensação',
                  '${_currentWeather!.tempFeelsLike?.celsius?.toStringAsFixed(1)}°C',
                  Icons.thermostat_outlined,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _loadWeatherData,
                icon: const Icon(Icons.refresh,
                    color: AppConstants.baseBlueBytebank, size: 20),
                label: Text(
                  'Atualizar',
                  style: AppConstants.weatherTextStyle.copyWith(
                    color: AppConstants.baseBlueBytebank,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 26,
          color: Color(0xFF4D4D4D),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF4D4D4D),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            color: AppConstants.baseBlueBytebank,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

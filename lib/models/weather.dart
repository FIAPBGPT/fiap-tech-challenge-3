class Weather {
  final String city;
  final String description;
  final double temperature;

  Weather(
      {required this.city,
      required this.description,
      required this.temperature});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'],
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'],
    );
  }
}

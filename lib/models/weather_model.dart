class WeatherModel {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final String subLocality;
  final String locality;
  final String country;

  // SET this using constructor
  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.subLocality,
    required this.locality,
    required this.country,
  });

  // Define the data that we get by doing api call

  factory WeatherModel.fromJson(
    Map<String, dynamic> json,
    String subLocality,
    String locality,
    String country,
  ) {
    return WeatherModel(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      subLocality: subLocality,
      locality: locality,
      country: country,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:minimal_weather/models/weather_model.dart';
import 'package:minimal_weather/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('c734a6a966cee1fdd092c183dad14349');
  WeatherModel? _weather;
  bool _isLoading = true;
  String? _error;

  Future<void> _fetchWeather() async {
    try {
      final cityCountrySet = await _weatherService.getCurrentCity();
      final cityCountryList = cityCountrySet.toList();

      final weather = await _weatherService.getWeather(
        cityCountryList[0].toString(), // sub locality
        cityCountryList[1].toString(), // locality
        cityCountryList[2].toString(), // sub administrative area
        cityCountryList[3].toString(), // Country code
        cityCountryList[4].toString(), // Country code
      );

      print("Weather: $weather");

      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // Weather animations:
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sun.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'haze':
        return 'assets/clouds.json';
      case 'smoke':
      case 'dust':
      case 'fog':
        return 'assets/fog.json';

      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';

      case 'thunderstrom':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sun.json';
      default:
        return 'assets/sun.json';
    }
  }

  // At initial state, we need to fetch the weather based on the location:
  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 233, 233),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text("Your weather data will arrive soon..."),
                  ],
                )
              : _error != null
              ? Text(_error!)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pin_drop_outlined, size: 32),
                    Text(
                      '${_weather?.locality}, ${_weather?.cityName}, ${_weather?.country}',
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                    Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                    Text('${_weather?.mainCondition}'),
                    Text(
                      '${_weather!.temperature.round()}° C',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

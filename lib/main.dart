import 'package:flutter/material.dart';
import 'package:minimal_weather/pages/weather_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Minimal Weather App", home: WeatherPage());
  }
}

import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:minimal_weather/models/weather_model.dart';
import "package:http/http.dart" as http;

class WeatherService {
  static const baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);

  // Function to get the weather using the city name
  Future<WeatherModel> getWeather(
    String subLocality,
    String locality,
    String subAdministrativeArea,
    String countryCode,
    String country,
  ) async {
    final response = await http.get(
      (Uri.parse(
        '$baseUrl?q=$subAdministrativeArea,$countryCode&appid=$apiKey&units=metric',
      )),
    );

    print(response.body);

    // Decode the data if the we get status code of 200
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(
        jsonDecode(response.body),
        subLocality,
        locality,
        country,
      );
    } else {
      throw Exception("Failed to load weather data");
    }
  }

  Future<Set<String?>> getCurrentCity() async {
    bool serviceEnabled;
    LocationPermission locationPermission;

    // Check if the location services are enabled:
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled");
    }

    // Get the location permission
    // 1) Check for the persmission
    locationPermission = await Geolocator.checkPermission();

    // 2) If the permission is denied, then ask for the location
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();

      if (locationPermission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    // 3) If location permisisons are denied forever:
    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error(
        "Location permissions are permanently denied, we cannot request the permission.",
      );
    }

    // End of permission:

    // Position:
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
      ),
    );

    // Get the placemark
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // Country code to identify the country
    // sub administrative area for fallback weather data
    // locality and sub localit

    String? subLocality = placemarks[0].subLocality;
    String? locality = placemarks[0].locality;
    String? subAdministrativeArea = placemarks[0].subAdministrativeArea;

    String? countryCode = placemarks[0].isoCountryCode;
    String? country = placemarks[0].country;

    return {subLocality, locality, subAdministrativeArea, countryCode, country};
  }
}

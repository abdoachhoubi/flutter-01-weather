import "dart:convert";
import "package:http/http.dart" as http;
import "package:geolocator/geolocator.dart";
import "package:geocoding/geocoding.dart";

import "../models/wheather_model.dart";

class WeatherService {
  static const baseUrl = "http://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      return (Weather.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception("Failed to fetch data");
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemarks[0].locality;

    return city ?? "Casablanca";
  }
}

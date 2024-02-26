import 'package:flutter/material.dart';
import "package:lottie/lottie.dart";

import "../services/weather_service.dart";
import "../models/wheather_model.dart";
import "../utils/debugger.dart" show debugger;

class WheatherPage extends StatefulWidget {
  const WheatherPage({super.key});

  @override
  State<WheatherPage> createState() => _WheatherPageState();
}

class _WheatherPageState extends State<WheatherPage> {
  final _weatherService = WeatherService("f83358bd158bebd736dd613f254d3795");
  Weather? _weather;
  String animation = "assets/cloudy.json";

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      switch ((weather.mainCondition).toLowerCase()) {
        case "clouds":
        case "mist":
        case "fog":
        case "haze":
        case "dust":
          animation = "assets/cloudy.json";
          break;
        case "rain":
        case "drizzle":
        case "shower rain":
          animation = "assets/rainy.json";
          break;
        case "thunderstorm":
          animation = "assets/thunder.json";
          break;
        case "clear":
          animation = "assets/sunny.json";
          break;
        default:
          animation = "assets/sunny.json";
      }
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      debugger(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.cityName ?? "Loading", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

            Container(
              margin: const EdgeInsets.only(top: 120, bottom: 120),
              child: Lottie.asset(animation),
            ),
            Text('${_weather?.temperature.round()}°C', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

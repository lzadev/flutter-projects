import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/extensions/string_extension.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService("a12bcb0a366124f723d1b7e6cfe1c915");
  Weather? _weather;

  _fecthWeather() async {
    String cityName = await _weatherService.getCurrenCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String _getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/lottie/clouds.json';
    }

    switch (mainCondition.toLowerCase().trim()) {
      case 'clouds':
      case 'cloudy':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/lottie/clouds.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/lottie/rain.json';
      case 'clear':
        return 'assets/lottie/sunny.json';
      case 'snow':
        return 'assets/lottie/snow.json';
      default:
        return 'assets/lottie/clouds.json';
    }
  }

  @override
  void initState() {
    super.initState();

    _fecthWeather();
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(top: safePadding + 15),
          width: double.infinity,
          child: Column(
            children: [
              Lottie.asset('assets/lottie/location.json', height: 80),
              Text(
                _weather?.cityName.capitalize() ?? "loading city",
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 150,
              ),
              Lottie.asset(_getWeatherAnimation(_weather?.mainCondition)),
              Text(
                '${_weather?.temperature.toInt()}°',
                style: const TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                _weather?.description.capitalize() ?? "loading description",
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _weather?.mainCondition.capitalize() ?? "loading description",
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

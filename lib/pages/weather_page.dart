import 'package:daily_weather/models/weather_model.dart';
import 'package:daily_weather/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  //burda api keyimizi tanımlıyoruz.
  final _weatherService = WeatherService(apiKey: 'ac27855d81551d3883c642bd2bdb650d'); //burda api keyimizi tanımlıyoruz.
  Weather? _weather; //burda hava durumunu tanımlıyoruz.

  //fetch weather
  _fetchWeather() async {
    //get current city
    //burda kullanıcının konumunu alıyoruz.
    String cityName = await _weatherService.getCurrentCity();

    //get weather for city
    //burda kullanıcının konumuna göre hava durumunu getiriyoruz.
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  //weather animations //burda hava durumuna göre animasyonlar ekliyoruz.
  String getWeatherAnimation(String mainCondition) {
    if (mainCondition == 'null') {
      return 'assets/sunny.json';
    }
    switch (mainCondition.toLowerCase()) {
      case "clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return 'assets/cloud.json';
      case "rain":
      case "drizzle":
      case "shower rain":
        return 'assets/rainy.json';
      case "thunderstorm":
        return 'assets/thunder.json';
      case "clear":
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  //init state
  @override // burda initState fonksiyonunu override ediyoruz. amacımız uygulama başladığında hava durumunu getirmek.
  void initState() {
    super.initState();
    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //city name  //burda şehir adını yazdırıyoruz.
          const Icon(Icons.location_on, color: Colors.grey, size: 48),
          Text(
            _weather?.cityName ?? 'Loading City...',
            style: const TextStyle(color: Colors.grey, fontSize: 24),
          ),

          //animation
          Lottie.asset(getWeatherAnimation(_weather?.mainCondition ?? 'null')),

          //temperature //burda sıcaklığı yazdırıyoruz.

          Text('${_weather?.temperature.round() ?? 0}°', style: const TextStyle(color: Colors.white, fontSize: 48)),

          //weather condition //burda hava durumunu yazdırıyoruz.
          Text(_weather?.mainCondition ?? '', style: const TextStyle(color: Colors.grey, fontSize: 24)),
        ]),
      ),
    );
  }
}

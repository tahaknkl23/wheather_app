import 'dart:convert';

import 'package:daily_weather/models/weather_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  //burda api urlimizi tanımlıyoruz.
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
//burda api keyimizi alıyoruz.
  final String apiKey;
  WeatherService({
    required this.apiKey,
  });
  //biz burda şu işlemi yapıyoruz. Kullanıcının girdiği şehir adına göre hava durumunu getiriyoruz.
  Future<Weather> getWeather(String cityName) async {
    final url = '$BASE_URL?q=$cityName&appid=$apiKey&units=metric'; //burda api urlimizi oluşturuyoruz.
    final response = await http.get(Uri.parse(url));//burda api urlimize get isteği atıyoruz.
    if (response.statusCode == 200) {//burda api urlimize atılan get isteğinin durumunu kontrol ediyoruz.
      final json = jsonDecode(response.body);//burda api urlimize atılan get isteğinin body kısmını json formatına çeviriyoruz.
      return Weather.fromJson(json);//burda json formatına çevirdiğimiz body kısmını Weather modeline çeviriyoruz.
    } else {//burda api urlimize atılan get isteğinin durumu 200 değilse hata döndürüyoruz.
      throw Exception('Failed to load weather data');
    }
  }
//biiz burda şu işlemi yapıyoruz. Kullanıcının konumunu alıyoruz ve bu konuma göre hava durumunu getiriyoruz.

  Future<String> getCurrentCity() async {//burda kullanıcının konumunu alıyoruz.
    LocationPermission permission = await Geolocator.requestPermission();//burda konum izni alıyoruz.
    //burda konum izni alıyoruz.
    if (permission == LocationPermission.denied) {//burda konum izni yoksa konum izni istiyoruz.
      permission = await Geolocator.requestPermission();//burda konum izni alıyoruz.
    }
//burda konumumuzu alıyoruz.
    Position position = await Geolocator.getCurrentPosition(//burda konumumuzu alıyoruz.
      desiredAccuracy: LocationAccuracy.high,//burda konumumuzu alıyoruz.
    );
//burda konumumuza göre şehir adını alıyoruz.
    List<Placemark> placemarks = await placemarkFromCoordinates(//burda konumumuza göre şehir adını alıyoruz.
      position.latitude,//burda konumumuza göre şehir adını alıyoruz.
      position.longitude,
    );
//burda şehir adını döndürüyoruz.
    String? city = placemarks.isNotEmpty ? placemarks[0].locality : null;//burda şehir adını döndürüyoruz.
    return city ?? 'Unknown City';//burda şehir adını döndürüyoruz.
  }
}

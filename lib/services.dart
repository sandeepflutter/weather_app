
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/weather.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DataService {
  Future<Object> getWeather(String city) async {
    // https://api.openweathermap.org/data/2.5/weather?q=delhi&appid=eb558e5341b8e9ba278feb71ed3f3b2c


    final queryParameters = {
      'q': city,
      'appid': 'eb558e5341b8e9ba278feb71ed3f3b2c',
      'units': 'imperial'
    };

    final uri = Uri.https(
        'api.openweathermap.org', '/data/2.5/weather', queryParameters);

    final response = await http.get(uri);
  
  if (response.statusCode == 200) {
       final json = jsonDecode(response.body);
    return WeatherResponse.fromJson(json);
    } else {

     return Fluttertoast.showToast(msg: 'Please Enter Correct City Name', gravity: ToastGravity.BOTTOM);
    // return Future.error('FooError');
    }
  }
}

class DataService1 {
  Future<WeatherResponse> getWeather1(String city) async {
    // https://api.openweathermap.org/data/2.5/weather?q=delhi&appid=eb558e5341b8e9ba278feb71ed3f3b2c


    final queryParameters = {
      'q': city,
      'appid': 'eb558e5341b8e9ba278feb71ed3f3b2c',
      'units': 'imperial'
    };

    final uri = Uri.https(
        'api.openweathermap.org', '/data/2.5/weather', queryParameters);

    final response = await http.get(uri);
  
    final json = jsonDecode(response.body);
    return WeatherResponse.fromJson(json);
  }
}
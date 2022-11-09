class WeatherInfo {
  final String description;
  final String icon;

  WeatherInfo({required this.description, required this.icon});

  factory WeatherInfo.fromJson( dynamic json) {
    final description = json['description'];
    final icon = json['icon'];
    return WeatherInfo(description: description, icon: icon);
  }
}

class TemperatureInfo {
  final double temperature;

  TemperatureInfo({required this.temperature});

  factory TemperatureInfo.fromJson( dynamic json) {
    final temperature = json['temp'];
    return TemperatureInfo(temperature: temperature);
  }
}

class WeatherResponse {
  final String cityName;
  final TemperatureInfo tempInfo;
  final WeatherInfo weatherInfo;

  String get iconUrl {
    return 'https://openweathermap.org/img/wn/${weatherInfo.icon}@2x.png';
  }

  WeatherResponse({required this.cityName, required this.tempInfo, required this.weatherInfo});

  factory WeatherResponse.fromJson( dynamic json) {
    final cityName = json['name'];

    final tempInfoJson = json['main'];
    final tempInfo = TemperatureInfo.fromJson(tempInfoJson);

    final weatherInfoJson = json['weather'][0];
    final weatherInfo = WeatherInfo.fromJson(weatherInfoJson);




    return WeatherResponse(
        cityName: cityName, tempInfo: tempInfo, weatherInfo: weatherInfo);
  }
}

class MessInfo {
  final double message;

  MessInfo({required this.message});

  factory MessInfo.fromJson( dynamic json) {
    final message = json['temp'];
    return MessInfo(message: message);
  }
}

class WeatherResponse2 {
  final String cityName;
  final MessInfo messInfo;

  WeatherResponse2({required this.cityName, required this.messInfo});

  factory WeatherResponse2.fromJson( dynamic json) {
    final cityName = json['name'];

    final messInfoJson = json['message'];
    final messInfo = MessInfo.fromJson(messInfoJson);

    return WeatherResponse2(
        cityName: cityName, messInfo: messInfo,);
  }
}
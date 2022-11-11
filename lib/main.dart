// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather_app/splash.dart';
import 'package:weather_app/services.dart';
import 'package:weather_app/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:const Splash(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


   String? _currentAddress;
   Position? _currentPosition;

   // Future<void> _loadCounter() async {
   //   final prefs = await SharedPreferences.getInstance();
   //   setState(() {
   //     _currentPosition = (prefs.getInt('counter') ?? 0);
   //   });
   // }



  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }


  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }


    Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        ' ${place.subAdministrativeArea}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }



  final _cityTextController = TextEditingController();
  final _dataService = DataService();
  final _dataService1= DataService1();

  WeatherResponse? _response;
  WeatherResponse? _response1;

   @override
  void initState() {
    super.initState();
   _getCurrentPosition();
      _search1();
  }




  @override
  void dispose(){
    _cityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
         actions: <Widget>[
    IconButton(
      icon: const Icon(
        Icons.info,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Splash()),
            );
      },
    )
  ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              if (_response != null)
                Column(
                  children: [
                    Image.network(_response!.iconUrl),
                    Text(
                      '${_response!.tempInfo.temperature}°C',
                      style: const TextStyle(fontSize: 40),
                    ),
                    Text(_response!.weatherInfo.description),
                  ],
                ),

              if (_response1 != null && _response == null)
                Column(
                  children: [
                    Image.network(_response1!.iconUrl),
                    Text(
                      '${_response1!.tempInfo.temperature}°C',
                      style: const TextStyle(fontSize: 40),
                    ),
                    Text(_response1!.weatherInfo.description)
                  ],
                ),

              if (_response1 == null && _response == null)
                Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                           CircularProgressIndicator(),
                           // ignore: prefer_const_constructors
                           Text("Check Your Internet",
                          style: TextStyle(fontSize: 20),)
                        ],
                      ),
                    ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: SizedBox(
                  width: 150,
                  
                  child: TextField(
                      controller: _cityTextController,
                      decoration: const InputDecoration(labelText: 'City Name',
                      border: OutlineInputBorder()),
                      textAlign: TextAlign.center),
                ),
              ),
//Changing value of button as per Input text
              ValueListenableBuilder<TextEditingValue>(
        valueListenable: _cityTextController,
        builder: (context, value, child) {
          return ElevatedButton(
            onPressed: _search,
            child: value.text.isNotEmpty ? const Text('UPDATE'):const Text('SAVE'),
          );
        },
      ),

              Text('LAT: ${_currentPosition?.latitude ?? ""}'),
              Text('LNG: ${_currentPosition?.longitude ?? ""}'),
              Text('CURRENT ADDRESS: ${_currentAddress ?? ""}'),

            ],
          ),
        ),
      ),
    // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
   void _search() async {
    final response = await _dataService.getWeather(_cityTextController.text);
   setState(() => _response= response as WeatherResponse?);
  }


    void _search1() async {
    final response1 = await _dataService1.getWeather1('kathmandu');
   setState(() => _response1= response1);
  }

}
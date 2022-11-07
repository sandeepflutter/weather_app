import 'package:flutter/material.dart';
import 'package:weather_app/splash.dart';
import 'package:weather_app/services.dart';
import 'package:weather_app/weather.dart';

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

  final _cityTextController = TextEditingController();
  final _dataService = DataService();

  WeatherResponse? _response;

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
                      '${_response!.tempInfo.temperature}°',
                      style: const TextStyle(fontSize: 40),
                    ),
                    Text(_response!.weatherInfo.description)
                  ],
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

              ValueListenableBuilder<TextEditingValue>(
        valueListenable: _cityTextController,
        builder: (context, value, child) {
          return ElevatedButton(
            onPressed: _search,
            
            child: value.text.isNotEmpty ? const Text('UPDATE'):const Text('SAVE'),
          );
        },
      ),
              // ElevatedButton(
              //   onPressed: _search, child: const Text('Search'))
            ],
          ),
        ),
      ),
    // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
   void _search() async {
    final response = await _dataService.getWeather(_cityTextController.text);
   setState(() => _response= response);
  }
}

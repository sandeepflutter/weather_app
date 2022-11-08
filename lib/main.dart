import 'package:flutter/material.dart';
import 'package:weather_app/splash.dart';
import 'package:weather_app/services.dart';
import 'package:weather_app/weather.dart';
import 'package:geolocator/geolocator.dart';

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

  var location="";
  var lat="";
  var lon ="";

  void getCurrentLocation() async{
bool serviceEnabled;
    LocationPermission permission;

     // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }
 
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
 
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

setState(() {
  location = "$position.latitude ,$position.longitude";
 // lat = "$position.latitude";
  lon ="$position.longitude";
});

  }

  final _cityTextController = TextEditingController();
  final _cityTextController1 = TextEditingController();
  final _dataService = DataService();
  final _dataService1= DataService1();

  WeatherResponse? _response;
  WeatherResponse? _response1;

   @override
  void initState() {
    super.initState();
   getCurrentLocation();

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
                      '${_response!.tempInfo.temperature}°',
                      style: const TextStyle(fontSize: 40),
                    ),
                    Text(_response!.weatherInfo.description)
                  ],
                ),

                if (_response1 != null && _response == null)
                   Column(
                  children: [
                    Image.network(_response1!.iconUrl),
                    Text(
                      '${_response1!.tempInfo.temperature}°',
                      style: const TextStyle(fontSize: 40),
                    ),
                    Text(_response1!.weatherInfo.description)
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

    // ValueListenableBuilder<TextEditingValue>(
    //     valueListenable: _cityTextController,
    //     builder: (context, value, child) {
    //       return ElevatedButton(
    //         onPressed: _search1,
    //         child: value.text.isNotEmpty ? const Text('UPDATE'):const Text('SAVE'),
    //       );
    //     },
    //   ),
        Text("hello: $lon"),
    
      
      
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

    void _search1() async {
    final response1 = await _dataService1.getWeather1('kathmandu');
   setState(() => _response1= response1);
  }
}

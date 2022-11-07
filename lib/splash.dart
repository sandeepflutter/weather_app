import 'package:flutter/material.dart';

import 'main.dart';

//changing state we need stateful widget
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  //function to run first time after class is called
  @override
  void initState() {
    super.initState();
    _nav();
  }

//we are async because we are using time
  _nav() async {
    await Future.delayed(const Duration(milliseconds: 5000), () {});
    //If a StatefulWidget uses BuildContext, the mounted property has to be checked after an asynchronous gap.
    if (!mounted) return; 
  
//pushreplacement to permantly reach directed screen
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const MyHomePage(
                  title: 'Weather',
                )));
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        //background filled image
        decoration: const BoxDecoration(
          image: DecorationImage(image: 
          AssetImage(
              'assets/bg.png',
            ),
            fit: BoxFit.fill,
            )
            
        ),
        child: Center(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(40.0),
                //Display text
                child:  Text(
                  'WE SHOW WEATHER FOR YOU',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),

          //Skip button
            const SizedBox(height: 120),
            OutlinedButton.icon(
              icon: const Icon(Icons.skip_next, size: 18),
              label: const Text('Skip'),
              onPressed: () {
                Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Weather',)),
              );
              },
            ),
            ],
          ),
        ),
      ),
    );
  }
}

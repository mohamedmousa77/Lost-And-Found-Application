import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lost/AddOrRwmovePage.dart';
import 'package:splashscreen/splashscreen.dart';

class thankSplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return thankSplashScreenState();
  }
}
class thankSplashScreenState extends State<thankSplashScreen>{
  String text ='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreen(
        backgroundColor: Colors.black,
        photoSize: 160,
        seconds: 3,
        image: Image.asset('images/Thank-You.jpg'),
        title: Text(text,
          style: TextStyle(fontSize: 35 ,fontWeight: FontWeight.bold, color: Colors.pinkAccent,
              fontStyle: FontStyle.italic)),
        loaderColor: Colors.pink,
        loadingText: Text('please wait ' , style: TextStyle(color: Colors.pinkAccent),),
        navigateAfterSeconds: AddOrRwmovePage(),
      ),
    );
  }

}
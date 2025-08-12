import 'package:flutter/material.dart';
import 'home_screen.dart';
void main(){
  runApp(const MyApp());
}
class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.blue,
     title: "Weather App "   ,
    home: WeatherScreen(),
    theme: ThemeData(
useMaterial3: true
    ),
    );
  }
}

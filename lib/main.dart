import 'package:flutter/material.dart';
import 'package:spotify_app_prueba/screens/home_screen.dart';
import 'package:spotify_app_prueba/screens/login_screen.dart';
import 'package:spotify_app_prueba/screens/tranck_screen.dart';
import 'package:spotify_app_prueba/screens/wait_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColorDark: Colors.black,
        primaryColor: Color(0xff1ed760),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => new LoginScreen(),
        '/wait': (context) => WaitScreen(),
        '/home': (context) => HomeScreen(),
        '/tracks': (context) => TracksScreen()
      },
    );
  }
}

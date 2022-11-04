import 'package:flutter/material.dart';
import 'Screens/FirstScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => FirstScreen(date: DateTime.now(),),
      },
      title: "apod",
    );
  }
}

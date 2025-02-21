import 'package:flutter/material.dart';
import 'package:latin_news/views/news_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "home",
      routes: {
        'home': (BuildContext context) => HomePage()
      },
    );
  }
}


import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock Market',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Home(title: 'Stock Market'),
    );
  }
}



import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:stocks_app/screens/home.dart';

void main() => runApp(MyApp());

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));
    return MaterialApp(
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child,
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'Stock Market',
      theme: ThemeData(
        appBarTheme: AppBarTheme(brightness: Brightness.light),
        primarySwatch: Colors.blue,
      ),
      home: Home(title: 'Stock Market'),
    );
  }
}

import 'package:flutter/material.dart';
import 'dice_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cee-lo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: DicePage(),
    );
  }
}

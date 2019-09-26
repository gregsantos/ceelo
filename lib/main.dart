import 'package:flutter/material.dart';
// import 'dice_page.dart';
import 'panel_home.dart';
import 'theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cee-lo',
      theme: panelTheme,
      home: PanelHome(),
    );
  }
}

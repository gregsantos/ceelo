import 'package:flutter/material.dart';
import 'home_view.dart';
import 'theme.dart';

Future<void> loadImage(bg) async {
  return AssetImage(bg);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadImage('images/asphalt.jpg');
  runApp(MyApp());
}

// void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cee-lo',
      theme: gameTheme,
      home: HomeView(),
    );
  }
}

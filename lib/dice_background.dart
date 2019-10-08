import 'package:flutter/material.dart';

class DiceBackground extends StatelessWidget {
  DiceBackground({this.background});
  final String background;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/$background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

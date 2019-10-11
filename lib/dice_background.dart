import 'package:flutter/material.dart';

class DiceBackground extends StatelessWidget {
  final String background;
  final int point;
  DiceBackground({this.background, this.point});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/$background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(bottom: 50.0, right: 40.0, child: Text("$point")),
      ],
    );
  }
}

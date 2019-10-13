import 'package:flutter/material.dart';

class DiceBackground extends StatelessWidget {
  final String background;
  final int point;
  final int shooter;

  DiceBackground({this.background, this.point, this.shooter});

  ColorSwatch<int> getPositionColor() {
    if (shooter == 0) {
      return Colors.pink;
    } else if (shooter == 1) {
      return Colors.purple;
    } else if (shooter == 2) {
      return Colors.greenAccent;
    }
    return Colors.cyan;
  }

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
        Positioned(
          top: 125.0,
          right: 40.0,
          child: Column(
            children: <Widget>[
              Text(
                point > 99
                    ? "${(point / 100).toStringAsFixed(0)} ${(point / 100).toStringAsFixed(0)} ${(point / 100).toStringAsFixed(0)}"
                    : "$point",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Point",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Positioned(
          top: 125.0,
          left: 40.0,
          child: Column(
            children: <Widget>[
              Text(
                "${shooter + 1}",
                style: TextStyle(
                    color: getPositionColor(),
                    fontSize: 48,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Shooter",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'utils/player_color.dart';

class Player extends StatelessWidget {
  final int playerPosition;
  final int dicePositon;
  final int point;
  final List<int> pointPosition;
  final List<int> off;

  Player(
    this.playerPosition,
    this.dicePositon,
    this.point,
    this.pointPosition,
    this.off,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        dicePositon == playerPosition
            ? Icon(
                Icons.all_out,
                size: 160.0,
                color: getPositionColor(playerPosition),
              )
            : Icon(
                Icons.brightness_1,
                size: 160.0,
                color: off.contains(playerPosition)
                    ? getPositionColor(playerPosition).withOpacity(0.4)
                    : getPositionColor(playerPosition),
              ),
      ],
    );
  }
}

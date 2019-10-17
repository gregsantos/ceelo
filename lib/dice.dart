import 'package:flutter/material.dart';
import 'dice_column.dart';
import 'dice_row.dart';

class Dice extends StatelessWidget {
  Dice(this._die1, this._die2, this._die3);
  final int _die1;
  final int _die2;
  final int _die3;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (BuildContext context, orientation) {
      var portrait = orientation == Orientation.portrait;
      return Container(
          child: Padding(
        padding: const EdgeInsets.only(top: 100.0, bottom: 0.0),
        child: Center(
          child: (portrait)
              ? DiceColumn(_die1, _die2, _die3)
              : DiceRow(_die1, _die2, _die3),
        ),
      ));
    });
  }
}

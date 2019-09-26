import 'package:flutter/material.dart';

List<Widget> buildDice(_die1, _die2, _die3, _dicePosition) {
  ColorSwatch<int> getPositionColor() {
    if (_dicePosition == 0) {
      return Colors.pink;
    } else if (_dicePosition == 1) {
      return Colors.purple;
    } else if (_dicePosition == 2) {
      return Colors.greenAccent;
    }
    return Colors.cyan;
  }

  return [
    Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Image.asset(
          'images/dice$_die1.png',
          color: getPositionColor(),
        ),
      ),
    ),
    Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Image.asset(
          'images/dice$_die2.png',
          color: getPositionColor(),
        ),
      ),
    ),
    Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Image.asset(
          'images/dice$_die3.png',
          color: getPositionColor(),
        ),
      ),
    )
  ];
}

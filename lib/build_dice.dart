import 'package:flutter/material.dart';

List<Widget> buildDice(_die1, _die2, _die3) {
  return [
    Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Image.asset('images/dice$_die1.png'),
      ),
    ),
    Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Image.asset('images/dice$_die2.png'),
      ),
    ),
    Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Image.asset('images/dice$_die3.png'),
      ),
    )
  ];
}

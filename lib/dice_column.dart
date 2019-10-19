import 'package:flutter/material.dart';
import 'die1.dart';
import 'die2.dart';
import 'die3.dart';
import 'die4.dart';
import 'die5.dart';
import 'die6.dart';

Widget getDie(dieRoll) {
  switch (dieRoll) {
    case 1:
      return Die1();
      break;
    case 2:
      return Die2();
      break;
    case 3:
      return Die3();
      break;
    case 4:
      return Die4();
      break;
    case 5:
      return Die5();
      break;
    case 6:
      return Die6();
      break;
    default:
      return Die3();
  }
}

class DiceColumn extends StatelessWidget {
  final int _die1;
  final int _die2;
  final int _die3;

  DiceColumn(this._die1, this._die2, this._die3);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 80.0, bottom: 0.0),
        child: Column(
          children: [getDie(_die1), getDie(_die2), getDie(_die3)],
        ),
      ),
    );
  }
}

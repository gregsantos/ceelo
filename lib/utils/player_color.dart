import 'package:flutter/material.dart';

Color getPositionColor(dicePosition) {
  if (dicePosition == 0) {
    return Colors.pink;
  } else if (dicePosition == 1) {
    return Colors.purple;
  } else if (dicePosition == 2) {
    return Colors.greenAccent;
  }
  return Colors.cyan;
}

Color getPointColor(pointPosition) {
  if (pointPosition == 0) {
    return Colors.pink;
  } else if (pointPosition == 1) {
    return Colors.purple;
  } else if (pointPosition == 2) {
    return Colors.greenAccent;
  } else if (pointPosition == 3) {
    return Colors.cyan;
  }
  return Colors.white;
}

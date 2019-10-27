import 'package:flutter/material.dart';

// pink, purple, greenAccent, cyan
// ( alpha,  hue,  saturation,  lightness) hsla(0, 100%, 50%, 0.6)
// Color playerOneColor = HSLColor.fromAHSL(1.0, 0.0, 1.0, 0.5).toColor();
Color playerOneColor = Color(0xffd4423a);
Color playerTwoColor = Color(0xffb74093);
Color playerThreeColor = Color(0xff4cc87b);
Color playerFourColor = Color(0xff6d8cd9);

Color getPositionColor(dicePosition) {
  if (dicePosition == 0) {
    return playerOneColor;
  } else if (dicePosition == 1) {
    return playerTwoColor;
  } else if (dicePosition == 2) {
    return playerThreeColor;
  }
  return playerFourColor;
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

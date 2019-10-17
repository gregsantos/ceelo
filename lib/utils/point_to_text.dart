String pointToText(int point) {
  String score;
  if (point > 99) {
    score = "Trip\n  ${(point / 100).toStringAsFixed(0)}";
  } else {
    score = point.toStringAsFixed(0);
  }
  return score;
}

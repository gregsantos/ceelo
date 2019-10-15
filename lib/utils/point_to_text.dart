String pointToText(int point) {
  String score = '';

  if (point > 99) {
    score = "Trip ${(point / 100).toStringAsFixed(0)}'s";
  }

  score = "$point";
  return score;
}

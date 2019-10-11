import 'package:flutter/material.dart';

class Face3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ( alpha,  hue,  saturation,  lightness) hsla(0, 100%, 50%, 0.6)
    HSLColor bg = HSLColor.fromAHSL(0.6, 0.0, 1.0, 0.5);
    return Container(
      width: 198.0,
      height: 198.0,
      decoration: BoxDecoration(color: bg.toColor()),
      child: Padding(
        padding: const EdgeInsets.all(2.25),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(2.25),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.25),
                  child: Container(
                    width: 60,
                    height: 60,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.25),
                  child: Container(
                    width: 60,
                    height: 60,
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(2.25),
                  child: Container(
                    width: 60,
                    height: 60,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.25),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(2.25),
                  child: Container(
                    width: 60,
                    height: 60,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.25),
                  child: Container(
                    width: 60,
                    height: 60,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.25),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

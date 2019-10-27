import 'package:flutter/material.dart';

class Face2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const double size = 146.52;
    const double pipSize = size / 3.3;
    const double pipPadding = size / 88;
    // ( alpha,  hue,  saturation,  lightness) hsla(0, 100%, 50%, 0.6)
    Color bg = HSLColor.fromAHSL(0.5, 0.0, 1.0, 0.5).toColor();
    return Container(
      width: 146.52,
      height: 146.52,
      decoration: BoxDecoration(color: bg),
      child: Padding(
        padding: const EdgeInsets.all(pipPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(pipPadding),
                  child: Container(
                    width: pipSize,
                    height: pipSize,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(pipPadding),
                  child: Container(
                    width: pipSize,
                    height: pipSize,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(pipPadding),
                  child: Container(
                    width: pipSize,
                    height: pipSize,
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
                  padding: const EdgeInsets.all(pipPadding),
                  child: Container(
                    width: pipSize,
                    height: pipSize,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(pipPadding),
                  child: Container(
                    width: pipSize,
                    height: pipSize,
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(pipPadding),
                  child: Container(
                    width: pipSize,
                    height: pipSize,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(pipPadding),
                  child: Container(
                    width: pipSize,
                    height: pipSize,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(pipPadding),
                  child: Container(
                    width: pipSize,
                    height: pipSize,
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

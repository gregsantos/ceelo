import 'package:flutter/material.dart';

class DiceBackground extends StatelessWidget {
  final String background;

  DiceBackground({this.background});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/$background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

/* FadeInImage.assetNetwork(
    placeholder: kTransparentImage,
    image: "images/$background.jpg",
    fit: BoxFit.cover,
  ),
); */

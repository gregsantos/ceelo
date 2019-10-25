import 'package:flutter/material.dart';

class PlayerBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [Colors.indigo, Colors.black],
            begin: Alignment.centerRight,
            end: new Alignment(-1.0, -1.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.black54,
              blurRadius: 15.0,
              offset: Offset(0.0, 0.75))
        ],
      ),
      padding: EdgeInsets.only(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.adjust,
            size: 60.0,
            color: Colors.pink,
          ),
          Icon(
            Icons.adjust,
            size: 60.0,
            color: Colors.purple,
          ),
          Icon(
            Icons.adjust,
            size: 60.0,
            color: Colors.greenAccent,
          ),
          Icon(
            Icons.adjust,
            size: 60.0,
            color: Colors.cyan,
          ),
        ],
      ),
    );
  }
}

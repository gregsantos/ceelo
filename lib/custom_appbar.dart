import 'package:flutter/material.dart';

class MyCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final bool defaultAppBar;

  const MyCustomAppBar({
    Key key,
    @required this.height,
    this.defaultAppBar = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.grey[300],
          child: Padding(
            padding: EdgeInsets.all(0),
            child: defaultAppBar
                ? AppBar(
                    title: Text('4, 5, 6'),
                  )
                : _customAppBar(context),
          ),
        ),
      ],
    );
  }

  Widget _customAppBar(BuildContext context) {
    return SafeArea(
      child: Container(
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
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.adjust, size: 60.0, color: Colors.pink),
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
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

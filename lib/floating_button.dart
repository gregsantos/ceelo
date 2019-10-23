import 'package:flutter/material.dart';

class MyFloatingActionButton extends StatefulWidget {
  @override
  _MyFloatingActionButtonState createState() => _MyFloatingActionButtonState();
}

class _MyFloatingActionButtonState extends State<MyFloatingActionButton> {
  bool showFab = true;
  @override
  Widget build(BuildContext context) {
    return showFab
        ? FloatingActionButton(
            onPressed: () async {
              var bottomSheetController = await showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  color: Colors.grey[900],
                  height: 250,
                ),
              );
              showFoatingActionButton(false);
              print("$bottomSheetController");
/*               bottomSheetController.closed.then((value) {
                showFoatingActionButton(true);
              }); */
            },
          )
        : Container();
  }

  void showFoatingActionButton(bool value) {
    setState(() {
      showFab = value;
    });
  }
}

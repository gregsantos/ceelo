import 'package:flutter/material.dart';

class SettingsPanel extends StatelessWidget {
  SettingsPanel(this.isSelected, this.handleSelected);
  final List<bool> isSelected;
  final handleSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80.0),
      child: Column(
        children: <Widget>[
          ToggleButtons(
            children: <Widget>[
              //Icon(Icons.ac_unit),
              Text(
                "Street",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Casino",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ],
            onPressed: (int index) => handleSelected(index),
            isSelected: isSelected,
          ),
        ],
      ),
    );
  }
}

/* ToggleButtons(
  children: <Widget>[
    Icon(Icons.ac_unit),
    Icon(Icons.call),
    Icon(Icons.cake),
  ],
  onPressed: (int index) {
    setState(() {
      for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
        if (buttonIndex == index) {
          isSelected[buttonIndex] = true;
        } else {
          isSelected[buttonIndex] = false;
        }
      }
    });
  },
  isSelected: isSelected,
), */

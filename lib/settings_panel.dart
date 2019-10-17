import 'package:flutter/material.dart';

class SettingsPanel extends StatelessWidget {
  SettingsPanel(this.switchValue, this.updateSwitch);
  final bool switchValue;
  final updateSwitch;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Street",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Switch(
              value: switchValue,
              onChanged: (bool newValue) => updateSwitch(),
            ),
          ),
          Text(
            "Casino",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

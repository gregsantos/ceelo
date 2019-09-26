// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'backdrop.dart';
import 'custom_appbar.dart';

/// tracks what can be displayed in the front panel
enum FrontPanels { tealPanel, limePanel }

/// Tracks which front panel should be displayed
class FrontPanelModel extends Model {
  FrontPanelModel(this._activePanel);
  FrontPanels _activePanel;

  FrontPanels get activePanelType => _activePanel;

  Widget panelTitle(BuildContext context) {
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
      padding: EdgeInsetsDirectional.only(start: 16.0),
      alignment: AlignmentDirectional.centerStart,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.subhead,
        child: Text('Settings'),
      ),
    );
  }

  Widget get activePanel =>
      _activePanel == FrontPanels.tealPanel ? TealPanel() : LimePanel();

  void activate(FrontPanels panel) {
    _activePanel = panel;
    notifyListeners();
  }
}

class PanelHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ScopedModel(
      model: FrontPanelModel(FrontPanels.tealPanel),
      child: Scaffold(
        appBar: MyCustomAppBar(
          height: 70,
          defaultAppBar: false,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/background.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Panels()
          ],
        ),
      ));
}

class Panels extends StatelessWidget {
  final frontPanelVisible = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<FrontPanelModel>(
      builder: (context, _, model) => Backdrop(
        frontLayer: model.activePanel,
        backLayer: BackPanel(
          frontPanelOpen: frontPanelVisible,
        ),
        frontHeader: model.panelTitle(context),
        panelVisible: frontPanelVisible,
        frontPanelOpenHeight: 40.0,
        frontHeaderHeight: 48.0,
      ),
    );
  }
}

class TealPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
        // Box decoration takes a gradient
        gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          // Add one stop for each color. Stops should increase from 0 to 1
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            // Colors are easy thanks to Flutter's Colors class.
            Colors.indigo[800],
            Colors.indigo[700],
            Colors.indigo[600],
            Colors.indigo[400],
          ],
        ),
      ),
      child: Center(child: Text('Gradient panel')));
}

class LimePanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(color: Colors.lime, child: Center(child: Text('Lime panel5')));
}

/// This needs to be a stateful widget in order to display which front panel is open
class BackPanel extends StatefulWidget {
  BackPanel({@required this.frontPanelOpen});
  final ValueNotifier<bool> frontPanelOpen;

  @override
  createState() => _BackPanelState();
}

class _BackPanelState extends State<BackPanel> {
  bool panelOpen;
  BuildContext scaffoldContext;
  int _die1 = 4;
  int _die2 = 5;
  int _die3 = 6;

  @override
  initState() {
    super.initState();
    panelOpen = widget.frontPanelOpen.value;
    widget.frontPanelOpen.addListener(_subscribeToValueNotifier);
  }

  void _subscribeToValueNotifier() =>
      setState(() => panelOpen = widget.frontPanelOpen.value);

  /// Required for resubscribing when hot reload occurs
  @override
  void didUpdateWidget(BackPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.frontPanelOpen.removeListener(_subscribeToValueNotifier);
    widget.frontPanelOpen.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, constrain) {
      scaffoldContext = context;
      return GestureDetector(
        onTap: () => print('Tapped'),
        child: Container(
          margin: const EdgeInsets.only(top: 25.0, bottom: 75.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset('images/dice4.png'),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset('images/dice5.png'),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset('images/dice6.png'),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

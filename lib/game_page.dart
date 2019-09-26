// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'dart:math';
import 'package:scoped_model/scoped_model.dart';
import 'backdrop.dart';
import 'custom_appbar.dart';
import 'build_dice.dart';

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

class GamePage extends StatelessWidget {
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
            GameView()
          ],
        ),
      ));
}

class GameView extends StatelessWidget {
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
  BackPanel({Key key, @required this.frontPanelOpen, this.players = 4})
      : super(key: key);
  final ValueNotifier<bool> frontPanelOpen;
  final int players;

  @override
  createState() => _BackPanelState();
}

class _BackPanelState extends State<BackPanel> {
  bool panelOpen;
  BuildContext scaffoldContext;
  static final random = Random().nextInt(3) + 1;
  int _startingPosition = random;
  int _dicePosition = random;
  int _die1 = 4;
  int _die2 = 5;
  int _die3 = 6;
  int _point = 0;
  List _roll = [];
  List _pointPosition = [];
  List _rollOffQueue = [];
  bool _rollOff = false;
  String _msg = '';
  Function eq = const ListEquality().equals;

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

  /// Dice Logic
  void _headCrack() {
    setState(() {
      _pointPosition = [_dicePosition];
      _msg = 'HEAD CRACK! WINNER SHOOTER ${_dicePosition + 1}';
    });
    print(_msg);
    _showSnackBar(_msg);
    _resetPoint();
  }

  void _crapOut() {
    setState(() {
      _msg = 'CRAPS YOU LOSE!';
    });
    print('CRAP OUT');
    _showSnackBar(_msg);
    _advanceDicePosition();
  }

  void _resetPoint() {
    int dicePosition = _rollOff ? _rollOffQueue[0] : _pointPosition[0];
    String msg = _rollOff ? 'Roll Off Come Out' : 'Come out Roll!';
    setState(() {
      _dicePosition = dicePosition;
      _startingPosition = dicePosition;
      _point = 0;
      _pointPosition = [];
      _msg = msg;
    });
    _showSnackBar(_msg);
  }

  void _resetWinner() {
    int winnerPosition = _pointPosition[0];
    setState(() {
      _dicePosition = winnerPosition;
      _startingPosition = winnerPosition;
      _point = 0;
      _pointPosition = [];
      _rollOff = false;
      _msg = 'Come out Roll! Shooter ${winnerPosition + 1}';
    });
    print(_msg);
    _showSnackBar(_msg);
  }

  void _resetRollOff() {
    List rollOffQueue = _pointPosition;
    setState(() {
      _point = 0;
      _rollOff = true;
      _rollOffQueue = rollOffQueue;
      _startingPosition = rollOffQueue[0];
      _dicePosition = rollOffQueue[0];
      _pointPosition = [];
      _msg = 'ROLL OFF between $rollOffQueue';
    });
    print(_msg);
    _showSnackBar('Come Out Shooter ${_startingPosition + 1}');
  }

  void _checkWinner() {
    print('Checking Leaders $_pointPosition with $_point');
    if (_pointPosition.length == 1) {
      setState(() {
        _msg = 'Shooter ${_pointPosition[0] + 1} Wins with $_point';
      });
      print(_msg);
      _showSnackBar(_msg);
      _resetWinner();
    } else {
      _resetRollOff();
    }
  }

  void _advanceDicePosition() {
    int newDicePosition = (_dicePosition == 3) ? 0 : ++_dicePosition;
    setState(() {
      _dicePosition = newDicePosition;
    });
    if (newDicePosition == _startingPosition) {
      _checkWinner();
    } else {
      if (_rollOff) {
        (_rollOffQueue.contains(newDicePosition))
            ? print("Shooter ${newDicePosition + 1} is in the roll off")
            : _advanceDicePosition();
      }
    }
  }

  void _compareScore(shooter, score) {
    print('Shooter: ${shooter + 1} | Score: $score | CurrentPoint: $_point');
    if (score == _point) {
      setState(() {
        _pointPosition.add(_dicePosition);
        _msg = 'ROLL OFF at $_point';
      });
      print('$_msg between $_pointPosition');
      _showSnackBar(_msg);
    }
    if (score < _point) {
      setState(() {
        _msg = 'NOT GONE CUT IT Shooter ${shooter + 1}';
      });
      print(_msg);
      _showSnackBar(_msg);
    }
    if (score > _point) {
      setState(() {
        _point = score;
        _pointPosition = [_dicePosition];
        _msg = 'YOU DA MAN Shooter ${shooter + 1}';
      });
      print(_msg);
      _showSnackBar(_msg);
    }
    _advanceDicePosition();
  }

  void _scoreRoll() {
    bool headcrack = eq(_roll, [4, 5, 6]);
    bool crappedOut = eq(_roll, [1, 2, 3]);
    int scoreDelta;
    print('Shooter ${_dicePosition + 1} rolled $_roll');
    if (headcrack) {
      _headCrack();
    } else if (crappedOut) {
      _crapOut();
    } else if (_die1 == _die2 && _die1 == _die3) {
      scoreDelta = _die1 * 100;
      setState(() {
        _msg = 'YOU ROLLED TRIP $_die1\'s';
      });
      _showSnackBar(_msg);
    } else if (_die1 == _die2 || _die1 == _die3 || _die2 == _die3) {
      int point = (_roll[0] == _roll[1]) ? _roll[2] : _roll[0];
      scoreDelta = point * 1;
      setState(() {
        _msg = 'YOU ROLLED $scoreDelta';
      });
      print(_msg);
      _showSnackBar(_msg);
    } else {
      setState(() {
        _msg = 'Roll again!';
      });
      print('Roll again!');
      _showSnackBar(_msg);
    }
    if (scoreDelta != null) {
      _compareScore(_dicePosition, scoreDelta);
    }
  }

  void _rollEm() {
    setState(() {
      _die1 = Random().nextInt(6) + 1;
      _die2 = Random().nextInt(6) + 1;
      _die3 = Random().nextInt(6) + 1;
      _roll = [_die1, _die2, _die3]..sort((a, b) => a.compareTo(b));
    });
    _scoreRoll();
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.indigo,
      duration: Duration(seconds: 1),
    );
    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    Scaffold.of(scaffoldContext).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _rollEm(),
      child: OrientationBuilder(builder: (BuildContext context, orientation) {
        scaffoldContext = context;
        var portrait = orientation == Orientation.portrait;
        return Container(
            margin: const EdgeInsets.only(top: 25.0, bottom: 75.0),
            child: (portrait)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...buildDice(_die1, _die2, _die3, _dicePosition)
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...buildDice(_die1, _die2, _die3, _dicePosition)
                    ],
                  ));
      }),
    );
  }
}

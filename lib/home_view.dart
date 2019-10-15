import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'dart:math';
import 'dart:async';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'player_bar.dart';
import 'dice_background.dart';
import 'dice_column.dart';
import 'dice_row.dart';
import 'utils/player_color.dart';
import 'utils/point_to_text.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        minHeight: 110,
        color: Colors.indigo[900],
        slideDirection: SlideDirection.DOWN,
        backdropEnabled: true,
        collapsed: PlayerBar(),
        panel: Center(
          child: Switch(
            value: true,
            onChanged: null,
          ),
        ),
        body: GameView(),
      ),
    );
  }
}

class GameView extends StatefulWidget {
  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  final String backgroundImage = 'asphalt';
  final int players = 4;
  static final random = Random().nextInt(3) + 1;
  BuildContext scaffoldContext;
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

  /// Dice Logic
  void _headCrack() {
    setState(() {
      _pointPosition = [_dicePosition];
      _msg = 'HEAD CRACK! Shooter ${_dicePosition + 1} TAKES THE CAKE';
    });
    _showSnackBar(_msg);
    _resetWinner();
  }

  void _crapOut() {
    setState(() {
      _msg = "See ya Shooter ${_dicePosition + 1} YOU CAUGHT AN L!";
    });
    _showSnackBar(_msg);
    _advanceDicePosition();
  }

  void _resetWinner() {
    int winnerPosition = _pointPosition[0];
    setState(() {
      _dicePosition = winnerPosition;
      _startingPosition = winnerPosition;
      _point = 0;
      _pointPosition = [];
      _rollOff = false;
      _rollOffQueue = [];
      _msg = 'New Come out Roll Shooter ${winnerPosition + 1}!';
    });
    _showSnackBar(_msg);
  }

  void _resetRollOff() {
    setState(() {
      _point = 0;
      _rollOff = true;
      _rollOffQueue = _pointPosition;
      _startingPosition = _pointPosition[0];
      _dicePosition = _pointPosition[0];
      _pointPosition = [];
      _msg = 'ROLL OFF Come Out! Your up Shooter ${_startingPosition + 1}!';
    });
    _showSnackBar(_msg);
  }

  void _checkWinner() {
    if (_pointPosition.length == 1) {
      String _winMsg =
          _point > 99 ? "WINS with TRIP $_die1\'s'" : "Wins with $_point";
      setState(() {
        _msg = 'Shooter ${_pointPosition[0] + 1} $_winMsg';
      });
      _showSnackBar(_msg);
      _resetWinner();
    } else {
      _resetRollOff();
    }
  }

  void _advanceDicePosition() {
    int newDicePosition = (_dicePosition == players - 1) ? 0 : ++_dicePosition;
    if (newDicePosition == _startingPosition) {
      _checkWinner();
    } else {
      setState(() {
        _dicePosition = newDicePosition;
        _msg = "You're up Shooter ${newDicePosition + 1}";
      });
      if (_rollOff) {
        (_rollOffQueue.contains(newDicePosition))
            ? _showSnackBar(_msg)
            : _advanceDicePosition();
      } else {
        _showSnackBar(_msg);
      }
    }
  }

  void _compareScore(dicePosition, score) {
    if (score == _point) {
      setState(() {
        _pointPosition.add(dicePosition);
        _msg = 'ROLL OFF at ${pointToText(_point)}';
      });
      _showSnackBar(_msg);
    }
    if (score < _point) {
      setState(() {
        _msg =
            "NOT GONE CUT IT Shooter ${dicePosition + 1}!\nPoint is still ${pointToText(_point)}";
      });
      _showSnackBar(_msg);
    }
    if (score > _point) {
      setState(() {
        _point = score;
        _pointPosition = [dicePosition];
        _msg = _point > 99
            ? "Shooter ${dicePosition + 1} Da Man wit TRIP $_die1\'s"
            : "Ok Shooter ${dicePosition + 1} You got the Point with $_point";
      });
      _showSnackBar(_msg);
    }
    _advanceDicePosition();
  }

  void _scoreRoll() {
    int scoreDelta;
    int shooter = _dicePosition + 1;
    List roll = _roll;
    bool headcrack = eq(roll, [4, 5, 6]);
    bool crappedOut = eq(roll, [1, 2, 3]);
    if (headcrack) {
      _headCrack();
    } else if (crappedOut) {
      _crapOut();
    } else if (_die1 == _die2 && _die1 == _die3) {
      // Rolled Trips
      scoreDelta = _die1 * 100;
      setState(() {
        _msg = 'Shooter $shooter ROLLED TRIP $_die1\'s';
      });
      _showSnackBar(_msg);
    } else if (_die1 == _die2 || _die1 == _die3 || _die2 == _die3) {
      // Rolled a point
      int point = (roll[0] == roll[1]) ? roll[2] : roll[0];
      scoreDelta = point * 1;
      setState(() {
        _msg = 'YOU ROLLED $scoreDelta';
      });
      _showSnackBar(_msg);
    } else {
      setState(() {
        _msg = 'No dice Baby!\nRoll again!';
      });
      _showSnackBar(_msg);
    }
    if (scoreDelta != null) {
      _compareScore(_dicePosition, scoreDelta);
    }
  }

  void _setDie1() {
    int wait = Random().nextInt((7 - 4) + 4) * 100;
    Timer(
      Duration(milliseconds: wait),
      () => setState(() {
        _die1 = Random().nextInt(6) + 1;
      }),
    );
  }

  void _setDie2() {
    int wait = Random().nextInt((7 - 4) + 4) * 100;
    Timer(
      Duration(milliseconds: wait),
      () => setState(() {
        _die2 = Random().nextInt(6) + 1;
      }),
    );
  }

  void _setDie3() {
    int wait = Random().nextInt((7 - 4) + 4) * 100;
    Timer(
      Duration(milliseconds: wait),
      () => setState(() {
        _die3 = Random().nextInt(6) + 1;
      }),
    );
  }

  Future<List> rollDice() {
    int random = Random().nextInt(15 - 5) + 5;
    for (var i = random; i >= 1; i--) {
      _setDie1();
      _setDie2();
      _setDie3();
    }
    return Future.delayed(Duration(milliseconds: 1000),
        () => [_die1, _die2, _die3]..sort((a, b) => a.compareTo(b)));
  }

  void handleDiceRoll() async {
    List roll = await rollDice();
    setState(() {
      _roll = roll;
    });
    _scoreRoll();
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.indigo[800],
      duration: Duration(seconds: 2),
    );
    Scaffold.of(scaffoldContext).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    scaffoldContext = context;
    return GestureDetector(
      onTap: () => handleDiceRoll(),
      child: Stack(
        children: [
          DiceBackground(
            background: backgroundImage,
          ),
          SafeArea(
            child: Dice(_die1, _die2, _die3, _dicePosition),
          ),
          Positioned(
            bottom: 40.0,
            left: 20.0,
            child: Column(
              children: <Widget>[
                Text(
                  "${_dicePosition + 1}",
                  style: TextStyle(
                      color: getPositionColor(_dicePosition),
                      fontSize: 48,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Shooter",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40.0,
            right: 20.0,
            child: Column(
              children: <Widget>[
                Text(
                  pointToText(_point),
                  style: TextStyle(
                      color: getPointColor(
                          _pointPosition.length == 0 ? 9 : _pointPosition[0]),
                      fontSize: 48,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Point",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DiceView extends StatefulWidget {
  DiceView({Key key, @required this.backgroundImage, this.players = 4})
      : super(key: key);
  final String backgroundImage;
  final int players;

  @override
  createState() => _DiceViewState();
}

class _DiceViewState extends State<DiceView> {
  BuildContext scaffoldContext;
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
  static final random = Random().nextInt(3) + 1;

  /// Dice Logic
  void _headCrack() {
    setState(() {
      _pointPosition = [_dicePosition];
      _msg = 'HEAD CRACK! Shooter ${_dicePosition + 1} TAKES THE CAKE';
    });
    _showSnackBar(_msg);
    _resetWinner();
  }

  void _crapOut() {
    setState(() {
      _msg = "See ya Shooter ${_dicePosition + 1} YOU CAUGHT AN L!";
    });
    _showSnackBar(_msg);
    _advanceDicePosition();
  }

  void _resetWinner() {
    int winnerPosition = _pointPosition[0];
    setState(() {
      _dicePosition = winnerPosition;
      _startingPosition = winnerPosition;
      _point = 0;
      _pointPosition = [];
      _rollOff = false;
      _rollOffQueue = [];
      _msg = 'New Come out Roll Shooter ${winnerPosition + 1}!';
    });
    _showSnackBar(_msg);
  }

  void _resetRollOff() {
    setState(() {
      _point = 0;
      _rollOff = true;
      _rollOffQueue = _pointPosition;
      _startingPosition = _pointPosition[0];
      _dicePosition = _pointPosition[0];
      _pointPosition = [];
      _msg = 'ROLL OFF Come Out! Your up Shooter ${_startingPosition + 1}!';
    });
    _showSnackBar(_msg);
  }

  void _checkWinner() {
    if (_pointPosition.length == 1) {
      String _winMsg =
          _point > 99 ? "WINS with TRIP $_die1\'s'" : "Wins with $_point";
      setState(() {
        _msg = 'Shooter ${_pointPosition[0] + 1} $_winMsg';
      });
      _showSnackBar(_msg);
      _resetWinner();
    } else {
      _resetRollOff();
    }
  }

  void _advanceDicePosition() {
    int newDicePosition =
        (_dicePosition == widget.players - 1) ? 0 : ++_dicePosition;
    if (newDicePosition == _startingPosition) {
      _checkWinner();
    } else {
      setState(() {
        _dicePosition = newDicePosition;
        _msg = "You're up Shooter ${newDicePosition + 1}";
      });
      if (_rollOff) {
        (_rollOffQueue.contains(newDicePosition))
            ? _showSnackBar(_msg)
            : _advanceDicePosition();
      } else {
        _showSnackBar(_msg);
      }
    }
  }

  void _compareScore(dicePosition, score) {
    if (score == _point) {
      setState(() {
        _pointPosition.add(dicePosition);
        _msg = 'ROLL OFF at $_point';
      });
      _showSnackBar(_msg);
    }
    if (score < _point) {
      setState(() {
        _msg =
            "NOT GONE CUT IT Shooter ${dicePosition + 1}!\nPoint is still ${pointToText(_point)}";
      });
      _showSnackBar(_msg);
    }
    if (score > _point) {
      setState(() {
        _point = score;
        _pointPosition = [dicePosition];
        _msg = _point > 99
            ? "Shooter ${dicePosition + 1} Da Man wit TRIP $_die1\'s"
            : "Ok Shooter ${dicePosition + 1} You got the Point with ${pointToText(_point)}";
      });
      _showSnackBar(_msg);
    }
    _advanceDicePosition();
  }

  void _scoreRoll() {
    int scoreDelta;
    int shooter = _dicePosition + 1;
    List roll = _roll;
    bool headcrack = eq(roll, [4, 5, 6]);
    bool crappedOut = eq(roll, [1, 2, 3]);
    if (headcrack) {
      _headCrack();
    } else if (crappedOut) {
      _crapOut();
    } else if (_die1 == _die2 && _die1 == _die3) {
      // Rolled Trips
      scoreDelta = _die1 * 100;
      setState(() {
        _msg = 'Shooter $shooter ROLLED TRIP $_die1\'s';
      });
      _showSnackBar(_msg);
    } else if (_die1 == _die2 || _die1 == _die3 || _die2 == _die3) {
      // Rolled a point
      int point = (roll[0] == roll[1]) ? roll[2] : roll[0];
      scoreDelta = point * 1;
      setState(() {
        _msg = 'YOU ROLLED ${pointToText(scoreDelta)}';
      });
      _showSnackBar(_msg);
    } else {
      setState(() {
        _msg = 'No dice Baby! Roll again!';
      });
      _showSnackBar(_msg);
    }
    if (scoreDelta != null) {
      _compareScore(_dicePosition, scoreDelta);
    }
  }

  void _setDie1() {
    int wait = Random().nextInt((7 - 4) + 4) * 100;
    Timer(
      Duration(milliseconds: wait),
      () => setState(() {
        _die1 = Random().nextInt(6) + 1;
      }),
    );
  }

  void _setDie2() {
    int wait = Random().nextInt((7 - 4) + 4) * 100;
    Timer(
      Duration(milliseconds: wait),
      () => setState(() {
        _die2 = Random().nextInt(6) + 1;
      }),
    );
  }

  void _setDie3() {
    int wait = Random().nextInt((7 - 4) + 4) * 100;
    Timer(
      Duration(milliseconds: wait),
      () => setState(() {
        _die3 = Random().nextInt(6) + 1;
      }),
    );
  }

  Future<List> rollDice() {
    int random = Random().nextInt(15 - 5) + 5;
    for (var i = random; i >= 1; i--) {
      _setDie1();
      _setDie2();
      _setDie3();
    }
    return Future.delayed(Duration(milliseconds: 1000),
        () => [_die1, _die2, _die3]..sort((a, b) => a.compareTo(b)));
  }

  void handleDiceRoll() async {
    List roll = await rollDice();
    setState(() {
      _roll = roll;
    });
    _scoreRoll();
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.indigo[800],
      duration: Duration(seconds: 2),
    );
    Scaffold.of(scaffoldContext).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    scaffoldContext = context;
    return GestureDetector(
      onTap: () => handleDiceRoll(),
      child: Stack(
        children: [
          DiceBackground(
            background: widget.backgroundImage,
          ),
          SafeArea(
            child: Dice(_die1, _die2, _die3, _dicePosition),
          ),
          Positioned(
            bottom: 40.0,
            left: 20.0,
            child: Column(
              children: <Widget>[
                Text(
                  "${_dicePosition + 1}",
                  style: TextStyle(
                      color: getPositionColor(_dicePosition),
                      fontSize: 48,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Shooter",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40.0,
            right: 20.0,
            child: Column(
              children: <Widget>[
                Text(
                  _point > 99
                      ? "${(_point / 100).toStringAsFixed(0)} ${(_point / 100).toStringAsFixed(0)} ${(_point / 100).toStringAsFixed(0)}"
                      : "$_point",
                  style: TextStyle(
                      color: getPointColor(
                          _pointPosition.length == 0 ? 9 : _pointPosition[0]),
                      fontSize: 48,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Point",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Dice extends StatelessWidget {
  Dice(this._die1, this._die2, this._die3, this._dicePosition);
  final int _die1;
  final int _die2;
  final int _die3;
  final int _dicePosition;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (BuildContext context, orientation) {
      var portrait = orientation == Orientation.portrait;
      return Container(
          child: Padding(
        padding: const EdgeInsets.only(top: 100.0, bottom: 0.0),
        child: Center(
          child: (portrait)
              ? DiceColumn(_die1, _die2, _die3)
              : DiceRow(_die1, _die2, _die3),
        ),
      ));
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:collection/collection.dart';
import 'dart:math';
import 'dart:async';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'player_bar.dart';
import 'dice_background.dart';
import 'dice.dart';
import 'utils/player_color.dart';
import 'settings_panel.dart';
import 'utils/point_to_text.dart';
import 'dialog.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<bool> isSelected = [true, false];

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      precacheImage(AssetImage("images/asphalt.jpg"), context);
    });
    super.initState();
  }

  void handleSelected(int index) {
    setState(() {
      for (int buttonIndex = 0;
          buttonIndex < isSelected.length;
          buttonIndex++) {
        if (buttonIndex == index) {
          isSelected[buttonIndex] = true;
        } else {
          isSelected[buttonIndex] = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
          minHeight: 100,
          maxHeight: 200,
          color: Colors.indigo[900],
          slideDirection: SlideDirection.DOWN,
          backdropEnabled: true,
          collapsed: PlayerBar(),
          panel: SettingsPanel(isSelected, handleSelected),
          body: GameView(background: isSelected[0] ? 'asphalt' : 'felt')),
    );
  }
}

class GameView extends StatefulWidget {
  final String background;

  GameView({this.background});

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  final int players = 4;
  static final int random = Random().nextInt(3) + 1;
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
    int winner = _dicePosition + 1;
    setState(() {
      _pointPosition = [_dicePosition];
      _msg = "HEAD CRACK!";
    });
    showEndGameDialog(context, winner, _msg);
  }

  void _crapOut() {
    setState(() {
      _msg = "See ya Shooter ${_dicePosition + 1} YOU CAUGHT AN L!";
    });
    _showSnackBar(_msg);
    _advanceDicePosition();
  }

  void _resetWinner(winnerCome) {
    print('$winnerCome');
    int winnerPosition = _pointPosition[0];
    setState(() {
      _dicePosition = winnerPosition;
      _startingPosition = winnerPosition;
      _point = 0;
      _pointPosition = [];
      _rollOff = false;
      _rollOffQueue = [];
    });
  }

  void _resetRollOff() {
    setState(() {
      _point = 0;
      _rollOff = true;
      _rollOffQueue = _pointPosition;
      _startingPosition = _pointPosition[0];
      _dicePosition = _pointPosition[0];
      _pointPosition = [];
    });
  }

  void _checkWinner() {
    if (_pointPosition.length == 1) {
      int winner = _pointPosition[0] + 1;
      String winMsg = "WINNER ${pointToText(_point)}";
      // end game
      showEndGameDialog(context, winner, winMsg);
    } else {
      showRollOffDialog(context, _rollOffQueue);
    }
  }

  void showEndGameDialog(context, winner, winMsg) async {
    int winnerCome = await showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: winMsg,
        winner: winner,
        description: "Shooter $winner takes the cake",
        buttonText: "Play again",
      ),
    );
    _resetWinner(winnerCome);
  }

  void showRollOffDialog(context, players) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: "ROLL OFF!",
        winner: 0,
        description:
            "Double down and roll again!\nPlayers ${players.map((player) => player)}",
        buttonText: "Roll Off",
      ),
    );
    _resetRollOff();
  }

  void _advanceDicePosition() {
    int newDicePosition = (_dicePosition == players - 1) ? 0 : ++_dicePosition;
    if (newDicePosition == _startingPosition) {
      Timer(Duration(milliseconds: 500), () => _checkWinner());
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
    }
    if (score < _point) {
      setState(() {
        _msg = "NOT GONE CUT IT Shooter ${dicePosition + 1}!";
      });
      // _showSnackBar(_msg);
    }
    if (score > _point) {
      setState(() {
        _point = score;
        _pointPosition = [dicePosition];
        _msg = _point > 99
            ? "Shooter ${dicePosition + 1}'s Da Man wit TRIP $_die1's"
            : "Ok Shooter ${dicePosition + 1} You got the Point with $_point";
      });
      // _showSnackBar(_msg);
    }
    _showSnackBar(_msg);
    Timer(Duration(milliseconds: 1500), () => _advanceDicePosition());
  }

  void _scoreRoll(List roll) {
    int scoreDelta;
    bool headcrack = eq(roll, [4, 5, 6]);
    bool crappedOut = eq(roll, [1, 2, 3]);
    if (headcrack) {
      _headCrack();
    } else if (crappedOut) {
      _crapOut();
    } else if (_die1 == _die2 && _die1 == _die3) {
      // Rolled Trips
      scoreDelta = _die1 * 100;
    } else if (_die1 == _die2 || _die1 == _die3 || _die2 == _die3) {
      // Rolled a point
      int point = (roll[0] == roll[1]) ? roll[2] : roll[0];
      scoreDelta = point * 1;
    } else {
      // rolled shit
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
    _scoreRoll(roll);
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.indigo[800],
      duration: Duration(milliseconds: 1000),
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
            background: widget.background,
          ),
          Dice(_die1, _die2, _die3),
          Positioned(
            bottom: 10.0,
            left: 20.0,
            child: SafeArea(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.adjust,
                      size: 60.0,
                      color: getPointColor(_dicePosition),
                    ),
                    Text(
                      "Shooter",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10.0,
            right: 20.0,
            child: SafeArea(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      pointToText(_point),
                      style: TextStyle(
                          color: getPointColor(_pointPosition.length == 0
                              ? 9
                              : _pointPosition[0]),
                          fontSize: 48,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Point",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

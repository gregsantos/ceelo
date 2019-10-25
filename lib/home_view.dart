import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:collection/collection.dart';
import 'dart:math';
import 'dart:async';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'player_bar.dart';
import 'dice_background.dart';
import 'dice.dart';
import 'settings_panel.dart';
import 'utils/point_to_text.dart';
import 'dialog.dart';
import 'status_dialog.dart';
import 'player.dart';

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
      body: SafeArea(
        child: GameView(
            background: isSelected[0] ? 'felt' : 'asphalt', players: 4),
      ),
/*       body: SlidingUpPanel(
        minHeight: 75,
        maxHeight: 200,
        color: Colors.indigo[900],
        slideDirection: SlideDirection.UP,
        backdropEnabled: true,
        collapsed: PlayerBar(),
        panel: SettingsPanel(isSelected, handleSelected),
        body: GameView(background: isSelected[0] ? 'asphalt' : 'felt'),
      ), */
    );
  }
}

class GameView extends StatefulWidget {
  final String background;
  final int players;

  GameView({this.background, this.players});

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  // final int players = 4;
  static final int random = Random().nextInt(3) + 1;
  BuildContext scaffoldContext;
  int _startingPosition = random;
  int _dicePosition = random;
  int _die1 = 4;
  int _die2 = 5;
  int _die3 = 6;
  int _point = 0;
  // List _roll = [];
  List _pointPosition = [];
  List _rollOffQueue = [];
  bool _rollOff = false;
  String _msg = '';
  Function eq = const ListEquality().equals;

  /// Dice Logic
  void _headCrack() {
    // announce and reset winner
    int winner = _dicePosition + 1;
    setState(() {
      _msg = "HEAD CRACK! 4, 5, 6";
    });
    _showEndGameDialog(context, winner, _msg);
  }

  void _crapOut() async {
    print("Dice Position $_dicePosition Crapped Out");
    setState(() {
      _msg = "SEE YA!!!";
    });
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => StatusDialog(
        shooter: _dicePosition,
        title: _msg,
        description: "Shooter ${_dicePosition + 1}\nYOU CAUGHT AN L!",
      ),
    );
    _advanceDicePosition();
  }

  void _rollGarbage() async {
    setState(() {
      _msg = "No dice Shooter ${_dicePosition + 1}";
    });
    try {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => StatusDialog(
          shooter: _dicePosition,
          title: _msg,
          description: "ROLL AGAIN!",
        ),
      );
      print("Dice Position $_dicePosition roll again");
    } catch (e) {
      print("$e");
    }
  }

  void _resetWinner(winnerPosition) {
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
      String winPoint = "${pointToText(_point)}";
      print("Winner Dice Position $_dicePosition with $winPoint");
      // end game
      _showEndGameDialog(context, winner, winPoint);
    } else {
      // roll off
      _showRollOffDialog(context, _rollOffQueue);
    }
  }

  void _showEndGameDialog(context, winner, msg) async {
    int winnerPosition = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: "Winner Shooter $winner",
        winnerPosition: _dicePosition,
        description: "Shooter $winner takes the cake\nwith $msg",
        buttonText: "Play again",
      ),
    );
    print("Winner position $winnerPosition");
    _resetWinner(winnerPosition);
  }

  void _showRollOffDialog(context, players) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: "ROLL OFF!",
        description: "Double down and roll again!\nPlayers ${players.map((p) {
          return p;
        })}",
        buttonText: "Start Roll Off",
      ),
    );
    _resetRollOff();
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
            ? print(
                "ROLL OFF advance dice complete: Dice Position $_dicePosition") // change to return?
            : _advanceDicePosition();
      } else {
        print("advance dice complete: Dice Position $_dicePosition");
      }
    }
  }

  void _compareScore(dicePosition, score) async {
    if (score == _point) {
      setState(() {
        _pointPosition.add(dicePosition);
        _msg = 'ROLL OFF at ${pointToText(_point)}';
      });
    }
    if (score < _point) {
      setState(() {
        _msg = "THAT'S NOT GONE CUT IT";
      });
    }
    if (score > _point) {
      setState(() {
        _point = score;
        _pointPosition = [dicePosition];
        _msg = _point > 99
            ? "You Da Man wit TRIP\n$_die1's"
            : "You got the Point with\n$_point";
      });
    }
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => StatusDialog(
        shooter: _dicePosition,
        title: "Shooter ${dicePosition + 1}",
        description: _msg,
      ),
    );
    print("Point is ${pointToText(_point)}");
    _advanceDicePosition();
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
      // rolled garbage
      _rollGarbage();
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
    return Future.delayed(
      Duration(milliseconds: 1000),
      () => [_die1, _die2, _die3]..sort((a, b) => a.compareTo(b)),
    );
  }

  void handleDiceRoll() async {
    List roll = await rollDice();
    _scoreRoll(roll);
  }

/*   Future<String> _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.indigo[800],
      duration: Duration(milliseconds: 900),
    );
    Scaffold.of(scaffoldContext).showSnackBar(snackBar);
    return Future.delayed(Duration(milliseconds: 1000), () => message);
  } */

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
          // Position 0 top left
          Positioned(
            top: -80.0,
            left: -80.0,
            child: Player(0, _dicePosition, _point, _pointPosition),
          ),
          // point position 0
          Positioned(
            bottom: 50,
            left: 50,
            child: Text(
              _pointPosition.contains(0) ? pointToText(_point) : "",
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Position 1 top right
          Positioned(
            top: -80.0,
            right: -80.0,
            child: Player(1, _dicePosition, _point, _pointPosition),
          ),
          // point position 1
          Positioned(
            bottom: 50,
            left: 50,
            child: Text(
              _pointPosition.contains(1) ? pointToText(_point) : "",
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Position 2 bottom right
          Positioned(
            right: -80.0,
            bottom: -80.0,
            child: Player(2, _dicePosition, _point, _pointPosition),
          ),
          // point position 2
          Positioned(
            // "top: ${playerPosition + 79}, right: ${playerPosition + 89}",
            bottom: 50,
            right: 50,
            child: Text(
              _pointPosition.contains(2) ? pointToText(_point) : "",
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Position 3 bottom left
          Positioned(
            left: -80.0,
            bottom: -80.0,
            child: Player(3, _dicePosition, _point, _pointPosition),
          ),
          // point position 3
          Positioned(
            bottom: 50,
            left: 50,
            child: Text(
              _pointPosition.contains(3) ? pointToText(_point) : "",
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Dice(_die1, _die2, _die3),
        ],
      ),
    );
  }
}

enum PlayerPosition {
  topLeft,
  topRight,
  bottomRight,
  bottomLeft,
}

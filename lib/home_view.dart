import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'dart:math';
import 'dart:async';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flushbar/flushbar.dart';
import 'player_bar.dart';
import 'dice_background.dart';
import 'dice_column.dart';
import 'dice_row.dart';

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

class GameView extends StatelessWidget {
  final String backgroundImage = 'asphalt';

  @override
  Widget build(BuildContext context) {
    return DiceView(
      backgroundImage: backgroundImage,
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
      _msg = 'HEAD CRACK! WINNER SHOOTER ${_dicePosition + 1}';
    });
    _showSnackBar(_msg);
    Timer(Duration(milliseconds: 2000), () => _resetPoint());
  }

  void _crapOut() {
    setState(() {
      _msg = 'CRAPS YOU LOSE!';
    });
    print('CRAP OUT');
    _showSnackBar(_msg);
    Timer(Duration(milliseconds: 2100), () => _advanceDicePosition());
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
      String _winMsg =
          _point > 99 ? "WINS with TRIP ${_point / 100}'" : "Wins with $_point";
      setState(() {
        _msg = 'Shooter ${_pointPosition[0] + 1} $_winMsg';
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
      Timer(Duration(milliseconds: 2100),
          () => _showSnackBar("Your roll shooter ${newDicePosition + 1}"));
    }
  }

  void _compareScore(shooter, score) {
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
        _msg = "NOT GONE CUT IT Shooter ${shooter + 1}! Next Shooter!";
      });
      _showSnackBar(_msg);
    }
    if (score > _point) {
      setState(() {
        _point = score;
        _pointPosition = [_dicePosition];
        _msg = 'Point is $_point! YOU DA MAN Shooter ${shooter + 1}';
      });
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

  void _scoreDice() {
    setState(() {
      _roll = [_die1, _die2, _die3]..sort((a, b) => a.compareTo(b));
    });
    _scoreRoll();
  }

  void _setDice() {
    setState(() {
      _die1 = Random().nextInt(6) + 1;
      _die2 = Random().nextInt(6) + 1;
      _die3 = Random().nextInt(6) + 1;
    });
  }

  Future<void> shakeDice() {
    // Imagine that this function is
    // more complex and slow.
    int random = Random().nextInt((9 - 3) + 3);
    for (var i = random; i >= 1; i--) {
      var wait = Random().nextInt(5) * 100;
      Timer(Duration(milliseconds: wait), () => _setDice());
    }
    return Future.delayed(Duration(milliseconds: 1500), () => {});
  }

  void handleDiceRoll() async {
    await shakeDice();
    _scoreDice();
  }

  void _showSnackBar(String message) {
/*     final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.indigo,
      duration: Duration(seconds: 1),
    );
    Scaffold.of(scaffoldContext).showSnackBar(snackBar); */
    Flushbar(
      title: "Shooter ${_dicePosition + 1}",
      message: "$message",
      duration: Duration(seconds: 2),
    )..show(scaffoldContext);
  }

  @override
  Widget build(BuildContext context) {
    scaffoldContext = context;
    return GestureDetector(
      onTap: () => handleDiceRoll(),
      child: Stack(
        children: [
          DiceBackground(background: widget.backgroundImage, point: _point),
          SafeArea(
            child: Dice(_die1, _die2, _die3, _dicePosition),
          )
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

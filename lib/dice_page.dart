import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'dart:math';
import 'build_dice.dart';

class DicePage extends StatefulWidget {
  final int players;

  DicePage({Key key, this.players = 4}) : super(key: key);

  @override
  _DicePageState createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
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
    return Scaffold(
      backgroundColor: Colors.grey[400],
/*       appBar: AppBar(
        title: Text('Shooter: ${_dicePosition + 1}  ---  Point: $_point'),
      ), */
      body: SafeArea(
        child: GestureDetector(
          onTap: () => _rollEm(),
          child: LayoutBuilder(builder: (BuildContext context, constrain) {
            scaffoldContext = context;
            if (constrain.maxWidth < 400) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ...buildDice(_die1, _die2, _die3, _dicePosition)
                  ]);
            } else {
              return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ...buildDice(_die1, _die2, _die3, _dicePosition)
                  ]);
            }
          }),
        ),
      ),
    );
  }
}

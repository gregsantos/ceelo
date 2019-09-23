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
  List _pointPosition = [];
  List _roll = [];
  List _out = [];
  String _msg = 'Come out Roll!';
  Function eq = const ListEquality().equals;

  void _resetPoint() {
    setState(() {
      _startingPosition = _dicePosition;
      _point = 0;
      _pointPosition = [];
      _out = [];
      _msg = 'Come out Roll!';
    });
    _showSnackBar(_msg);
  }

  void _checkWinner() {
    print(_pointPosition);
  }

  void _advanceDicePosition() {
    int newDicePosition = (_dicePosition == 3) ? 0 : ++_dicePosition;
    if (newDicePosition == _startingPosition) {
      _checkWinner();
    } else {
      setState(() {
        _dicePosition = newDicePosition;
      });
    }
  }

  void _headCrack() {
    print('HEAD CRACK');
    setState(() {
      _msg = 'HEAD CRACK!';
    });
    _showSnackBar(_msg);
    _resetPoint();
  }

  void _crapOut() {
    print('CRAP OUT');
    setState(() {
      _out.add(_dicePosition);
      _msg = 'YOU LOSE!';
    });
    _showSnackBar(_msg);
    _advanceDicePosition();
  }

  void _scoreRoll() {
    if (_roll.length == 3) {
      print(_roll);
    }
    bool headcrack = eq(_roll, [4, 5, 6]);
    bool crappedOut = eq(_roll, [1, 2, 3]);
    if (headcrack) {
      _headCrack();
    } else if (crappedOut) {
      _crapOut();
    } else if (_die1 == _die2 && _die1 == _die3) {
      print('Trip $_die1');
      setState(() {
        _msg = 'YOU ROLLED TRIP $_die1';
        _point = _die1 * 100;
      });
      _showSnackBar(_msg);
    } else if (_die1 == _die2 || _die1 == _die3 || _die2 == _die3) {
      int point = (_roll[0] == _roll[1]) ? _roll[2] : _roll[0];
      print('Point made: $point');
      setState(() {
        _point = point;
        _msg = 'YOU ROLLED $point';
      });
      _showSnackBar(_msg);
      _advanceDicePosition();
    } else {
      print('Roll again!');
      setState(() {
        _msg = 'Roll again!';
      });
      _showSnackBar(_msg);
    }
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

  void _rollEm() {
    setState(() {
      _die1 = Random().nextInt(6) + 1;
      _die2 = Random().nextInt(6) + 1;
      _die3 = Random().nextInt(6) + 1;
      _roll = [_die1, _die2, _die3]..sort((a, b) => a.compareTo(b));
    });
    _scoreRoll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: Text('Shooter: ${_dicePosition + 1}  ---  Point: $_point'),
      ),
      body: FlatButton(
        onPressed: () {
          _rollEm();
        },
        child: LayoutBuilder(builder: (BuildContext context, constrain) {
          scaffoldContext = context;
          if (constrain.maxWidth < 400) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[...buildDice(_die1, _die2, _die3)]);
          } else {
            return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[...buildDice(_die1, _die2, _die3)]);
          }
        }),
      ),
    );
  }
}

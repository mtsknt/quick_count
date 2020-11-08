import 'dart:async';

import '../answers.dart';
import '../utils/playAudio.dart';
import '../utils/sharedPref.dart';
import '../models/users.dart';
import 'package:flutter/material.dart';
import 'package:quiver/async.dart';

class PlayPage extends StatefulWidget {
  PlayPage({
    Key key,
    this.selectedMode,
    this.currentUser,
    this.users,
  }) : super(key: key);

  final String selectedMode;
  final User currentUser;
  final List<User> users;

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  double _passed = 0;
  bool _isGameFinished = false;
  bool _isGameFailed = false;
  SharedPref sharedPref = SharedPref();
  int _targetIndex = 0;
  int _pushedIndex;
  List<dynamic> _answer;
  Widget gameField;
  Audio audio = Audio();

  @override
  void initState() {
    super.initState();
    _answer = getAnswer(widget.selectedMode);
    gameField = GameField(
      answer: _answer,
      onGetIndex: (int index) {
        setState(() {
          _pushedIndex = index;
        });
        _isCorrect();
      },
    );
    _startTimer();
    audio.playLocal('start.mp3');
  }

  Container _buildHelpMessage(String message) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        message,
        style: TextStyle(fontSize: 24),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _isCorrect() {
    if (_isGameFinished == false) {
      if (_targetIndex == _pushedIndex) {
        _targetIndex += 1;
        audio.playLocal('good.mp3');

        if (_targetIndex >= _answer.length) {
          _isGameFinished = true;
          _savetime();
        }
      } else {
        setState(() {
          _isGameFinished = true;
          _isGameFailed = true;
          audio.playLocal('failed.mp3');
        });
      }
    }
  }

  void _savetime() {
    List<User> users = widget.users;

    users = users.map((user) {
      if (user.name == widget.currentUser.name) {
        if (widget.selectedMode == '1-30') {
          if (user.time_num > _passed || user.time_num == 0.0) {
            user.time_num = _passed;
          }
        } else if (widget.selectedMode == 'a-z') {
          if (user.time_az > _passed || user.time_az == 0.0) {
            user.time_az = _passed;
          }
        } else if (widget.selectedMode == 'A-Z') {
          if (user.time_AZ > _passed || user.time_AZ == 0.0) {
            user.time_AZ = _passed;
          }
        }
      }
      return user;
    }).toList();

    List<String> usersList = users.map((user) => user.toJson()).toList();
    sharedPref.saveList('users', usersList);
  }

  void _startTimer() {
    CountdownTimer timer = new CountdownTimer(
      new Duration(milliseconds: 99999),
      new Duration(milliseconds: 1),
    );

    StreamSubscription<CountdownTimer> subscription = timer.listen(null);

    subscription.onData((event) {
      setState(() {
        _passed = (event.elapsed.inMilliseconds / 1000.0);
      });
      if (_isGameFinished == true) {
        subscription?.pause();
        subscription.cancel();
      }
    });

    subscription.onDone(() {
      _passed = 99.99;
      _isGameFinished = true;
      _isGameFailed = true;
      subscription.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget navigatorSection = Container(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            _passed.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 32,
            ),
          ),
          FlatButton(
            child: Text(
              'QUIT',
              style: TextStyle(
                fontSize: 32,
              ),
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Column(
        children: [
          navigatorSection,
          if (_isGameFinished == false)
            _buildHelpMessage(_answer[_targetIndex].toString()),
          if (_isGameFinished == true) ...[
            if (_isGameFailed == false) _buildHelpMessage('Congratulations!'),
            if (_isGameFailed == true) _buildHelpMessage('Game Over!'),
          ],
          gameField,
        ],
      ),
    );
  }
}

class GameField extends StatelessWidget {
  final List<dynamic> answer;
  final Function(int) onGetIndex;
  GameField({this.answer, this.onGetIndex});

  int _count = 0;
  List<int> _randomIndex = [for (var i = 0; i < 30; i += 1) i]..shuffle();

  Text _setChar() {
    int index = _randomIndex[_count];
    String char = '';

    if (answer.length >= (index + 1)) {
      char = answer[index].toString();
    }
    _count += 1;
    return Text(char);
  }

  Expanded _buildGameField() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonsColumn(),
          _buildButtonsColumn(),
          _buildButtonsColumn(),
          _buildButtonsColumn(),
          _buildButtonsColumn(),
          _buildButtonsColumn(),
        ],
      ),
    );
  }

  Row _buildButtonsColumn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildGameButton(),
        _buildGameButton(),
        _buildGameButton(),
        _buildGameButton(),
        _buildGameButton(),
      ],
    );
  }

  SizedBox _buildGameButton() {
    int index = _count;
    Text txt = _setChar();

    if (txt.data != '') {
      return SizedBox(
        width: 60,
        height: 60,
        child: FlatButton(
          child: txt,
          color: Colors.white,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            onGetIndex(_randomIndex[index]);
          },
        ),
      );
    } else {
      return SizedBox(
        width: 60,
        height: 60,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildGameField();
  }
}

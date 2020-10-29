import 'dart:async';

import 'package:flutter/material.dart';
import 'playAudio.dart';
import 'playPage.dart';
import 'sharedPref.dart';
import 'users.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedMode = '';
  User _currentUser = User(name: '');
  List<User> users = [];
  SharedPref sharedPref = SharedPref();
  final buttonPadding = EdgeInsets.only(top: 16, bottom: 16);
  var debug;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    List<String> usersList = await sharedPref.readList('users');

    if (usersList != null) {
      users = usersList.map((json) => User.fromJson(json)).toList();
    }
  }

  _searchUser(String name) async {
    User searchedUser =
        users.firstWhere((user) => user.name == name, orElse: () => null);

    setState(() {
      if (searchedUser != null) {
        _currentUser = searchedUser;
      } else {
        User newUser = User(name: name, time_num: 0, time_az: 0, time_AZ: 0);
        _currentUser = newUser;
        users.add(newUser);
      }
      debug = users.map((user) => user.toJson()).toList();
    });
  }

  void _setSelectedMode(String selectedMode) {
    setState(() {
      _selectedMode = selectedMode;
    });
  }

  FutureOr onGoBack(dynamic value) {
    _fetchUserData();
    setState(() {
      _currentUser = users.firstWhere((user) => user.name == _currentUser.name,
          orElse: () => null);
    });
  }

  void _playGame(String selectedMode, User currentUser, List<User> users) {
    if (selectedMode == '') {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return PlayPage(
              selectedMode: selectedMode,
              currentUser: currentUser,
              users: users);
        },
      ),
    ).then(onGoBack);
  }

  Column _buildScoreColumn(String playMode, String time) {
    return Column(
      children: [
        Text(playMode),
        if (time != '0.00') Text(time),
        if (time == '0.00') Text('---'),
      ],
    );
  }

  Audio audio = Audio();

  FlatButton _buildSelectButton(String playMode, String selectedMode) {
    Color color = (selectedMode == playMode) ? Colors.red : Colors.pink[200];

    return FlatButton(
      child: Text(playMode),
      color: color,
      padding: buttonPadding,
      onPressed: () {
        _setSelectedMode(playMode);
        audio.playLocal('select.mp3');
      },
    );
  }

  Widget build(BuildContext context) {
    Widget scoreSection = Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (_currentUser.name == '') ...[
            _buildScoreColumn('1-30', '---'),
            _buildScoreColumn('A-Z', '---'),
            _buildScoreColumn('a-z', '---'),
          ] else ...[
            _buildScoreColumn('1-30', _currentUser.time_num.toStringAsFixed(2)),
            _buildScoreColumn('A-Z', _currentUser.time_AZ.toStringAsFixed(2)),
            _buildScoreColumn('a-z', _currentUser.time_az.toStringAsFixed(2)),
          ],
        ],
      ),
    );

    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Text(
          'Quick\nCountre',
          style: TextStyle(
            fontSize: 32,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );

    Widget nameFieldSection = Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: new TextField(
        // enabled: true,
        decoration: const InputDecoration(
          fillColor: Colors.white,
          filled: true,
          labelText: 'Enter Nickname...',
        ),
        onSubmitted: _searchUser,
      ),
    );

    Widget selectPlayModeSection = Container(
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSelectButton('1-30', _selectedMode),
          _buildSelectButton('A-Z', _selectedMode),
          _buildSelectButton('a-z', _selectedMode),
        ],
      ),
    );

    Widget playButtonSection = Container(
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Row(children: [
        Expanded(
          child: FlatButton(
            child: Text('PLAY!'),
            color: Colors.pink[200],
            padding: buttonPadding,
            onPressed: () {
              _playGame(_selectedMode, _currentUser, users);
            },
          ),
        ),
      ]),
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.pink[50],
          // image: DecorationImage(
          //   image: AssetImage('images/lake.jpg'),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: Column(
          children: [
            scoreSection,
            titleSection,
            nameFieldSection,
            if (_currentUser.name != '') ...[
              selectPlayModeSection,
              playButtonSection,
            ],
          ],
        ),
      ),
    );
  }
}

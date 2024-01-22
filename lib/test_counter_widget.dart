import 'dart:async';

import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  TimerWidget({Key? key}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer _timer;
  int _counter = 0;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _tick() {
    setState(() {
      _counter++;
    });
  }

  void _startOrPauseTimer() {
    setState(() {
      _isRunning = !_isRunning;
    });
    if (_isRunning) {
      _timer = Timer.periodic(Duration(seconds: 1), (_) => _tick());
    } else {
      _timer.cancel();
    }
  }

  void _resetTimer() {
    setState(() {
      _counter = 0;
      _isRunning = false;
    });
    _timer.cancel();
  }

  String get _formattedTime {
    final seconds = _counter % 60;
    final minutes = _counter ~/ 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('计时器'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _formattedTime,
              style: TextStyle(fontSize: 64),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: Text('重置'),
                ),
                SizedBox(width: 30),
                ElevatedButton(
                  onPressed: _startOrPauseTimer,
                  child: Text(_isRunning ? '暂停' : '开始'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

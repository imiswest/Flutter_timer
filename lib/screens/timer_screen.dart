import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sprintf/sprintf.dart';


enum TimerStatus {running, paused, stopped, resting}

class TimerScreen extends StatefulWidget {
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  static const WORK_SECONDS = 25;
  static const REST_SECONDS = 5;

  late TimerStatus _timerStatus;
  late int _timer;
  late int _pomodoroCount;

  String secondsToString(int seconds) {
    return sprintf('%02d:%02d', [seconds ~/ 60, seconds % 60]);
  }

  @override
  void initState() {
    super.initState();
    _timerStatus = TimerStatus.stopped;
    print(_timerStatus.toString());
    _timer = WORK_SECONDS;
    _pomodoroCount = 0;
  }

  //이벤트 5개
  void run() {
    setState(() {
      _timerStatus = TimerStatus.running;
      print('[=>]' + _timerStatus.toString());
      runTimer();
    });
  }

  void rest() {
    setState(() {
      _timerStatus = TimerStatus.resting;
      _timer = REST_SECONDS;
      print('[=>]' + _timerStatus.toString());
    });
  }

  void pause() {
    setState(() {
      _timerStatus = TimerStatus.paused;
      print('[=>]' + _timerStatus.toString());
    });
  }

  void resume() {
    setState(() {
      run();
    });
  }

  void stop() {
    setState(() {
      _timerStatus = TimerStatus.stopped;
      _timer = WORK_SECONDS;
      print('[=>]' + _timerStatus.toString());
    });
  }

  void runTimer() async {
    Timer.periodic(Duration(seconds: 1), (Timer t){
      switch (_timerStatus) {
        case TimerStatus.paused:
          t.cancel();
          break;
        case TimerStatus.stopped:
          t.cancel();
          break;
        case TimerStatus.running:
          if (_timer <= 0) {
            showToast('작업 완료!');
            rest();
          } else {
            setState(() {
              _timer -= 1;
            });
          }
          break;
        case TimerStatus.resting:
          if (_timer <= 0) {
            setState(() {
              _pomodoroCount += 1;
            });
            showToast('오늘 $_pomodoroCount개의 뽀모도로를 달성했습니다.');
            t.cancel();
            stop();
          } else {
            setState(() {
              _timer -= 1;
            });
          }
          break;
        default:
          break;
      }
    });
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  @override
  Widget build(BuildContext context) {
    final List<Widget> _runningButtons = [
      ElevatedButton(
        child: Text(
          _timerStatus == TimerStatus.paused ? '계속하기' : '일시정지',
          //일시정지 중? 계속하기 : 일시정지
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(primary: Colors.yellow),
        onPressed: _timerStatus == TimerStatus.paused ? resume : pause,
      ),
      Padding(padding: EdgeInsets.all(20)),
      ElevatedButton(
        child: Text(
          '포기하기',
          style: TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(primary: Colors.grey),
        onPressed: stop,
      ),
    ];

    final List<Widget> _stoppedButtons = [
      ElevatedButton(
        child: Text(
          '시작하기',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _timerStatus == TimerStatus.resting
              ? Colors.green
              : Colors.yellow, //휴식중? 녹색 : 파란색
        ),
        onPressed: run,
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('뽀모도로 타이머 앱'),
        backgroundColor:
        _timerStatus == TimerStatus.resting ? Colors.green : Colors.yellow,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Center(
              child: Text(
                secondsToString(_timer),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _timerStatus == TimerStatus.resting
                  ? Colors.green
                  : Colors.yellow, // 휴식중? 녹색 : 파란색
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _timerStatus == TimerStatus.resting //휴식중? 버튼없음 : 버튼 있음
                ? const []
                : _timerStatus == TimerStatus.stopped //정지? 정지 중 버튼 : 작업 중 버튼
                ? _stoppedButtons
                : _runningButtons,
          )
        ],
      ),
    );
  }

}
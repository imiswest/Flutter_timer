import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:fluttertoast/fluttertoast.dart';

///상태란? 화면에 나타나는 변수 중 지속적으로 변하는 데이터

enum TimerStatus {
  running,
  paused,
  stopped,
  resting
} //TimerStatus라는 자료형이 가질 수 있는 값들을 정의

class TimerScreen extends StatefulWidget {
  _TimerScreenState createState() => _TimerScreenState();
  // StatefulWidget 클래스 내에서는 createState()라는 메서드 사용. 내부에서 사용할 State를 생성.
  // createState를 통해 상태를 생성
}

/// <삼항연산자>  조건 ? 참일때 실행할 문장 : 거짓일때 실행할 문장

class _TimerScreenState extends State<TimerScreen> {
  //State(플러터 자체 내부 클래스)를 상속하는 클래스
  ///변수 3개 ; 타이머의 시간 / 타이머의 상태(Status) / 뽀모도로의 개수
  static const WORK_SECONDS = 25;
  static const REST_SECONDS = 5;

  late TimerStatus _timerStatus; //late는 초기값을 설정해야하는 변수의 초기화를 나중에 하겠다는 키워드
  late int _timer;
  late int _pomodoroCount;

  @override
  void initState() {
    super.initState();
    _timerStatus = TimerStatus.stopped;
    print(_timerStatus.toString());
    _timer = WORK_SECONDS;
    _pomodoroCount = 0;
  }

  String secondsToString(int seconds) {
    return sprintf('%02d:%02d', [seconds ~/ 60, seconds % 60]);
  }

  ///이벤트 5개 ; 메서드의 형태로 구현
  void run() {
    //이벤트1
    setState(() {
      _timerStatus = TimerStatus.running;
      print('[=>]' + _timerStatus.toString());
      runTimer();
    });
  }

  void rest() {
    //이벤트2
    setState(() {
      _timer = REST_SECONDS;
      _timerStatus = TimerStatus.resting;
      print('[=>]' + _timerStatus.toString());
    });
  }

  void pause() {
    //이벤트3
    setState(() {
      _timerStatus = TimerStatus.paused;
      print("[=>]" + _timerStatus.toString());
    });
  }

  void resume() {
    //이벤트4
    setState(() {
      run();
    });
  }

  void stop() {
    //이벤트5
    setState(() {
      _timer = WORK_SECONDS;
      _timerStatus = TimerStatus.stopped;
      print('[=>]' + _timerStatus.toString());
    });
  }

  void runTimer() async {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
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
        style: ElevatedButton.styleFrom(primary: Colors.blue),
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
              : Colors.blue, //휴식중? 녹색 : 파란색
        ),
        onPressed: run,
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('뽀모도로 타이머 앱'),
        backgroundColor:
            _timerStatus == TimerStatus.resting ? Colors.green : Colors.blue,
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
                  : Colors.blue, // 휴식중? 녹색 : 파란색
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

import 'package:flutter/material.dart';

///상태란? 화면에 나타나는 변수 중 지속적으로 변하는 데이터

enum TimerStatus {running, paused, stopped, resting} //TimerStatus라는 자료형이 가질 수 있는 값들을 정의

class TimerScreen extends StatefulWidget {
  @override //여기 override 굳이 왜 하는거지?
  _TimerScreenState createState() => _TimerScreenState();
  // StatefulWidget 클래스 내에서는 createState()라는 메서드 사용. 내부에서 사용할 State를 생성.
  // createState를 통해 상태를 생성
}

/// <삼항연산자>  조건 ? 참일때 실행할 문장 : 거짓일때 실행할 문장

class _TimerScreenState extends State<TimerScreen> { //State(플러터 자체 내부 클래스)를 상속하는 클래스
  ///변수 3개 ; 타이머의 시간 / 타이머의 상태(Status) / 뽀모도로의 개수

  static const WORK_SECONDS = 25;
  static const REST_SECONDS =5;

  late TimerStatus _timerStatus; //late는 초기값을 설정해야하는 변수의 초기화를 나중에 하겠다는 키워드
  late int _timer;
  late int _pomodoroCount;

  @override
  void initState() { //초기값 설정
    super.initState();
    _timerStatus = TimerStatus.stopped; //timer의 초기 상태 : 정지
    print(_timerStatus.toString());
    _timer = WORK_SECONDS; //남은 타이머 시간
    _pomodoroCount = 0; //뽀모도로 개수
  }

  Widget build(BuildContext context) {
    final List<Widget> _runningButtons = [
      ElevatedButton(
        child: Text(
          1 == 2 ? '계속하기' : '일시정지', //일시정지 중? 계속하기 : 일시정지
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(primary: Colors.blue),
        onPressed: () {},
      ),

      Padding(padding: EdgeInsets.all(20)),

      ElevatedButton(
        child: Text('포기하기',
          style: TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(primary: Colors.grey),
        onPressed: () {},
      ),
    ];

    final List<Widget> _stoppedButtons = [
      ElevatedButton(
        child: Text(
          '시작하기',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          primary: 1 == 2 ? Colors.green : Colors.blue, //휴식중? 녹색 : 파란색
        ),
        onPressed: () {},
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('뽀모도로 타이머'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Center(
              child: Text(
                '00:00',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: 1 == 2 ? Colors.green : Colors.blue, // 휴식중? 녹색 : 파란색
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: 1 == 2 //휴식중? 버튼없음 : 버튼 있음
                ? const []
                : 1 == 2 //정지? 정지 중 버튼 : 작업 중 버튼
                    ? _stoppedButtons
                    : _runningButtons,
          )
        ],
      ),
    );
  }
}

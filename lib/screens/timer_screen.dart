import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

/// <삼항연산자>  조건 ? 참일때 실행할 문장 : 거짓일때 실행할 문장

class _TimerScreenState extends State<TimerScreen> {
  @override
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
        child: Text(
          '포기하기',
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

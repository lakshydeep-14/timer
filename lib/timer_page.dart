import 'dart:async';

import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  OtpFieldController hourController = OtpFieldController();
  OtpFieldController minuteController = OtpFieldController();
  OtpFieldController secondController = OtpFieldController();
  int? hh, mm, ss;
  Timer? countdownTimer;
  Duration myDuration = const Duration(hours: 0, minutes: 0, seconds: 0);
  @override
  void initState() {
    super.initState();
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');

    final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$hours:$minutes:$seconds',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 50),
          ),
          timeInput(
              controller: hourController,
              text: 'HH',
              oncompleted: (a) {
                setState(() {
                  hh = int.parse(a);
                  minuteController.setFocus(0);
                });
              }),
          timeInput(
              text: 'MM',
              controller: minuteController,
              oncompleted: (a) {
                setState(() {
                  mm = int.parse(a);
                  secondController.setFocus(0);
                });
              }),
          timeInput(
              text: 'SS',
              controller: secondController,
              oncompleted: (a) {
                setState(() {
                  ss = int.parse(a);
                  //secondController.setFocus(0);
                });
              }),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                if (hh != null && mm != null && ss != null) {
                  setState(() {
                    myDuration =
                        Duration(hours: hh!, minutes: mm!, seconds: ss!);
                  });
                  startTimer();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Time Format not match")));
                }
              },
              child: const Text("Start Timer"))
        ],
      ),
    );
  }

  Widget timeInput(
      {required OtpFieldController controller,
      required Function(String)? oncompleted,
      required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 150,
            child: OTPTextField(
                controller: controller,
                length: 2,
                width: MediaQuery.of(context).size.width,
                fieldWidth: 50,
                style: const TextStyle(fontSize: 17),
                textFieldAlignment: MainAxisAlignment.spaceBetween,
                fieldStyle: FieldStyle.underline,
                onCompleted: oncompleted),
          ),
          Text(
            '  ' + text,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 40),
          )
        ],
      ),
    );
  }
}

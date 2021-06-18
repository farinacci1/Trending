

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trending/notifiers/pinNotifier.dart';
class CountDownClock extends StatefulWidget {
  final int duration;

  CountDownClock(this.duration);
  @override _ClockState createState() => _ClockState();

}

class _ClockState extends State<CountDownClock> {
  Timer _timer;
  int countDown = 0;
  void startTimer() {
    countDown = widget.duration;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (countDown == 0) {
          Provider.of<PinNotifier>(context,listen: false).isTimeLimitExpired = true;
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            countDown--;
          });
        }
      },
    );
  }
  @override
  void initState() {
    startTimer();
    super.initState();
  }
  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
         FaIcon(FontAwesomeIcons.hourglass, size: 30,color:Colors.black),
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              border: Border.all(color: Colors.black)
          ),
        ),
        Text("$countDown", style: TextStyle(fontSize: 14, color: Colors.blue),),
      ],
    );
  }

}
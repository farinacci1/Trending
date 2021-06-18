import 'package:flutter/cupertino.dart';

class PinNotifier with ChangeNotifier{

  bool timeLimitExpired = false;

  set isTimeLimitExpired(bool tle) {timeLimitExpired = tle; notifyListeners();}
  bool get isTimeLimitExpired => timeLimitExpired;
}
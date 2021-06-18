import 'package:flutter/cupertino.dart';

class UserNotifier with ChangeNotifier{

  String userId ="";

  set user(String uid){
    userId = uid;notifyListeners();
  }
  String get user => userId;

}
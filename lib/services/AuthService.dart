


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:trending/notifiers/pinNotifier.dart';
import 'package:trending/notifiers/userNotifier.dart';
import 'package:trending/phone/pinCode.dart';
import 'package:trending/views/Home.dart';

import '../main.dart';
import 'DatabaseService.dart';
import 'package:trending/views/accountInit.dart';

class Authenticator {
  final FirebaseAuth _fbAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  Future<void> signInWithGoogle(BuildContext context)async{
    final GoogleSignInAccount googleUser = (await _googleSignIn.signIn());
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    UserCredential userDetails = await _fbAuth.signInWithCredential(credential);
    User user = userDetails.user;
    user == null ? Provider.of<UserNotifier>(context,listen: false).user = "" : Provider.of<UserNotifier>(context,listen: false).user = user.uid;
    if(user != null ){
      bool exists = await DatabaseService().isUserExist(user.uid);
      if(exists){
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>Home()));
      }else{
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => AccountInit()));
      }
    }
  }
  Future<void> confirmMobile(BuildContext context, String phoneNum)async {

    await _fbAuth.verifyPhoneNumber(
      phoneNumber: phoneNum,
      verificationCompleted: (PhoneAuthCredential credential) {  },
      verificationFailed: (FirebaseAuthException e) {print(e);},
      codeSent: (String verificationId, [int resendToken]) async {
        Provider.of<PinNotifier>(context,listen: false).isTimeLimitExpired = false;
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(
          builder: (context) =>
          PinCodeVerificationScreen(
              phoneNum,60,verificationId)));

          },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: Duration(seconds: 60)
    );
  }
  Future<void> retryMobile(BuildContext context,String phoneNum)async {
    await _fbAuth.verifyPhoneNumber(
        phoneNumber: phoneNum,
        verificationCompleted: (PhoneAuthCredential credential) {  },
        verificationFailed: (FirebaseAuthException e) {print(e);},
        codeSent: (String verificationId, [int resendToken]) async {
          Provider.of<PinNotifier>(context,listen: false).isTimeLimitExpired = false;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PinCodeVerificationScreen(
                          phoneNum,60,verificationId)));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: Duration(seconds: 60)
    );
  }
  Future<void> logout(BuildContext context)async {
    await _fbAuth.signOut();
    Provider.of<UserNotifier>(context,listen: false).user = "";
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>LoginScreen()));
  }

}
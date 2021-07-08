import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trending/notifiers/userNotifier.dart';
import 'package:trending/notifiers/eventNotifier.dart';
import 'package:trending/phone/phoneInput.dart';
import 'package:trending/services/AuthService.dart';
import 'package:trending/services/DatabaseService.dart';
import 'package:trending/views/accountInit.dart';
import 'package:trending/views/Home.dart';
import 'notifiers/postNotifier.dart';
import 'notifiers/pinNotifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<UserNotifier>(create:(_) => UserNotifier()),
          ChangeNotifierProvider<PinNotifier>(create:(_) => PinNotifier()),
          ChangeNotifierProvider<EventNotifier>(create:(_) => EventNotifier()),
          ChangeNotifierProvider<PostNotifier>(create:(_) => PostNotifier())
    ],
        child: MaterialApp(
      title: 'Whats Trending',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    ));
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Timer _timer;

  @override void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    _timer = new Timer(const Duration(milliseconds: 1000), ()  {
      if(FirebaseAuth.instance.currentUser != null) {
         DatabaseService().isUserExist(FirebaseAuth.instance.currentUser.uid).then((exists) {
           if(exists)Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>Home()));
           else Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AccountInit()));
         });
      }
    });

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 80, 0, 70),
            child: Image(
                image: AssetImage('rss/logo.png'),
                fit: BoxFit.cover,
                height: 256),
          ),
          Text(
            "-- Sign in with -- ",
            style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                decoration: TextDecoration.none),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                      width: 270,
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed: () {Authenticator().signInWithGoogle(this.context);},
                        icon: FaIcon(FontAwesomeIcons.google,size: 24.0,color: Colors.white,),
                        label: Text("Google"),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            elevation: 5.0,
                            shadowColor: Colors.white),
                      )),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "or",
                      style: TextStyle(
                          fontSize: 11.0,
                          color: Colors.white,
                          decoration: TextDecoration.none),
                    ),
                  ),
                  SizedBox(
                      width: 270,
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed: () {Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>PhonePrompt()));},
                        icon: Icon(Icons.phone,color: Colors.white,size: 24.0,),
                        label: Text('Phone Number',style: TextStyle(color: Colors.white),),

                        style: ElevatedButton.styleFrom(
                            primary: Colors.purple,
                            elevation: 5.0,
                            shadowColor: Colors.white),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

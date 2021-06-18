import 'dart:io';

import 'package:avatar_view/avatar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trending/notifiers/userNotifier.dart';
import 'package:trending/services/DatabaseService.dart';
import 'package:provider/provider.dart';
import 'package:trending/views/Home.dart';

class AccountInit extends StatefulWidget {
  @override
  _AccountInitState createState() => _AccountInitState();
}

class _AccountInitState extends State<AccountInit> {
  TextEditingController _displayNameController = TextEditingController();
  File _image;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: true);
    if(userNotifier.userId == "")  Provider.of<UserNotifier>(context, listen: false).userId = FirebaseAuth.instance.currentUser.uid;
    return Scaffold(
      backgroundColor: Colors.black87,
        body: StreamBuilder(
      stream: DatabaseService().getUniqueUsernames(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.symmetric(horizontal: 10),child:
            TextField(
              controller: _displayNameController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: InputDecoration(
                  hintText: "display name",

                  fillColor: Colors.white,
                  filled: true,
                  counterText: "",
                  labelText: "User's Display Name"),
            ),),
            Container(margin: EdgeInsets.symmetric(vertical: 14),width: 80,height: 80,child:
            AvatarView(
              borderWidth: 1,
                borderColor: Colors.white,
                radius: 60,
                avatarType: AvatarType.CIRCLE,
                backgroundColor: Colors.black,
                onTap: () {
                  getImage();
                },
                imagePath: _image != null ? _image.path : 'rss/profile.png'),),
            Container(width: double.infinity,child:
            ElevatedButton(
              onPressed: () async {
                String name = _displayNameController.value.text;
                int length = name.length;
                final pattern = RegExp('\\s+');
                name = name.replaceAll(pattern, "");
                if (length != name.length) {
                  print("name can not include whitespaces");
                }else if(length < 8){
                  print("display name requires at least 6 char");
                }else {
                  DocumentSnapshot data = snapshot.data;
                  if (data != null) {
                    Map<String, dynamic> values = data.data();
                    if (values != null && values.isNotEmpty) {
                      List<dynamic> usedNames = values['uniqueNames'];
                      if (usedNames.contains(name)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Username already taken!"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        //create user
                        await DatabaseService()
                            .createUser(userNotifier.userId, name, _image);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home()));

                      }
                    }
                  }
                }
              },
              child: Text("Submit"),
            ))
          ],
        );
      },
    ));
  }
}

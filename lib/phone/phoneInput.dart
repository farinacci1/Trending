
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:trending/services/AuthService.dart';

class PhonePrompt extends StatefulWidget {
  @override
  PhonePromptState createState() => PhonePromptState();
}

class PhonePromptState extends State<PhonePrompt> {
  String _phoneNum = "";
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 50, bottom: 20, left: 10, right: 20),
            child: IntlPhoneField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              initialCountryCode: 'US',
              onChanged: (phone) {
                setState(() {
                  _phoneNum = phone.completeNumber;
                });
              },
            ),
          ),
          Container(
              width: double.infinity,
              height: 40,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                      onPressed: () async{
                          await Authenticator().confirmMobile(context,_phoneNum);
                      },
                      child: Text("Verify")))),
        ],
      ),
    );
  }
}

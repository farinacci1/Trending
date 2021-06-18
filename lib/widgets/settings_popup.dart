import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trending/services/AuthService.dart';
import 'package:trending/widgets/custom_rect_twenn.dart';
class SettingsPopup extends StatefulWidget {
  @override
  SettingsPopupCard createState() => SettingsPopupCard();
}

class SettingsPopupCard extends State<SettingsPopup> {
  static const String _settingsPopup = 'settings_popup';
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: _settingsPopup,
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin, end: end);
        },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 100,horizontal: 20),
        child: Material(
          elevation: 3,
          color: Colors.white,
          shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: SingleChildScrollView(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Settings",style: TextStyle(fontSize: 20,),),
              SizedBox(width: 250,height:10,child:  Divider(thickness: 2,)),
              SizedBox(width: 250,height:50,child: TextButton.icon(onPressed: (){}, icon: Icon(Icons.storefront_rounded),label: Text("Upgrade"), style: TextButton.styleFrom(primary: Colors.black87) ,)),
              SizedBox(width: 250,height:50,child: TextButton.icon(onPressed: (){}, icon: Icon(Icons.privacy_tip_outlined),label: Text("View Policies"),style: TextButton.styleFrom(primary: Colors.black87))),
              SizedBox(width: 250,height:50,child: TextButton.icon(onPressed: (){Authenticator().logout(context);}, icon: Icon(Icons.logout),label: Text("Logout",),style: TextButton.styleFrom(primary: Colors.black87) )),

            ],
          ),
          )
        ),
      ),
    )
    );
  }

}
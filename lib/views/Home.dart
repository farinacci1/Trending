import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trending/services/hero_dialog_route.dart';
import 'package:trending/widgets/settings_popup.dart';
import 'package:trending/notifiers/eventNotifier.dart';

import 'HomeCentral.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black87,//background for posts will be HexColor("#30323b")
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15,horizontal: 8),
              color: Colors.black,
              height: 65,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 Padding(padding: EdgeInsets.only(right: 5),
                   child: Container(width:40,
                     child:GestureDetector(
                       onTap: (){Provider.of<EventNotifier>(context,listen: false).searchType= EventType.ShowMyPosts; },
                       child: CircleAvatar(backgroundColor: Colors.blue,),
                     ),
                     decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white,width:2)),
                   ),
                 ),
                  Flexible(
                      child: Material(
                          elevation: 20.0,
                          shadowColor: Colors.green,
                          child: TextField(
                              maxLines: 1,
                              textAlignVertical: TextAlignVertical.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(36)
                              ],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                              decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Search in Users, keywords...",
                                  contentPadding:
                                      EdgeInsets.fromLTRB(5.0, 0, 0.0, 20.0),
                                  suffixStyle:
                                      const TextStyle(color: Colors.green),
                                  suffix: Icon(
                                    Icons.clear,
                                    size: 16,
                                    color: Colors.black,
                                  ),
                                  suffixIcon: Container(
                                    child: Material(
                                      elevation: 20.0,
                                      color: Colors.lightBlue,
                                      shadowColor: Colors.green,
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.black,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: Colors.greenAccent,
                                                width: 1))),
                                  ),
                                  border: new OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.zero),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 3),
                                  ),
                                  focusedBorder: new OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 0),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white)))),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(HeroDialogRoute(builder: (context) {
                            return  SettingsPopup();
                      }));
                    },
                    child: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: FaIcon(
                          FontAwesomeIcons.cog,
                          size: 24,
                          color: Colors.white,
                        )),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child:   HomeCentral(),
              ),
            ),
            Container(
              height: 70,
              width: double.infinity,

              decoration:  BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        color: Colors.blue,
                        width: 1),
                  ),
                  boxShadow: [

                    BoxShadow(color: Colors.greenAccent, offset: Offset(0.0, -3),blurRadius: 0.2, spreadRadius: 0.3),
                    BoxShadow(color: Colors.black, offset: Offset(0.0, 0),blurRadius: 0.1, spreadRadius: 0.1),
                  ]
              ),
              child: Row(
                children: [
                  Expanded(child: Container(height: 70,child: ElevatedButton(onPressed: () { Provider.of<EventNotifier>(context,listen: false).searchType= EventType.ShowNewPosts;  },style: ElevatedButton.styleFrom(
                    primary: Colors.black87,
                    elevation: 30,

                  ),
                  child:Icon(Icons.new_releases_sharp, size: 24,color: Colors.greenAccent   ,),
                  ))),
                  Expanded(child: Container(
                    decoration:  BoxDecoration(
                        border: Border(
                            left: BorderSide(
                                color: Colors.blue,
                                width: 1),
                            right: BorderSide(
                                color: Colors.blue,
                                width: 1),
                        )
                    ),
                      height: 70,
                      child: ElevatedButton(
                        onPressed: () { Provider.of<EventNotifier>(context,listen: false).searchType = EventType.AddPost;  },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black87,
                            elevation: 30,

                        ),
                        child:  FaIcon(FontAwesomeIcons.edit, size: 24,color: Colors.white,),
                      ))),
                  Expanded(child: Container(height: 70,child: ElevatedButton(onPressed: () { Provider.of<EventNotifier>(context,listen: false).searchType= EventType.ShowTrendingPosts; },style: ElevatedButton.styleFrom(
                    primary: Colors.black87,
                    elevation: 28,
                  ),
                    child: FaIcon(FontAwesomeIcons.fire,size: 24,color: Colors.red,),
                    ))),
                ],
              ),

            )
          ],
        ));
  }
}

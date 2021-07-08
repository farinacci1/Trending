import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_rect_twenn.dart';

class ImageOrVideoSelector extends StatefulWidget {
  @override
  _ImageOrVideoSelectorState createState() => _ImageOrVideoSelectorState();
}

class _ImageOrVideoSelectorState extends State<ImageOrVideoSelector> {
  static const String _ImagePicker = 'ImageOrVideoSelector';
  bool isImage = false;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Hero(
            tag: _ImagePicker,
            createRectTween: (begin, end) {
              return CustomRectTween(begin: begin, end: end);
            },
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
                child: Material(
                  elevation: 3,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.only(top: 6),
                          child: Text(
                            "Add A Pictures Or Video!",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Stack(
                              clipBehavior: Clip.none,
                              alignment: AlignmentDirectional.topCenter,
                              children: [
                                Container(
                                  width: 200,

                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  child: Column(
                                    children: [
                                      Container(
                                          width: 170,
                                          height: 40,
                                          margin: EdgeInsets.symmetric(vertical: 10),
                                          child: ElevatedButton.icon(
                                              onPressed: () {
                                                Navigator.pop(context, {
                                                  "isPic": true,
                                                  "fromGallery": false
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.black87),
                                              icon: Icon(Icons.camera_alt),
                                              label: Text("Camera"))),
                                      Container(
                                          width: 170,
                                          height: 40,
                                          child: ElevatedButton.icon(
                                              onPressed: () {
                                                Navigator.pop(context, {
                                                  "isPic": true,
                                                  "fromGallery": true
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.black87),
                                              icon: Icon(Icons.image),
                                              label: Text("Gallery"))),
                                    ],
                                  ),
                                ),
                                Positioned(
                                    top: -10,
                                    child: Text(
                                      " Pictures ",
                                      style: TextStyle(
                                          fontSize: 20,
                                          backgroundColor: Colors.white),
                                    ))
                              ])),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Stack(
                              clipBehavior: Clip.none,
                              alignment: AlignmentDirectional.topCenter,
                              children: [
                                Container(
                                  width: 200,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  child: Column(
                                    children: [
                                      Container(
                                          width: 170,
                                          height: 40,
                                          margin: EdgeInsets.symmetric(vertical: 10),
                                          child: ElevatedButton.icon(
                                              onPressed: () {
                                                Navigator.pop(context, {
                                                  "isPic": false,
                                                  "fromGallery": false
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.black87),
                                              icon: Icon(Icons.videocam),
                                              label: Text("Camera"))),
                                      Container(
                                          width: 170,
                                          height: 40,
                                          child: ElevatedButton.icon(
                                              onPressed: () {
                                                Navigator.pop(context, {
                                                  "isPic": false,
                                                  "fromGallery": true
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.black87),
                                              icon: Icon(
                                                  Icons.local_movies_rounded),
                                              label: Text("Gallery"))),
                                    ],
                                  ),
                                ),
                                Positioned(
                                    top: -10,
                                    child: Text(
                                      " Videos ",
                                      style: TextStyle(
                                          fontSize: 20,
                                          backgroundColor: Colors.white),
                                    ))
                              ])),
                    ],
                  ),
                ))));
  }
}

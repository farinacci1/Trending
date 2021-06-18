import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_rect_twenn.dart';

class UrlFetcher extends StatefulWidget {
  @override
  _UrlFetcherState createState() => _UrlFetcherState();
}

class _UrlFetcherState extends State<UrlFetcher> {
  static const String _URLPOPUP = 'URL_popup';
  TextEditingController urlController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Hero(
            tag: _URLPOPUP,
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
                  child: (Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(padding: EdgeInsets.only(top: 10),child: Text("Please enter website data",style: TextStyle(fontSize:16),)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller:urlController ,
                            decoration: InputDecoration(
                                hintText: "website Url", labelText: "Website")),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            TextButton(
                                onPressed: () {
                                  String url = urlController.value.text;
                                  print(url);
                                  bool isValidUrl =
                                      Uri.tryParse(url)?.hasAbsolutePath ??
                                          false;
                                  if (isValidUrl)
                                    Navigator.of(context)
                                        .pop({"status": true, "url": url});
                                  else {
                                    print("invalid url");
                                  }
                                },
                                style:TextButton.styleFrom(
                                  backgroundColor: Colors.black87,
                                  primary: Colors.white70,
                                ),
                                child: Text("ok")),
                            SizedBox(width: 20,),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop({"status": false});
                                },
                                style:TextButton.styleFrom(
                                  backgroundColor: Colors.black87,
                                  primary: Colors.white70,
                                ),
                                child: Text("Cancel"))
                          ]))
                    ],
                  )),
                ))));
  }
}

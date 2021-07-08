
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trending/models/post.dart';

class ShowPost extends StatefulWidget{
  @required final Post post;
  ShowPost({this.post});
  @override
  _PostState createState() => _PostState();
}
class _PostState extends State<ShowPost>{

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(5,10,5,1),
        child:Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.post.location == "" ? SizedBox() : SizedBox(),
          widget.post.imageVideo == "" ? SizedBox() : SizedBox(),
          widget.post.url == "" ? SizedBox() : SizedBox(),

        ],
      ),
      )
    );
  }

}
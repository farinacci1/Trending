import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trending/notifiers/eventNotifier.dart';
import 'package:trending/views/postGen.dart';
import 'package:trending/views/showNew.dart';
import 'package:trending/views/showTrending.dart';
class HomeCentral extends StatefulWidget {
  @override
  _HomeCentralState createState() => _HomeCentralState();
}

class _HomeCentralState extends State<HomeCentral> {


  @override
  Widget build(BuildContext context) {
    EventNotifier searchNotifier = Provider.of<EventNotifier>(context);
    switch (searchNotifier.searchType) {
      case (EventType.ShowMyPosts):
        return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(
            "My Posts",
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ]);
      case (EventType.ShowTrendingPosts):
        return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text("Trending", style: TextStyle(fontSize: 15, color: Colors.white)),
          ShowTrending()
        ]);
      case (EventType.ShowNewPosts):
        return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text("Latest", style: TextStyle(fontSize: 15, color: Colors.white)),
          ShowNew()
        ]);
      case (EventType.AddPost):
        return PostGen();
      default:
        return Center(
          child: Text("Not working"),
        );
    }
  }
}

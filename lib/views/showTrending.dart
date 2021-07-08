import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:trending/notifiers/postNotifier.dart';

class ShowTrending extends StatefulWidget {
  @override
  _ShowTrendingState createState() => _ShowTrendingState();
}

class _ShowTrendingState extends State<ShowTrending> {
  ScrollController _scrollController = ScrollController();
  @override void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    PostNotifier postNotifier = Provider.of<PostNotifier>(context,listen: true);
    if(postNotifier.postsByTrending.isNotEmpty){
      return ListView.separated(
        controller: _scrollController,
          itemCount: postNotifier.postsByTrending.length,
        itemBuilder: (context,index){
            return Container();
        },
        separatorBuilder: (context,index){
            return Container();
        },
      );
    }else{
      if(postNotifier.lastFetchInTrending <= Timestamp.now().millisecondsSinceEpoch){
        return Container();
      }
      return Container();
    }
  }
}
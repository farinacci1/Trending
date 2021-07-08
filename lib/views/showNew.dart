import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:trending/notifiers/postNotifier.dart';

class ShowNew extends StatefulWidget {
  @override
  _ShowNewState createState() => _ShowNewState();
}

class _ShowNewState extends State<ShowNew> {
  ScrollController _scrollController = ScrollController();
  @override void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    PostNotifier postNotifier = Provider.of<PostNotifier>(context,listen: true);
    if(postNotifier.postsByNew.isNotEmpty){
      return ListView.separated(
        controller: _scrollController,
        itemCount: postNotifier.postsByNew.length,
        itemBuilder: (context,index){
          return Container();
        },
        separatorBuilder: (context,index){
          return Container();
        },
      );
    }else{
      if(postNotifier.lastFetchInNew == 0){
        return Container();
      }
      return Container();
    }
  }
}

import 'package:flutter/cupertino.dart';
enum EventType {
  ShowMyPosts,
  ShowNewPosts,
  ShowTrendingPosts,
  AddPost,

}
class EventNotifier with ChangeNotifier{

  EventType _searchType = EventType.ShowNewPosts;

  EventType get searchType => _searchType;
  set searchType(EventType _st){_searchType = _st; notifyListeners();}




}
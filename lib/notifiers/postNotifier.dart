import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:trending/models/post.dart';

class PostNotifier with ChangeNotifier{

  List<Post> _allPosts = [];
  List<Post> _trendingPosts = [];
  List<Post> _myPosts = [];
  Post _currentPost;
  int _lastFetchInNew = 0;
  int _lastFetchInTrending = 0;
  int _lastFetchInMyPosts = 0;

  UnmodifiableListView<Post> get postsByNew => UnmodifiableListView(_allPosts);
  UnmodifiableListView<Post> get postsByTrending => UnmodifiableListView(_trendingPosts);
  UnmodifiableListView<Post> get postsByUser => UnmodifiableListView(_myPosts);
  Post get currentPost => _currentPost;
  int get lastFetchInNew => _lastFetchInNew;
  int get lastFetchInTrending => _lastFetchInTrending;
  int get lastFetchInMyPosts => _lastFetchInMyPosts;

  set postsByNew(List<Post> newPostsList){
    _allPosts = newPostsList;
    notifyListeners();
  }
  set postsByTrending(List<Post> trendingPosts){
    _allPosts = trendingPosts;
    notifyListeners();
  }
  set postsByUser(List<Post> myPosts){
    _allPosts = myPosts;
    notifyListeners();
  }
  set currentPost(Post currPost){
    _currentPost = currPost;
    notifyListeners();
  }
  set lastFetchInNew(int time){ _lastFetchInNew = time; notifyListeners();}
  set lastFetchInTrending(int time){ _lastFetchInTrending = time; notifyListeners();}
  set lastFetchInMyPosts(int time){ _lastFetchInMyPosts = time; notifyListeners();}

}
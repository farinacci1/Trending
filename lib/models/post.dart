
import 'package:flutter/cupertino.dart';

class Post{
  @required final String postId;
  @required final String posterId;
  List<String> urls;
  List<String> imagePaths;
  List<String> videoPaths;
  String location;
  int numLikes;
  int downVotes;
  int numFlags;
  Post(this.postId,this.posterId,this.urls,this.imagePaths,this.location,this.numLikes,this.downVotes,this.numFlags);


}
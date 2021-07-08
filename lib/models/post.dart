import 'dart:io';

import 'package:flutter/cupertino.dart';

class Post {
  final String postId;
  @required final String posterId;
  @required final String content;
  String url;

  File imageVideo;
  bool isImage;
  String location;
  int numLikes;
  int downVotes;
  int numFlags;
  Post(
      {this.postId,
      this.posterId,
      this.content,
      this.url = "",
      this.imageVideo,
      this.location = "",
      this.isImage,
      this.numLikes = 0,
      this.downVotes = 0,
      this.numFlags = 0});
}

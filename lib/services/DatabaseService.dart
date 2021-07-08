import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:trending/models/post.dart';
import 'package:trending/services/timeConvert.dart';
class DatabaseService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Future<bool> isUserExist(String userId) async {
    bool exists = false;
    DocumentSnapshot ds = await db.collection("Users").doc(userId).get();
      if (ds.exists)
        exists = true;
      else
        exists = false;
    return exists;
  }

  Future<void> createUser( String userId,
      String displayName, [File profileImage]) async {
    String reference;
    if(profileImage!= null)  reference = await uploadFile(profileImage);
    await db.collection("Users").doc(userId).set({
      "displayName": displayName,
      "displayImage": reference,
      "dailyPostLimitRemaining": 25,
      "lastPostTime":0,
      "postsILiked": []
    });
  }
  Future<void> createPost(Post post)async {
    int nowTime = DateTime.now().millisecondsSinceEpoch;
    String imageVideo = await uploadFile(post.imageVideo);
   await  db.collection("Posts").doc().set({
     "posterId": post.posterId,
     "webUrl":post.url,
     "imageVideo": imageVideo,
     "isImage": post.isImage,
     "location": post.location,
     "numLikesTotal": post.numLikes,
     "downVotesTotal": post.downVotes,
     "numFlagsTotal": post.numFlags,
     "flagsByType" :{"isOffensive": 0, "containsPornographicContent":0,"lifeThreatening":0,"sharingOfPrivateInformation":0},
     "creationTime" :nowTime,
     "deleteTime" : nowTime + TimeConverter().hourstomilliseconds(3),
     "isNSFW": false,
     "numLikesByTime": {
       "5min":0,"10min":0 ,"15min":0,"20min":0,"30min":0,"35min":0,"40min":0,"45min":0,"50min":0,"60min":0,
       "65min":0,"70min":0,"80min":0,"85min":0,"90min":0,"95min":0,"100min":0,"105min":0,"110min":0,"115min":0,"120min":0,
       "125min":0,"130min":0,"135min":0,"140min":0,"145min":0,"150min":0,"155min":0,"160min":0,"165min":0,"170min":0,"175min":0,"180min":0,
     },
     "numDownVotesByTime": {
       "5min":0,"10min":0 ,"15min":0,"20min":0,"30min":0,"35min":0,"40min":0,"45min":0,"50min":0,"60min":0,
       "65min":0,"70min":0,"80min":0,"85min":0,"90min":0,"95min":0,"100min":0,"105min":0,"110min":0,"115min":0,"120min":0,
       "125min":0,"130min":0,"135min":0,"140min":0,"145min":0,"150min":0,"155min":0,"160min":0,"165min":0,"170min":0,"175min":0,"180min":0,
     },
     "numFlagsByTime": {
       "5min":0,"10min":0 ,"15min":0,"20min":0,"30min":0,"35min":0,"40min":0,"45min":0,"50min":0,"60min":0,
       "65min":0,"70min":0,"80min":0,"85min":0,"90min":0,"95min":0,"100min":0,"105min":0,"110min":0,"115min":0,"120min":0,
       "125min":0,"130min":0,"135min":0,"140min":0,"145min":0,"150min":0,"155min":0,"160min":0,"165min":0,"170min":0,"175min":0,"180min":0,
     },
     "trendingScoreComputeTime":null

   });
  }
  Stream<DocumentSnapshot> getUniqueUsernames() {
    Stream<DocumentSnapshot> userNames =
    db.collection("Conditionals").doc("uniqueUsernames").snapshots();
    return userNames;
  }

  Future<String> uploadFile(File _image) async {
    Reference ref =
        storage.ref().child(basename(_image.path) + DateTime.now().toString());
    String url;
    UploadTask uploadTask = ref.putFile(_image);
    uploadTask.then((res) async {
      url = await ref.getDownloadURL();
    }).catchError((onError) {
      print(onError);
    });
    return url;
  }

  Future<bool> removeFromStorage(String fileRef) async {
    bool isDeleted = false;
    storage.refFromURL(fileRef).delete().then((_) async {
      isDeleted = true;
    }).catchError((error) {
      print(error);
      isDeleted = false;
    });
    return isDeleted;
  }
}

import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
    db.collection("Users").doc(userId).set({
      "displayName": displayName,
      "displayImage": reference
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

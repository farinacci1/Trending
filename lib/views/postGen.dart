import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trending/models/post.dart';
import 'package:trending/services/DatabaseService.dart';
import 'package:trending/widgets/customUrlPreview.dart';
import 'package:trending/services/hero_dialog_route.dart';
import 'package:trending/services/hex2color.dart';
import 'package:trending/widgets/ImageOrVideoSelector.dart';
import 'package:trending/widgets/VideoWrapper.dart';
import '../widgets/UrlFetcher.dart';
import '../widgets/imageWrapper.dart';
import '../widgets/locationPicker.dart';

class PostGen extends StatefulWidget {
  _PostGenState createState() => _PostGenState();
}

class _PostGenState extends State<PostGen> {
  String url = "";
  String location ="";
  File selectedFile;
  bool isImage = false;
  TextEditingController userMessageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Future<void> generatePost() async {
    Post newPost;
    String content = userMessageController.value.text;
    content= content.trim();
    if(content == null || content.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post must contain a message body')));
      return;
    }
    if (selectedFile != null)
      newPost = Post(posterId:  FirebaseAuth.instance.currentUser.uid,content: content,url: url,location: location,imageVideo: selectedFile,isImage: isImage);
    else
      newPost = Post(posterId:  FirebaseAuth.instance.currentUser.uid,content: content,url: url,location: location);
    await DatabaseService().createPost(newPost);
  }

  Widget addImage()  {
    if (selectedFile != null) {
     if (isImage == true) {
       return ImageWrapper(selectedFile.path, ImageSrc.local);
     } else {
       return VideoWrapper(selectedFile.path, VideoSrc.local);
      }
     }
     return SizedBox();
  }

  Widget addUrl() {
    if (url != null && url != "") {
      return Column(children: [
        Divider(color: Colors.white70, height: 5.0, thickness: 0.2),
        Container(
            padding: EdgeInsets.only(top: 12),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                new CustomUrlPreview(url),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            url = "";
                          });
                        },
                        child: Icon(
                          Icons.highlight_remove_rounded,
                          color: Colors.black87,
                        )))
              ],
            ))
      ]);
    } else
      return SizedBox();
  }

  Widget addLocation() {
    if (location != null && location != "") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Dismissible(
            key: Key("locationAttr"),
            child:  Material(
              elevation: 10,
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(10),
              shadowColor: Colors.white,
              child: Text(
                " " + location + " ",
                style: TextStyle(color: Colors.white),
              ),
            ),
            onDismissed: (direction){
              setState(() {
                location = "";
              });
            },
          )
        ],
      );
    }
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
      ),
      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
      child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            addLocation(),
        TextField(
          controller: userMessageController,
            inputFormatters: [LengthLimitingTextInputFormatter(256)],
            textInputAction: TextInputAction.go,
            minLines: 1,
            maxLines: 20,
            textAlign: TextAlign.center,
            keyboardAppearance: Brightness.dark,
            style: TextStyle(color: Colors.white, fontSize: 23),
            decoration: InputDecoration.collapsed(
              hintText:
                  "Share your thoughts with the world and watch them trend!",
              hintStyle: Theme.of(context).textTheme.caption.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic),
            )),
        SizedBox(height: 4,),
        addImage(),
        addUrl(),

        Divider(color: Colors.white70, height: 10.0, thickness: 0.5),
        Container(
          height: 32,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () => print('Live'),
                icon: const Icon(
                  Icons.videocam,
                  color: Colors.red,
                  size: 18,
                ),
                label: Text(""),
              ),
              const VerticalDivider(
                width: 8,
                color: Colors.white70,
              ),
              TextButton.icon(
                onPressed: () async {
                  final imagePromptReturn = await Navigator.of(context)
                      .push(HeroDialogRoute(builder: (context) {
                    return new ImageOrVideoSelector();
                  }));
                  if (imagePromptReturn != null) {
                    bool isPic = imagePromptReturn['isPic'];
                    bool fromGallery = imagePromptReturn['fromGallery'];
                    if (isPic) {
                      if (fromGallery) {
                        PickedFile pickedFile = await _picker.getImage(
                            source: ImageSource.gallery,
                            maxHeight: 1024,
                            maxWidth: 1024);
                        setState(() {
                          isImage = true;
                          selectedFile = File(pickedFile.path);
                        });
                      } else {
                        PickedFile pickedFile = await _picker.getImage(
                            source: ImageSource.camera,
                            maxHeight: 1024,
                            maxWidth: 1024);

                        setState(() {
                          isImage = true;
                          selectedFile = File(pickedFile.path);
                        });
                      }
                    } else {
                      if (fromGallery) {
                        PickedFile pickedFile = await _picker.getVideo(
                            source: ImageSource.gallery,
                            maxDuration: Duration(minutes: 3));

                        setState(() {
                          isImage = false;
                          selectedFile = File(pickedFile.path);
                        });
                      } else {
                        PickedFile pickedFile = await _picker.getVideo(
                            source: ImageSource.camera,
                            maxDuration: Duration(minutes: 3));
                        setState(() {
                          isImage = false;
                          selectedFile = File(pickedFile.path);
                        });
                      }
                    }
                  }
                },
                icon: const FaIcon(
                  FontAwesomeIcons.photoVideo,
                  color: Colors.green,
                  size: 18,
                ),
                label: Text(''),
              ),
              const VerticalDivider(
                width: 8,
                color: Colors.white70,
              ),
              TextButton.icon(
                onPressed: () async {
                  final locationPromptReturn = await Navigator.of(context)
                      .push(HeroDialogRoute(builder: (context) {
                    return new LocationPicker();
                  }));
                  if (locationPromptReturn != null) {
                    setState(() {
                      location = locationPromptReturn['locale'];
                    });
                  }
                },
                icon: const FaIcon(
                  FontAwesomeIcons.mapMarkerAlt,
                  color: Colors.orangeAccent,
                  size: 18,
                ),
                label: Text(''),
              ),
              const VerticalDivider(
                width: 8,
                color: Colors.white70,
              ),
              TextButton.icon(
                onPressed: () async {
                  final urlPromptReturned = await Navigator.of(context)
                      .push(HeroDialogRoute(builder: (context) {
                    return new UrlFetcher();
                  }));
                  if (urlPromptReturned != null) {
                    bool status = urlPromptReturned['status'];
                    if (status) {
                      setState(() {
                        url = urlPromptReturned['url'];
                      });
                    }
                  }
                },
                icon: const FaIcon(
                  FontAwesomeIcons.globe,
                  color: Colors.blue,
                  size: 18,
                ),
                label: Text(''),
              ),
              const VerticalDivider(
                width: 8,
                color: Colors.white70,
              ),
              Container(
                color: HexColor("#30323b"),
                child: IconButton(
                  color: HexColor("#30323b"),
                  onPressed: () {
                    print('posting');
                    generatePost();
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.paperPlane,
                    color: Colors.redAccent,
                    size: 18,
                  ),
                ),
              )
            ],
          ),
        )
      ])),
    );
  }
}

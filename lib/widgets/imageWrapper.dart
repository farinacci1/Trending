import 'dart:io';

import 'package:flutter/cupertino.dart';
enum ImageSrc { local, asset, network }
class ImageWrapper extends StatefulWidget {
  @required
  final String imagePath;
  @required
  final ImageSrc imageSrc;

  ImageWrapper(this.imagePath,this.imageSrc);
  @override
  _ImageWrapperState createState() => _ImageWrapperState();
}

class _ImageWrapperState extends State<ImageWrapper> {


  @override
  Widget build(BuildContext context) {
    switch(widget.imageSrc){
      case ImageSrc.asset:
        return ClipRRect(  borderRadius: BorderRadius.circular(15),child: Image.asset(widget.imagePath,fit: BoxFit.scaleDown));
      case ImageSrc.local:
        return ClipRRect(  borderRadius: BorderRadius.circular(15),child: Image.file(File(widget.imagePath),fit: BoxFit.scaleDown));
      case ImageSrc.network:
        return ClipRRect(  borderRadius: BorderRadius.circular(15),child: Image.network(widget.imagePath,fit: BoxFit.scaleDown,));
    }
    return SizedBox();
  }
}

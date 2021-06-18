// @dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trending/services/flutter_link_preview/flutter_link_preview.dart';
import 'package:trending/services/hex2color.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CustomUrlPreview extends StatefulWidget {
  @required final String urlString;
  @override
  CustomUrlPreview(this.urlString);
  _CustomUrlPreviewState createState() => _CustomUrlPreviewState();
}

class _CustomUrlPreviewState extends State<CustomUrlPreview> {
  bool isYoutube = false;
  YoutubePlayerController _YTcontroller;
  @override
  void initState() {
    if(widget.urlString.startsWith("https://www.youtube.com/")) {
      setState(() {
        isYoutube = true;
        String videoId = YoutubePlayer.convertUrlToId(widget.urlString);
        _YTcontroller = YoutubePlayerController(initialVideoId: videoId,);
      });
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FlutterLinkPreview(
      key: ValueKey("${widget.urlString}211"),
      url: widget.urlString,
      builder: (info) {
        if (info == null) return const SizedBox();
        if (info is WebImageInfo) {
          return CachedNetworkImage(
            imageUrl: info.image,
            fit: BoxFit.contain,
          );
        }

        final  WebInfo webInfo = info as WebInfo;
        if (!WebAnalyzer.isNotEmpty(webInfo.title)) return const SizedBox();
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:  HexColor("#30323b")
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: webInfo.icon ?? "",
                    imageBuilder: (context, imageProvider) {
                      return Image(
                        image: imageProvider,
                        fit: BoxFit.contain,
                        width: 30,
                        height: 30,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.link);
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      webInfo.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              if (WebAnalyzer.isNotEmpty(webInfo.description)) ...[
                const SizedBox(height: 8),
                Text(
                  webInfo.description,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.lightBlueAccent),
                ),
              ],
              if(isYoutube)...[
                YoutubePlayer(
                  controller: _YTcontroller,
                ),
              ],
               if (!isYoutube && WebAnalyzer.isNotEmpty(webInfo.image)) ...[
                const SizedBox(height: 8),
                CachedNetworkImage(
                  imageUrl: webInfo.image,
                  fit: BoxFit.contain,
                ),
              ]
            ],
          ),
        );
      },
    );
  }

}
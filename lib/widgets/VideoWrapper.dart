import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

enum VideoSrc { local, asset, network }

class VideoWrapper extends StatefulWidget {
  @required
  final String videoPath;
  @required
  final VideoSrc sourceType;
  VideoWrapper(this.videoPath, this.sourceType);
  @override
  _VideoWrapperState createState() => _VideoWrapperState();
}

class _VideoWrapperState extends State<VideoWrapper> {
  VideoPlayerController _videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;
  bool isPlaying = false;
  @override
  void initState() {
    switch (widget.sourceType) {
      case VideoSrc.asset:
        _videoPlayerController = VideoPlayerController.asset(widget.videoPath);
        break;
      case VideoSrc.local:
        _videoPlayerController =
            VideoPlayerController.file(File(widget.videoPath));
        break;
      case VideoSrc.network:
        _videoPlayerController =
            VideoPlayerController.network(widget.videoPath);
        break;
    }
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();

    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, _) {
          return Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController),
                ),
              ),
                Container(
                  height: 30,
                  decoration: new BoxDecoration(
                      border: new Border.all(width: 1 ,color: Colors.transparent), //color is transparent so that it does not blend with the actual color specified
                      color: new Color.fromRGBO(96, 125, 139, 0.5) // Specifies the background color and the opacity
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child:Row(
                  children: [
                    IconButton(
                        icon: Icon(!isPlaying ? Icons.play_arrow_rounded : Icons.pause,size: 16,color: Colors.white,),
                        onPressed: () {
                          !_videoPlayerController.value.isPlaying
                              ? _videoPlayerController.play()
                              : _videoPlayerController.pause();
                          setState(() {isPlaying = !isPlaying; });
                        }),
                    IconButton(
                        icon: Icon(Icons.replay, size: 16,color: Colors.white,),
                        onPressed: () {
                          _videoPlayerController.seekTo(Duration.zero);
                          _videoPlayerController.play();
                          setState(() {isPlaying = true; });
                        }),

                           Expanded(
                              child: VideoProgressIndicator(
                                _videoPlayerController,//controller
                                allowScrubbing: true,
                                colors: VideoProgressColors(
                                  playedColor: Colors.black,
                                  bufferedColor: Colors.grey,
                                  backgroundColor: Colors.white,
                                ),
                              )
                           )

                  ],
                ),
              )
            ],
          );
        });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trending/notifiers/eventNotifier.dart';
import 'package:trending/models/customUrlPreview.dart';
import 'package:trending/services/hero_dialog_route.dart';
import 'package:trending/widgets/UrlFetcher.dart';
import 'package:trending/services/hex2color.dart';
import 'package:trending/widgets/locationPicker.dart';

class HomeCentral extends StatefulWidget {
  @override
  _HomeCentralState createState() => _HomeCentralState();
}

class _HomeCentralState extends State<HomeCentral> {
  String url;
  Widget addUrl() {
    if (url != null && url != "") {

      return Column(children:[ Divider(color: Colors.white70, height: 5.0, thickness: 0.2),Container(
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

  @override
  Widget build(BuildContext context) {
    EventNotifier searchNotifier = Provider.of<EventNotifier>(context);
    switch (searchNotifier.searchType) {
      case (EventType.ShowMyPosts):
        return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(
            "My Posts",
            style: TextStyle(fontSize: 15, color: Colors.white),
          )
        ]);
      case (EventType.ShowTrendingPosts):
        return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text("Trending", style: TextStyle(fontSize: 15, color: Colors.white))
        ]);
      case (EventType.ShowNewPosts):
        return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text("Latest", style: TextStyle(fontSize: 15, color: Colors.white))
        ]);
      case (EventType.AddPost):
        return Container(
          decoration: BoxDecoration(
            color: Colors.black87,
          ),
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
          child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                inputFormatters: [LengthLimitingTextInputFormatter(256)],
                textInputAction: TextInputAction.go,
                minLines: 1,
                maxLines: 20,
                textAlign: TextAlign.center,
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
                    onPressed: () => print('Photo'),
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
                       await Navigator.of(context)
                          .push(HeroDialogRoute(builder: (context) {
                        return new LocationPicker();
                      }));
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
                      onPressed: () => print('posting'),
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
      default:
        return Center(
          child: Text("Not working"),
        );
    }
  }
}

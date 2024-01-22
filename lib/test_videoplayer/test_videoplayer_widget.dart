import 'package:flutter/material.dart';
import 'package:test_transform/test_videoplayer/videoplayer_controller_widget.dart';
import 'package:test_transform/test_videoplayer/videoplayer_widget.dart';

String videoUrl =
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

// Stateful widget to fetch and then display video content.
class VideoApp extends StatefulWidget {
  const VideoApp({Key? key, this.onTap}) : super(key: key);
  final VoidCallback? onTap;
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  Future onFullMode2() {
    return showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (BuildContext bc) {
        return MaterialApp(
          home: Material(
            child: Center(
              child: VideoPlayerWidget(
                url: videoUrl,
                placeHolderWidget: Icon(Icons.downloading_outlined),
                controllerBuilder: (context, value) {
                  return VideoControllerWidget(
                    controller: value,
                    onFullScreen: () {
                      Navigator.of(bc).pop();
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void onFullMode() {
    Navigator.of(context).push(MaterialPageRoute(builder: (bc) {
      return MaterialApp(
        home: Scaffold(
          body: SizedBox.expand(
            child: Center(
              child: VideoPlayerWidget(
                url: videoUrl,
                placeHolderWidget: Icon(Icons.downloading_outlined),
                controllerBuilder: (bc2, value) {
                  return VideoControllerWidget(
                    controller: value,
                    onFullScreen: () {
                      Navigator.of(bc).pop();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );
    })).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.green,
        width: 500,
        height: 500,
        child: VideoPlayerWidget(
          url: videoUrl,
          controllerBuilder: (context, value) {
            return VideoControllerWidget(
              controller: value,
              onFullScreen: () {
                onFullMode();
              },
            );
          },
        ),
      ),
    );
  }
}

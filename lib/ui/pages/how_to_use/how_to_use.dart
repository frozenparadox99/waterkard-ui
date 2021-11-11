import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';

import '../vendor_login_page.dart';

class HowToUse extends StatelessWidget {
  const HowToUse({Key key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        title: Text('How To Use'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {

              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => VendorLoginPage()));
            },
          )
        ],
      ),
      body: _ButterFlyAssetVideoInList(),
    );
  }
}


class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        title: Text('How To Use'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {

              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => VendorLoginPage()));
            },
          )
        ],
      ),
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      )
    ;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}


class _ButterFlyAssetVideoInList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[

        Card(
            child: Column(children: <Widget>[
              Column(
                children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.info),
                    title: Text("How to Use"),
                  ),
                  Stack(
                      alignment: FractionalOffset.bottomRight +
                          const FractionalOffset(-0.1, -0.1),
                      children: <Widget>[
                        _BumbleBeeRemoteVideo(),
                        // Image.asset('assets/flutter-mark-square-64.png'),
                      ]),
                ],
              ),
            ])),
        Card(
            child: Column(children: <Widget>[
              Column(
                children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.info),
                    title: Text("How to Use 2"),
                  ),
                  Stack(
                      alignment: FractionalOffset.bottomRight +
                          const FractionalOffset(-0.1, -0.1),
                      children: <Widget>[
                        _BumbleBeeRemoteVideo(),
                        // Image.asset('assets/flutter-mark-square-64.png'),
                      ]),
                ],
              ),
            ])),

      ],
    );
  }
}

/// A filler card to show the video in a list of scrolling contents.
class _ExampleCard extends StatelessWidget {
  const _ExampleCard({Key key,  this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.airline_seat_flat_angled),
            title: Text(title),
          ),
          ButtonBar(
            children: <Widget>[
              TextButton(
                child: const Text('BUY TICKETS'),
                onPressed: () {
                  /* ... */
                },
              ),
              TextButton(
                child: const Text('SELL TICKETS'),
                onPressed: () {
                  /* ... */
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}




class _BumbleBeeRemoteVideo extends StatefulWidget {
  @override
  _BumbleBeeRemoteVideoState createState() => _BumbleBeeRemoteVideoState();
}

class _BumbleBeeRemoteVideoState extends State<_BumbleBeeRemoteVideo> {
   VideoPlayerController _controller;



  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',

      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(padding: const EdgeInsets.only(top: 20.0)),
          const Text('Description'),
          Container(
            padding: const EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),

                  _ControlsOverlay(controller: _controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key key,  this.controller})
      : super(key: key);

  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
            color: Colors.black26,
            child: Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 100.0,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (context) {
              return [
                for (final speed in _examplePlaybackRates)
                  PopupMenuItem(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
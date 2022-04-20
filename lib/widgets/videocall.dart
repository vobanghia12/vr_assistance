import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
class VideoCall extends StatefulWidget {
  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  final _localVideoRenderer = RTCVideoRenderer();
    @override
  void initState() {
    initRenderers();
    _getUserMedia();
    super.initState();
  }

  void initRenderers() async {
    await _localVideoRenderer.initialize();
  }
  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      }
    };
 
    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localVideoRenderer.srcObject = stream;
  }
  

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text("Video Interface"),
      ),
      body: Stack(
        children: [
          Positioned(
              top: 0.0,
              right: 0.0,
              left: 0.0,
              bottom: 0.0,
              child: RTCVideoView(_localVideoRenderer))
        ],
      ),
    );
  }
}
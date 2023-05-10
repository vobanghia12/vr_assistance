import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/user_login.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:webview_flutter/webview_flutter.dart';

/*import '../api/RTCModule.dart';
import 'package:provider/provider.dart';
import '../provider/users.dart';
import '../provider/helpers.dart';*/

class VideoCall extends StatefulWidget {
  final toID;
  VideoCall(this.toID);
  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  TransformationController controller;
  double _scale = 1.0;
  double _previousScale = 1.0;
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    controller = TransformationController();
  }

  void dispose() async {
    controller.dispose();
    super.dispose();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  /*final _localVideoRenderer = RTCVideoRenderer();
  final _remoteVideoRender = RTCVideoRenderer();
  String id;
  String token;
  bool click = false;
  RTCPeerConnection _peerConnection;
  @override
  void initState(){
   getID();
    initRenderers();
    _getUserMedia();
     setState(() {

    });
    initiateConnection().then((value) => _peerConnection = value);
    super.initState();
  }

  @override
  void dispose() async {
    // TODO: implement dispose
     await _localVideoRenderer.dispose();
     await _remoteVideoRender.dispose();
    super.dispose();
  }

  void getID() async{
    id = await Provider.of<Users>(context, listen: false).UID;
    token = await Provider.of<Users>(context, listen: false).authToken;
  }
  void initRenderers() async {
    await _localVideoRenderer.initialize();
    await _remoteVideoRender.initialize();
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'video': {
        'facingMode': 'user',
      }
    };
    MediaStream stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    print('check stream');
    print(stream.toString());
    _localVideoRenderer.srcObject = stream;
  }

  Future<void> makingOffer() async{
     await listenToConnectionEvents(_peerConnection, id, widget.toID, _remoteVideoRender, token, 'helpers');
     await createOffer(_peerConnection, _localVideoRenderer.srcObject, widget.toID, id, token);
     await listenToConnectionEvents(_peerConnection, widget.toID, id, _remoteVideoRender, token, 'users');
     await sendAnswer(_peerConnection, _localVideoRenderer.srcObject, id, token, widget.toID);
  }

 */

  /*@override
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
                child: RTCVideoView(_localVideoRenderer)),
          ],
        ),
        floatingActionButton:
          FloatingActionButton(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.black,
            onPressed: () async {
              setState(() {
                click = true;
              });
              if (click == true) await makingOffer();

              click = false;

              },
            child: Icon(Icons.camera),
          ),
        );
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InteractiveViewer(
          minScale: 1,
          maxScale: 4,
          child: WebView(
            initialUrl: 'http://192.168.1.134:5000',
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.phone_disabled),
        onPressed: () async {
          DatabaseReference ref =
              FirebaseDatabase.instance.ref("helpers/${widget.toID}");
// Only update the name, leave the age and address!
          await ref.update({
            "isSignal": false,
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  // Display remote user's video

}





/*
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';



class VideoCall extends StatefulWidget {
  final toID;
  VideoCall(this.toID);
  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  final VlcPlayerController _videoPlayerController = VlcPlayerController.network(
      'http://192.168.254.133:5000/video_feed',
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );

  Future<void> initializePlayer() async {}

  @override


  @override
  void dispose() async {
    super.dispose();
    await _videoPlayerController.stopRendererScanning();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: VlcPlayer(
            controller: _videoPlayerController,
            aspectRatio: 9/16,
            placeholder: const Center(child: CircularProgressIndicator()),
          ),
        ));
  }
}
*/
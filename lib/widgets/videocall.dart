import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:vector_math/vector_math_64.dart' show Vector3;
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

const appID = '92f7b54c9e58433aac8a44a913698c67';
const token =
    '00692f7b54c9e58433aac8a44a913698c67IACl0kj6/Dyz3rQsnpHY8bMDsShVtcj02SqZ16H11yBskxymvfMAAAAAEAC0+3p1MCK+YgEAAQAwIr5i';

class _VideoCallState extends State<VideoCall> {
  int _remoteUid;
  RtcEngine _engine;
  bool flag = false;
  double _scale = 1.0;
  double _previousScale = 1.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = await RtcEngine.create(appID);
    await _engine.enableVideo();
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print("local user $uid joined");
        },
        userJoined: (int uid, int elapsed) {
          print("remote user $uid joined");
          setState(() {
            _remoteUid = uid;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("remote user $uid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    await _engine.joinChannel(token, "chanel2", null, 0);
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
      appBar: AppBar(
        title: const Text('Video Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
                onScaleStart: (ScaleStartDetails details) {
                  print(details);
                  _previousScale = _scale;
                  setState(() {});
                },
                onScaleUpdate: (ScaleUpdateDetails details) {
                  _scale = _previousScale * details.scale;
                  setState(() {});
                },
                onScaleEnd: (ScaleEndDetails details) {
                  print(details);
                  _previousScale = 1.0;
                  setState(() {});
                },
                child: Transform(
                    alignment: FractionalOffset.center,
                    transform:
                        Matrix4.diagonal3(Vector3(_scale, _scale, _scale)),
                    child: _remoteVideo())),
          ),
         /* Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 100,
              height: 100,
              child: Center(
                child: RtcLocalView.SurfaceView(),
              ),
            ),
          )*/
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.phone_disabled),
        onPressed: () async {
          await _engine.leaveChannel();
          Navigator.pop(context);
        },
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return RtcRemoteView.SurfaceView(uid: _remoteUid);
    } else {
      return Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}

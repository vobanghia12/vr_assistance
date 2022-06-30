// ignore_for_file: unused_local_variable
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/src/parser.dart';
import 'FirebaseModule.dart';
RTCSessionDescription offer;
Future<RTCPeerConnection>initiateConnection() async  {
  try {
    // using Google public stun server
   Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
      ]

    };
    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveVideo": true,

      },
    };
     RTCPeerConnection pc = await createPeerConnection(configuration, offerSdpConstraints);
     return pc;

  } catch (exception) {
    print(exception);
  }
}


createOffer(RTCPeerConnection connection,MediaStream _localStream,String toID, String currentID, String token) async {
  try {
    connection.addStream(_localStream);
    offer = await connection.createOffer({'offerToReceiVideo' : 1});
    await connection.setLocalDescription(offer);
    var offer2 = {'type' : offer.type, 'offer': offer.sdp };
    await makeOffer(toID, token, offer2, currentID);

  }
  catch(error){
    print(error);
  }
}

listenToConnectionEvents(RTCPeerConnection connection,String localID,String remoteID, RTCVideoRenderer remoteVideoRef, String token, String phrase) async {
  connection.onIceCandidate = (event) {
    if (event.candidate != true) {
      doCandidate(remoteID, event.candidate,localID, token, phrase);
    }
  };
  print('check check check');
  // when a remote user adds stream to the peer connection, we display it
  //wrong thing
  connection.onAddStream = (stream) {
      print('camera');
      print(stream.toString());
      print(remoteVideoRef.srcObject.toString());
      remoteVideoRef.srcObject = stream;
    
  };
}


sendAnswer(RTCPeerConnection connection ,MediaStream localStream, String from, String token, String current) async {
  try {
    print('check offer');
    print(offer.sdp);
    await connection.addStream(localStream);
     RTCSessionDescription description = new RTCSessionDescription(offer.sdp, 'answer');
    await connection.setRemoteDescription(description);
    // create an answer to an offer
    RTCSessionDescription answer = await connection.createAnswer();
    connection.setLocalDescription(answer);
     print("SDP");
    print(answer.sdp);
    var answer2 = {'type' : answer.type, 'offer': answer.sdp };
   
    doAnswer(from, token, answer2, current);
  } catch (exception) {
    print(exception);
  }
}
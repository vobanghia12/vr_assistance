import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sdp_transform/sdp_transform.dart';
Map<String, String> temp;
makeOffer(String toID, String token, var offer, String currentID) async {
  final url = Uri.parse(
      'https://blind-assistance-d97b1-default-rtdb.firebaseio.com/helpers/$toID/offer.json?auth=$token');
  try {
    temp = offer;
    final response = await http.put(url,
        body:
            json.encode({'offer': offer.toString()}));
  } 
  catch (error) {
    print(error);
  }
}

doAnswer(String toID, String token, var answer, String currentID) async {
  final url = Uri.parse(
      'https://blind-assistance-d97b1-default-rtdb.firebaseio.com/users/$toID/WebRTC.json?auth=$token');
  try {
    final response = await http.put(url,
        body: json.encode({
          'answer': answer,
          'from': currentID,
          'type': 'answer',
          'offer': answer.toString(),
        }));
  } catch (error) {
    print(error);
  }
}

doCandidate(String remoteID, String candidate, String id,String token, String phrase) async {
  // send the new candiate to the peer
  final url = Uri.parse(
      'https://blind-assistance-d97b1-default-rtdb.firebaseio.com/$phrase/$remoteID/WebRTC.json?auth=$token');
  try {
    final response = await http.put(url,
        body: json.encode(
            {'type': 'candidate', 'from': id, 'candidate': candidate}));
  } catch (error) {
    print(error);
  }
}

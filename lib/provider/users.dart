//with is mixin
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/api/FirebaseModule.dart';
import 'package:flutter_complete_guide/models/helper.dart';
import '../models/user.dart';
import 'dart:convert';
import '../models/helper.dart';
import 'package:http/http.dart' as http;
import '../api/RTCModule.dart';

class Users with ChangeNotifier {
  final String authToken;
  final String UID;
  User _currentUser;
  List<Assister> l = [];
  
  List<User> _contacts = [];
  Users(this.authToken,this.UID);

  List<User> get contacts {
    return [..._contacts];
  }
  User get userInfo {
    return _currentUser;
  }
 
  Future<void> fetchAndSetUsers() async {
    final url = Uri.parse('https://blind-assistance-d97b1-default-rtdb.firebaseio.com/users/$UID.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      var arr = extractedData['list'] as Map<String ,dynamic>;
      l = [];
      if(arr != null)
      {arr.forEach((k, v) => l.add(Assister(id: k, name: arr[k]['name'], phoneNumber: arr[k]['phone'], email: arr[k]['email'], isHelper: arr[k]['isHelper'])));
     _currentUser = User(id: UID, name: extractedData['name'], phoneNumber: extractedData['phoneNumber'], email: extractedData['email'], helpers: l,  isHelper: extractedData['isHelper']);}
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addAssister(Assister assist) async {
    final id = assist.id;
     final url = Uri.parse(
        'https://blind-assistance-d97b1-default-rtdb.firebaseio.com/users/$UID/list/$id.json?auth=$authToken');
      try {
        final response = await http.put(url,
         body: json.encode({
            'name': assist.name,
            'phoneNumber': assist.phoneNumber,
            'email': assist.email,
            'isHelper': assist.isHelper,
            }));
        notifyListeners();
      }

      catch(error){
        print(error);
      }
      
  }

  Future<bool> isUser(String id) async{
      final url = Uri.parse('https://blind-assistance-d97b1-default-rtdb.firebaseio.com/users/$UID/isHelper.json?auth=$authToken');
      try{
          final response = await http.get(url);
          final decodeData = jsonDecode(response.body);
          return decodeData;
      }
      catch(error){
        print(error);
      }

  }
  
  Future<void> addUsers(User usr) async {
    final url = Uri.parse( 'https://blind-assistance-d97b1-default-rtdb.firebaseio.com/users/$UID.json?auth=$authToken');
    try {
      final response = await http.put(url,
          body: json.encode({
            'name': usr.name,
            'phoneNumber': usr.phoneNumber,
            'email': usr.email,
            'isHelper': usr.isHelper,
            }),);
      notifyListeners();
    } catch (error) {
      throw error;
    }
    
    // post to firebase  //should use json data

    //Future like promise
  }

 

  fetchAllUsers() async {
    final url = Uri.parse('https://blind-assistance-d97b1-default-rtdb.firebaseio.com/users.json?auth=$authToken');
    try {
      final response = await http.get(url);
      print(response);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<User> loadedHelpers = [];
      extractedData.forEach((id, data) {
        loadedHelpers.add(User(
          id : id,
          name: data['name'],
          phoneNumber: data['phoneNumber'],
          email: data['email'],
          isHelper: data['isHelper'],
        ));
      });
      _contacts = loadedHelpers;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

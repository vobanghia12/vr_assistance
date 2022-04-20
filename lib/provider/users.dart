//with is mixin
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Users with ChangeNotifier {
  List<User> _contacts = [
  /*  User(
        id: 'p1',
        name: 'Nghia Vo',
        phoneNumber: '+18134528015',
        email: 'vobanghia12@gmail.com'),
    User(
        id: 'p2',
        name: 'Nicolas T',
        phoneNumber: '+18134538015',
        email: 'nick@gmail.com'),*/
  ];
  List<User> get contacts {
    return [..._contacts];
  }

  Future<void> fetchAndSetUsers() async {
    final url = Uri.parse(
        'https://blind-assistance-d97b1-default-rtdb.firebaseio.com/users.json');
    try {
      final response =  await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<User> loadedUsers = [];
      extractedData.forEach((usrId, usrData) { 
          loadedUsers.add(User(
            id: usrId,
            name: usrData['name'],
            phoneNumber: usrData['phoneNumber'],
            email: usrData['email'],
          ));
      });
      _contacts = loadedUsers;
      notifyListeners();
    }
    catch(error) {
      throw error; 
    }
    
  }

  Future<void> addUsers(User usr) async {
    // use async to return automatically
    final url = Uri.parse(
        'https://blind-assistance-d97b1-default-rtdb.firebaseio.com/users.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'name': usr.name,
            'phoneNumber': usr.phoneNumber,
            'email': usr.email,
          }));
      final newUser = User(
        id: json.decode(response.body)['name'],
        name: usr.name,
        phoneNumber: usr.phoneNumber,
        email: usr.email,
      );
      _contacts.add(newUser);
      notifyListeners();
    } catch (error) {
      throw error;
    }
    // post to firebase  //should use json data

    //Future like promise
  }
}

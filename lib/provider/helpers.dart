import 'dart:collection';
import 'package:flutter_complete_guide/models/http_exception.dart';

import '../models/user.dart';
import 'package:flutter/material.dart';
import '../models/helper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class Helpers with ChangeNotifier {
  final String authToken;
  final String UID;
  List<Assister> _helperList; 
  Helpers(this.authToken, this.UID);
  final List<Assister> _helpersContacts = [];
   List<Assister> get HelperList {
    return _helperList;
  }

  set HelperList(List<Assister> list){
    _helperList = list;
    notifyListeners();
  }
  List<Assister> get helperContacts {
    return [..._helpersContacts];
  }



  Future <void> addHelpers(Assister helper) async{
    final url = Uri.parse('https://blind-assistance-d97b1-default-rtdb.firebaseio.com/helpers/$UID.json?auth=$authToken');
    if (helper.users == null )
      try {
      final response = await http.put(url,
          body: json.encode({
            'name': helper.name,
            'phoneNumber': helper.phoneNumber,
            'email': helper.email,
            'isHelper': helper.isHelper,
            }),);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
 
  fetchAllHelpers() async {
    final url = Uri.parse('https://blind-assistance-d97b1-default-rtdb.firebaseio.com/helpers.json?auth=$authToken');
    
    try {
      final response = await http.get(url);
     final extractedData = json.decode(response.body) as Map<String, dynamic>;
     if (extractedData == null) return;
      final List<Assister> loadedHelpers = [];
     extractedData.forEach((id, data) {
        loadedHelpers.add(Assister(
          id : id,
          name: data['name'],
          phoneNumber: data['phoneNumber'],
          email: data['email'],
          isHelper: data['isHelper'],
        ));
      });
      _helperList = loadedHelpers;
    /*  _helperList.forEach((element) => {
        print(element.id + " " + element.name + " " + element.phoneNumber)});
      print(_helperList[0].name);*/
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }


   Future<void> addUsersToHelpers(User usr, String UID1, String token1, String id) async {
    // use async to return automatically
    final url = Uri.parse(
        'https://blind-assistance-d97b1-default-rtdb.firebaseio.com/helpers/$UID1/list/$id.json?auth=$token1');
    try {
      final response = await http.put(url,
          body: json.encode({
            'name': usr.name,
            'phoneNumber': usr.phoneNumber,
            'email': usr.email,
            'isHelper': usr.isHelper,
            }),);
     /* final newUser = User(
        id: UID,
        name: usr.name,
        phoneNumber: usr.phoneNumber,
        email: usr.email,
        helpers: usr.helpers,
        isHelper: usr.isHelper,
      );
      _currentUser = newUser;*/
      notifyListeners();
    } catch (error) {
      throw error;
    }
    // post to firebase  //should use json data

    //Future like promise
  }

  Future<void> deleteHelper(String id) async{
     final url = Uri.parse(
        'https://blind-assistance-d97b1-default-rtdb.firebaseio.com/helpers/$id.json');
      final existingProductIndex = _helperList.indexWhere((element) => element.id == id);
      var existingProduct = _helperList[existingProductIndex];
      _helperList.removeAt(existingProductIndex);
      notifyListeners();
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
          _helperList.insert(existingProductIndex, existingProduct);
          notifyListeners();
          throw HttpException("Could not delete");
      }
      existingProduct = null;
  }
}


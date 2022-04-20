import 'package:flutter/material.dart';
import '../models/helper.dart';

class Helpers with ChangeNotifier {
  final List<Helper> _helpersContacts = [
    Helper(
        id: 'p1',
        name: 'Nghia Vo',
        phoneNumber: '+18134528015',
        email: 'vobanghia12@gmail.com'),
    Helper(
        id: 'p2',
        name: 'Nicolas T',
        phoneNumber: '+18134538015',
        email: 'nick@gmail.com'),
    Helper(
        id: 'p1',
        name: 'Nghia Vo',
        phoneNumber: '+18134528015',
        email: 'vobanghia12@gmail.com'),
    Helper(
        id: 'p2',
        name: 'Nicolas T',
        phoneNumber: '+18134538015',
        email: 'nick@gmail.com'),
  ];
  List<Helper> get helperContacts {
    return [..._helpersContacts];
  }

  void addHelpers(Helper helper) {
    _helpersContacts.add(helper);
    notifyListeners();
  }

}

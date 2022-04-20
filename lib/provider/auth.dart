import 'package:flutter/widgets.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/date_symbol_data_custom.dart';
import 'package:provider/provider.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  bool get isAuth {
    print(_token);
    return token != null;
  }

  Future<void> _authenticate(
      String email, String password, String title, String urlSegment) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyB4AZ2zS24xJmg_MP8H0z_NSBVRU-yn9vc");
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners(); //update our User Interface
    } catch (error) {
      throw error;
    }
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  Future<void> signup(String email, String password, String title) async {
    // the function to send data to database
    return _authenticate(email, password, title, 'signUp');
  }

  Future<void> login(String email, String password, String title) async {
    // the function to send data to database
    return _authenticate(email, password, title, 'signInWithPassword');
  }
}

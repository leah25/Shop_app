import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app/Models/my_exception.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  String get token {
    if ((_expiryDate != null) &&
        (_expiryDate.isAfter(DateTime.now())) &&
        (_token != null)) {
      return _token;
    }
    return null;
  }

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  Future<bool> retrieveStoredData() async {
    var prefs = await SharedPreferences.getInstance();
    var retrievedData = prefs.getString('storedData');

    if (!retrievedData.contains('storedData')) {
      return false;
    } else {
      var data = json.decode(retrievedData) as Map<String, Object>;
      var expiryDate = DateTime.parse(data['expiryDate']);

      if (expiryDate.isBefore(DateTime.now())) {
        return false;
      }
      _token = data['token'];
      _userId = data['userId'];
      _expiryDate = expiryDate;

      _autoLogout();
      notifyListeners();
      return true;
    }
  }

  Future<void> _authenticate(
      String email, String password, String apiExtension) async {
    var url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$apiExtension?key=AIzaSyCLhO96MdfJFMyszYaEuWl5aosjvu7L2Jw';
    try {
      var response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      var responseData = json.decode(response.body);
      // at times its returns a success data but its not a success
      print(responseData);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      notifyListeners();
      var prefs = await SharedPreferences.getInstance();
      String storedData = json.encode({
        'token': _token,
        'expiryDate': _expiryDate.toIso8601String(),
        'userId': _userId
      });

      prefs.setString('storedData', storedData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
      notifyListeners();
    }
    var durationTime = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: durationTime), logout);
  }
}

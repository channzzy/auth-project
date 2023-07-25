import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Authen with ChangeNotifier {
  // Timer? _authTimer;
  String? _idToken, userId;
  DateTime? _expiredDate;
  String? _tempidToken, _tempuserId;
  DateTime? _tempexpiredDate;

  void tempData() {
    _idToken = _tempidToken;
    userId = _tempuserId;
    _expiredDate = _tempexpiredDate;
    notifyListeners();
  }

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_idToken != null &&
        _expiredDate!.isAfter(DateTime.now()) &&
        _expiredDate != null) {
      return _idToken!;
    } else {
      return null;
    }
  }

  Future<void> signUp(String email, String password) async {
    Uri url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAKUHDDkKWpcebqwr-RjOvNAwGkqDVnj_o");
    try {
      var response = await http.post(
        url,
        body: jsonEncode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );
      var responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw responseData['error']["message"];
      }
      _idToken = responseData["idToken"];
      userId = responseData["localId"];
      _expiredDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData["expiresIn"],
          ),
        ),
      );
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    Uri url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAKUHDDkKWpcebqwr-RjOvNAwGkqDVnj_o");
    try {
      var response = await http.post(
        url,
        body: jsonEncode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );

      var responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw responseData['error']["message"];
      }
      _idToken = responseData["idToken"];
      userId = responseData["localId"];
      _expiredDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData["expiresIn"],
          ),
        ),
      );
      // _autoLogout();
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  void logout() {
    _idToken = null;
    userId = null;
    _expiredDate = null;
    notifyListeners();
  }

  // void _autoLogout() {
  //   if (_authTimer != null) {
  //     _authTimer!.cancel();
  //   }
  //   final timeToExpired =
  //       _tempexpiredDate!.difference(DateTime.now()).inSeconds;
  //   _authTimer = Timer(Duration(seconds: timeToExpired), logout);
  // }
}

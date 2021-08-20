import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IsLoadingProvider extends ChangeNotifier {
  bool _isLoadingProfile = false;
  bool _isLoadingSignUp = false;
  bool _isLoadingLogin = false;
  bool _isLoadMsgImg = false;

  bool get isLoadProfile => _isLoadingProfile;
  bool get isLoadSignUp => _isLoadingSignUp;
  bool get isLoadLogIn => _isLoadingLogin;
  bool get isLoadMsgImgn => _isLoadMsgImg;

  set setSt(bool b) {
    _isLoadingProfile = b;
    notifyListeners();
  }

  set setSignUpstate(bool b) {
    _isLoadingSignUp = b;
    notifyListeners();
  }

  set setLogInstate(bool b) {
    _isLoadingLogin = b;
    notifyListeners();
  }

  set setMsgImgstate(bool b) {
    _isLoadMsgImg = b;
    notifyListeners();
  }
}

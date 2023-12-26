
import 'package:flutter/cupertino.dart';

class menuProviderOptions with ChangeNotifier {
  bool _enablePopup =false;
  bool _disableImage =false;
  bool _isLogin=false;
  String _note ="";
  String dropDownValue="";
  bool get enablePopup => _enablePopup;
  bool get disableImage => _disableImage;
  String get note => _note;
  bool get isLogin => _isLogin;
  void changeIsLogin(bool val){
    _isLogin=val;
    notifyListeners();
  }
  void changePopupData(bool val){
    _enablePopup = val;
    notifyListeners();
  }
  void changeImageData(bool val){
    _disableImage = val;
    notifyListeners();
  }
  void setNotes(String n){
     _note=n;
     notifyListeners();
  }
  void changeDropDownValue(String val){
    dropDownValue = val;
    notifyListeners();
  }

}
// import 'package:flutter/material.dart';
//
// class model {
//   Locale _applocal =Locale('en');
//   Locale get applocal => _applocal?? Locale('en');
//   //var locality ;
//   //Locale getlocality () => _applocal ?? Locale('ar');
//
//    changedriction (){
//     if(_applocal == Locale('ar')){
//       _applocal =Locale('en');
//     }
//     else
//       _applocal =Locale('ar');
//   }
// }

import 'package:flutter/material.dart';

import 'models/peermission.dart';

class modelprovider with ChangeNotifier  {
  Locale _applocal =const Locale('ar');
  Locale get applocal => _applocal ;
  PermissionLogin permissionLoginForReturn=PermissionLogin();
  changedriction (){
    if(_applocal ==const Locale('ar')){
      _applocal =const Locale('en');
    }
    else {
      _applocal =const Locale('ar');
    }
    notifyListeners();
  }
  changeDropDown ( String dropValue){
    if(dropValue == "English"){
      _applocal =const Locale('en');
    }
    else {
      _applocal =const Locale('ar');
    }
    notifyListeners();
  }
}
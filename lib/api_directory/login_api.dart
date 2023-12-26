import 'dart:io';

import 'package:apex/costants/api_url.dart';
import 'package:apex/models/peermission.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../models/login_data.dart';

class loginapi with ChangeNotifier {
  var result;
  static String token = "";
  bool _load = false;
  bool get loaded => _load;
  checkloding(bool val) {
    _load = val;
    notifyListeners();
  }

  Future<LoginData> logincheck(String user_name, password, company_name) async {
    LoginData res = LoginData();
    var data;
   List<PermissionLogin> permissionLogin=[];
    checkloding(true);
    _load = true;
    // var loginUrl = 'https://erpback.apex-program.com/api/Login';
    var loginUrl = "$basicUrl/Login";
    try {
      var url = Uri.parse(loginUrl);
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: convert.jsonEncode({
            'companyName': company_name,
            'username': user_name,
            'password': password
          }));
      //print("the status code in login is ${response.statusCode}");
      if (response.statusCode == 200) {
        checkloding(false);
        _load = true;
        data = convert.jsonDecode(response.body);

        result = data['result'];
        if (result == 1) {
          token = data['data']['authToken']['token'];
          notifyListeners();
          PermissionLogin permissionLoginTemp=PermissionLogin();
          for(var permission in data['data']["premissions"]){

            if(permission['id'] == 72 ||permission['id']==73 ){
              permissionLoginTemp=PermissionLogin();
              permissionLoginTemp.id=permission['id'];
              permissionLoginTemp.isAdd=permission['isAdd'];
              permissionLoginTemp.isEdit=permission['isEdit'];
              permissionLoginTemp.isDelete=permission['isDelete'];
              permissionLoginTemp.isShow=permission['isShow'];
              permissionLoginTemp.isPrint=permission['isPrint'];
              permissionLogin.add(permissionLoginTemp);
              //break;
            }
          }
        }
      }

      res.result = data['result'];
      res.permissionLogin=permissionLogin;
      res.errorMassageAr = data['errorMessageAr'];
      res.errorMassageEn = data['errorMessageEn'];
    } on SocketException {
      res.socketError = "internet check";
    } on FormatException {
      print("problem retrieve data ");
    } catch (e) {
      res.socketError = e.toString();
      print("the error is ${e.toString()}");
      checkloding(false);
    }
    notifyListeners();
    return res;
  }
}

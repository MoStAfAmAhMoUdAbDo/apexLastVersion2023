//http://192.168.1.253:8091/api/Store/GeneralAPIs/getEmployeeBranchs
import 'dart:io';
import 'package:apex/costants/api_url.dart';
import 'package:apex/models/branch_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../models/login_data.dart';
///api/GeneralLedger/Branch/GetAllBranchesDropDown
class GetEmployeeBranch  {

  Future<LoginData> getEmployeeBranch() async {
    LoginData res = LoginData();
    var data;
    var branch = "$basicUrl/Store/GeneralAPIs/getEmployeeBranchs";
    try {
      var url = Uri.parse(branch);
      var response = await http.get(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},);
      //print("the status code in login is ${response.statusCode}");
      var jsonResponse = convert.jsonDecode(response.body);
      if(response.statusCode==200){
        EmployeeBranch employeeBranch=EmployeeBranch();
        for(var c in jsonResponse['data']){
          employeeBranch=EmployeeBranch.fromJson(c);
          res.employeeBranch!.add(employeeBranch);
        }
      }
      res.result = data['result'];
      res.errorMassageAr = data['errorMessageAr'];
      res.errorMassageEn = data['errorMessageEn'];
    } on SocketException {
      res.socketError = "internet check";
    } on FormatException {
      print("problem retrieve data ");
    } catch (e) {
      res.socketError = e.toString();
      print("the error is ${e.toString()}");
    }
    return res;
  }
}

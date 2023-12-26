import 'dart:io';
import 'package:apex/costants/api_url.dart';
import 'package:apex/models/branch_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../models/login_data.dart';
import 'login_api.dart';
///api/GeneralLedger/Branch/GetAllBranchesDropDown
class GetAllBranchesDropDown  {

  Future<LoginData> getAllBranchesDropDown() async {
    LoginData res = LoginData();
    var branch = "$basicUrl/GeneralLedger/Branch/GetAllBranchesDropDown";
    String auth ="Bearer ${loginapi.token}";
    try {
      var url = Uri.parse(branch);
      var response = await http.get(url,headers: {
        HttpHeaders.authorizationHeader: auth,
        HttpHeaders.contentTypeHeader: 'application/json'
      });
      //print("the status code in login is ${response.statusCode}");
      var jsonResponse = convert.jsonDecode(response.body);
      if(response.statusCode==200){
       List<EmployeeBranch> employeeBranch=[];
        for(var c in jsonResponse['data']){
          employeeBranch.add(EmployeeBranch.fromJson(c));
        }
       res.employeeBranch = employeeBranch;
      }
      res.result = jsonResponse['result'];
      res.errorMassageAr = jsonResponse['errorMessageAr'];
      res.errorMassageEn = jsonResponse['errorMessageEn'];
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

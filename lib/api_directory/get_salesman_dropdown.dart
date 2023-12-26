
import 'dart:io';
import 'package:apex/costants/api_url.dart';
import 'package:apex/models/branch_model.dart';
import 'package:apex/models/salesman_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../models/login_data.dart';
import 'login_api.dart';
///api/GeneralLedger/Branch/GetAllBranchesDropDown
class GetSalesManDropDown  {
  Future<LoginData> getSalesManDropDown(int pageSize ,int pageNumber ) async {
    LoginData res = LoginData();
    String salesManUrl = "$basicUrl/Store/SalesMan/GetSalesManDropDown";
    Map<String,String>queryParameter ={
      "pageSize":pageSize.toString(),
      "pageNumber" :pageNumber.toString()
    };
    String queryString =Uri(queryParameters: queryParameter).query;
    String requestUrl ="$salesManUrl?$queryString";
    String auth ="Bearer ${loginapi.token}";
    try {
      var url = Uri.parse(requestUrl);
      var response = await http.get(url,headers: {
        HttpHeaders.authorizationHeader: auth,
        HttpHeaders.contentTypeHeader: 'application/json'
      });
      //print("the status code in login is ${response.statusCode}");
      var jsonResponse = convert.jsonDecode(response.body);
      if(response.statusCode==200){
       List<SalesManModel> salesManModel=[];
        for(var c in jsonResponse['data']){
          salesManModel.add(SalesManModel.fromJson(c));

        }
       res.salesMan=salesManModel;
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

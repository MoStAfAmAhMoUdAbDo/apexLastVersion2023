///GeneralLedger/FinancialAccount/GetFinancialAccountDropDown
import 'dart:io';
import 'package:apex/costants/api_url.dart';
import 'package:apex/models/branch_model.dart';
import 'package:apex/models/financial_setting_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../models/get_financial_account_model.dart';
import '../models/login_data.dart';
import 'login_api.dart';
class GetFinancialDropDown{
  Future<LoginData> getFinancialDropDown(int pageSize ,int pageNumber) async {
    LoginData res = LoginData();
    var financialAccountUrl = "$basicUrl/GeneralLedger/FinancialAccount/GetFinancialAccountDropDown";
    Map<String,String>queryParameter ={
      "pageSize":pageSize.toString(),
      "pageNumber" :pageNumber.toString()
    };
    String queryString =Uri(queryParameters: queryParameter).query;
    String requestUrl ="$financialAccountUrl?$queryString";
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
        List<GetFinancialAccountDropDownModel> financialAccount=[];
        for(var c in jsonResponse['data']){
          financialAccount.add(GetFinancialAccountDropDownModel.fromJson(c));
        }
        res.financialDropDown = financialAccount ;
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
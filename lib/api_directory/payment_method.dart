import 'package:apex/api_directory/login_api.dart';
//import 'package:apex/models/category_data..dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:io';
import '../costants/api_url.dart';
import '../models/other_payment_method.dart';
import '../screens/loginpagearabe.dart';

class OtherPaymentMethods {

  Future<List<PaymentMethods>> getPaymentMethods() async {
    List<PaymentMethods> generalData=[];
    String url ="$basicUrl/Store/PaymentMethods/GetPaymentMethodsDropdown";
    String authorization = "Bearer ${loginapi.token}";
    Map<String,String> queryParameter={
      "isReceipts" : "false"
    };
    String queryString =Uri(queryParameters: queryParameter).query;
    String requestUrl ="$url?$queryString";
    try {
      var response = await http.get(Uri.parse(requestUrl), headers: {
        HttpHeaders.authorizationHeader: authorization,
        HttpHeaders.contentTypeHeader: 'application/json'
      });
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        //generalData =PaymentMethods.fromJson(jsonResponse["data"]);
        for(var p in jsonResponse["data"] ){
          generalData.add(PaymentMethods.fromJson(p));
        }
      } else {
        print("data failed in payment method api ");
      }
    } catch (e) {
      showSnack(e.toString());
      print("there is error is ${e.toString()}");
    }
    return generalData;
  }
}

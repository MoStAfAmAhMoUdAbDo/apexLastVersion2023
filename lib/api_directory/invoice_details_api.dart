import 'dart:io';
import 'package:apex/costants/api_url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../models/login_data.dart';
import 'login_api.dart';

class InvoiceDataApi {
  Future<LoginData> invoiceDataApi(Map<String , dynamic> invoiceJson,bool isArabic) async {
    //int result=0;
    LoginData res = LoginData();
    var loginUrl =  "$basicUrl/Store/POS/AddPOSInvoice";
    String auth1 = "Bearer ${loginapi.token}";
    try {
      Map<String,String> queryParameter={
        'isArabic': isArabic.toString(),
      };
      String queryString =Uri(queryParameters: queryParameter).query;
      loginUrl ="$loginUrl?$queryString";
      var url = Uri.parse(loginUrl);
      var response = await http.post(url,
          headers: {
            HttpHeaders.authorizationHeader: auth1,
            HttpHeaders.contentTypeHeader: 'application/json'
          },
          body: convert.jsonEncode(invoiceJson),);

      //     .timeout(
      //   const Duration(seconds: 10),
      //   onTimeout: () {
      //     // Time has run out, do what you wanted to do.
      //     return http.Response('Error', 408); // Request Timeout response status code
      //   },
      // );

      var jsonResponse = convert.jsonDecode(response.body);
      res.result = jsonResponse['result'];
      res.statusCode= response.statusCode;
      if(res.result==1){
        res.isPrint=jsonResponse['isPrint'];
        res.resultForPrint=jsonResponse['resultForPrint'];
        res.fileUrl=jsonResponse['fileURL'];
      }
      res.errorMassageAr = jsonResponse['errorMessageAr'];
      res.errorMassageEn = jsonResponse['errorMessageEn'];
    } catch (e) {
      res.socketError=e.toString();
      print(e.toString());
    }
    return res ;
  }
}

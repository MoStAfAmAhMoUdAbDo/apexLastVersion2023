import 'package:apex/api_directory/login_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:io';
import '../costants/api_url.dart';
import '../models/login_data.dart';

class InvoicePaymentUpdate{
  Future<LoginData> invoicePaymentUpdate(Map<String , dynamic> invoiceJson,bool isArabic ) async {
    LoginData res = LoginData();
    var loginUrl =  "$basicUrl/Store/POS/UpdatePOSInvoice";
    String auth1 = "Bearer ${loginapi.token}";
    try {
      Map<String, String> queryParameter = {
        'isArabic': isArabic.toString(),
        //'unique_id': ''
      };
      String queryString =Uri(queryParameters: queryParameter).query;
      // String requestUrl ="$url?$queryString";
      loginUrl ="$loginUrl?$queryString";
      var url = Uri.parse(loginUrl);
      var response = await http.put(url,
          headers: {
            HttpHeaders.authorizationHeader: auth1,
            HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8'
          },
          body: convert.jsonEncode(invoiceJson));
      var jsonResponse = convert.jsonDecode(response.body);
      res.result = jsonResponse['result'];
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
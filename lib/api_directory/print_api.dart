
import '../costants/api_url.dart';
import '../models/printing_model.dart';
import '../screens/loginpagearabe.dart';
import 'login_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:io';
import '../models/other_payment_method.dart';

class PrintingApi{
  Future<PrintModel> printInvoices(int invoiceId ,String invoiceCode,bool isArabic) async {
    PrintModel printData=PrintModel();
    String url ="$basicUrl/InvioceReport/InvoiceReport";
    String authorization = "Bearer ${loginapi.token}";
    Map<String,String> queryParameter={
      "invoiceTypeId" : "11",
      "invoiceId" : invoiceId.toString(),
      "isArabic" : isArabic.toString(),
      "screenId" : "72",
      "invoiceCode" : invoiceCode.toString(),
      "exportType" : "1"
    };
    String queryString =Uri(queryParameters: queryParameter).query;
    String requestUrl ="$url?$queryString";
    try {
      var response = await http.get(Uri.parse(requestUrl), headers: {
        HttpHeaders.authorizationHeader: authorization,
        HttpHeaders.contentTypeHeader: 'application/json'
      });
      var jsonResponse = convert.jsonDecode(response.body);
      printData.result =jsonResponse["result"]["result"];
      if (response.statusCode == 200) {

        printData.fileUrl= jsonResponse["result"]["fileURL"];

      } else {
        print("data failed in payment method api ");
      }
    } catch (e) {
      showSnack(e.toString());
      print("there is error is ${e.toString()}");
    }
    return printData;
  }
}

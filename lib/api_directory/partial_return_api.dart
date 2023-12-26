import 'dart:io';
import 'package:apex/api_directory/login_api.dart';
import 'package:apex/costants/api_url.dart';
import 'package:http/http.dart'as http;
//----------------------
import 'dart:convert' as convert;
import '../models/invoice_data_object.dart';
import '../screens/loginpagearabe.dart';
import 'get_pos invoice by id.dart';

class PartialReturn{

  partialReturn(String invoiceCode)async{
    //String apiUrl="$basicUrl/Store/POS/GetPOSInvoiceById?InvoiceId=$id";
    String apiUrl="$basicUrl/Store/POS/GetReturnPOS";
    Map<String,String> queryParameter={
      "invoiceCode" : invoiceCode.toString(),
      "ForIOS" : "true"
    };
    String queryString =Uri(queryParameters: queryParameter).query;
    String requestUrl ="$apiUrl?$queryString";
    String auth ="Bearer ${loginapi.token}";
    InvoiceDataEditeApi invoiceDataEditeApi=InvoiceDataEditeApi();
    try{
      var response = await http.get(Uri.parse(requestUrl), headers: {
        HttpHeaders.authorizationHeader: auth,
        HttpHeaders.contentTypeHeader: 'application/json'
      });
      var jsonResponse = convert.jsonDecode(response.body);
      invoiceDataEditeApi.result=jsonResponse['result'];
      //invoiceDataEditeApi.result = jsonResponse['result'];
      if(invoiceDataEditeApi.result==1){
        invoiceDataEditeApi.invoiceData=InvoiceData.fromJson(jsonResponse['data'][0]);
      }

      invoiceDataEditeApi.errorMessageAr = jsonResponse['errorMessageAr'];
      invoiceDataEditeApi.errorMessageEn = jsonResponse['errorMessageEn'];

    }catch(e){
      showSnack(e.toString());
      print(e.toString());
    }
    return invoiceDataEditeApi;

  }
}
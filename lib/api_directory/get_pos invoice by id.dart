import 'dart:io';
import 'package:apex/api_directory/login_api.dart';
import 'package:apex/costants/api_url.dart';
import 'package:http/http.dart'as http;
//----------------------
import 'dart:convert' as convert;
import '../models/invoice_data_object.dart';
import '../screens/loginpagearabe.dart';

class GetInvoiceById{

  getInvoiceById(int id)async{
    //String apiUrl="$basicUrl/Store/POS/GetPOSInvoiceById?InvoiceId=$id";
    String apiUrl="$basicUrl/Store/POS/GetPOSInvoiceById";
    Map<String,String> queryParameter={
      "InvoiceId" : id.toString(),
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
class InvoiceDataEditeApi{

  int? result;
  String? errorMessageAr;
  String? errorMessageEn;
  InvoiceData? invoiceData;

  InvoiceDataEditeApi([this.invoiceData,this.result,this.errorMessageAr,this.errorMessageEn]);
}
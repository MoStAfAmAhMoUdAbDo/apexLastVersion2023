
import 'package:apex/costants/api_url.dart';

import '../models/all_invoice_data.dart';
import '../models/get_invoice_api.dart';
import '../models/login_data.dart';
import '../screens/loginpagearabe.dart';
import 'login_api.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
class GetAllPosInvoice{
  getAllPosInvoice([var pageNumber ,var pageSize,var invoiceType ,var dateFrom ,var dateTo ,var PersonId ,var invoiceDate ,isReturned])async{
      String invoiceUrl ="$basicUrl/Store/POS/GetAllPOSInvoices";//POS/GetAllPOSInvoices
    String auth1 = "Bearer ${loginapi.token}";
    //var temp =invoiceDate==null ? "": invoiceDate;
    DataFromApi res = DataFromApi();
    List<AllInvoiceData> invoices=[];
    try {
      var url = Uri.parse(invoiceUrl);
      var response = await http.post(url,
          headers: {
            HttpHeaders.authorizationHeader: auth1,
            HttpHeaders.contentTypeHeader: 'application/json'
          },
          body: convert.jsonEncode({
            'PageNumber': pageNumber,
            'PageSize': pageSize,
            'InvoiceTypeId': 11,//come from text of invoice code
            'DateFrom': dateFrom.toString(),
            'DateTo': dateTo.toString(),
            'invoiceType':invoiceType,
            'IsReturn': isReturned,
            'PersonId' :PersonId,
            'invoiceDate' :invoiceDate.toString()
          }));
      var jsonResponse = convert.jsonDecode(response.body);
      res.result = jsonResponse['result'];
      if(res.result==1){
        for (var c in jsonResponse['data']) {
          invoices.add(AllInvoiceData.fromJson(c));
        }
        res.data=invoices;
        //print("the all invoice is ${ jsonResponse['data']}");
      }

      res.errorMassageAr = jsonResponse['errorMessageAr'];
      res.errorMassageEn = jsonResponse['errorMessageEn'];
    } catch (e) {
      res.socketError=e.toString();
      showSnack(e.toString());
      print(e.toString());
    }
    return res ;

  }

}

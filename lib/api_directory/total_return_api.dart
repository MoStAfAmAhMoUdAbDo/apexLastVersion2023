import 'package:apex/costants/api_url.dart';
import '../models/all_invoice_data.dart';
import '../models/get_invoice_api.dart';
import '../models/login_data.dart';
import '../screens/loginpagearabe.dart';
import 'login_api.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class TotalReturn {
  totalReturn(int invoiceId, bool isArabic) async {
    String invoiceUrl = "$basicUrl/Store/POS/AddPOSTotalReturnInvoice";
    String auth1 = "Bearer ${loginapi.token}";
    //var temp =invoiceDate==null ? "": invoiceDate;
    LoginData res = LoginData();
    List<AllInvoiceData> invoices = [];
    try {
      Map<String, String> queryParameter = {
        'isArabic': isArabic.toString(),
        "id": invoiceId.toString()

      };
      String queryString = Uri(queryParameters: queryParameter).query;
      invoiceUrl = "$invoiceUrl?$queryString";
      //       var url = Uri.parse(loginUrl);
      var url = Uri.parse(invoiceUrl);
      var response = await http.post(
        url,
        headers: {
          HttpHeaders.authorizationHeader: auth1,
          HttpHeaders.contentTypeHeader: 'application/json'
        },
      );
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
      res.socketError = e.toString();
      showSnack(e.toString());
      print(e.toString());
    }
    return res;
  }
}

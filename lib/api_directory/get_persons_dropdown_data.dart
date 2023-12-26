
import 'package:apex/costants/api_url.dart';
import '../models/all_invoice_data.dart';
import '../models/get_invoice_api.dart';
import '../screens/loginpagearabe.dart';
import 'login_api.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class GetPersonDropDown{

  getPersonDropDown(int pageNumber ,int pageSize,[String searchCriteria=""])async{
    String invoiceUrl ="$basicUrl/Store/Persons/GetPersonsDropDown";

    String auth1 = "Bearer ${loginapi.token}";
    DataFromApi res = DataFromApi();
    List<PersonInvoiceDropDown> persons=[];
    try {
      Map<String, dynamic> queryParameter = {
        'PageNumber': pageNumber.toString(),
        'PageSize': pageSize.toString(),
        'IsSupplier': "false",
        "SearchCriteria" :searchCriteria
      };
      String queryString = Uri(queryParameters: queryParameter).query;
      String requestUrl ="$invoiceUrl?$queryString";
      var url = Uri.parse(requestUrl);
      var response = await http.get(url,
          headers: {
            HttpHeaders.authorizationHeader: auth1,
            HttpHeaders.contentTypeHeader: 'application/json'
          });
      var jsonResponse = convert.jsonDecode(response.body);
      res.result = jsonResponse['result'];
      if(res.result==1){
        // print(jsonResponse["data"]);
        for (var c in jsonResponse['data']) {
          persons.add(PersonInvoiceDropDown.fromJson(c));
        }
        res.data=persons;
        //print(res.data![0].arabicName);
      }

      res.errorMassageAr = jsonResponse['errorMessageAr'];
      res.errorMassageEn = jsonResponse['errorMessageEn'];
    } catch (e) {
      showSnack(e.toString());
      print(e.toString());
    }
    return res ;

  }
}
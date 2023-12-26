

import 'package:apex/costants/api_url.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


import '../models/login_data.dart';
import 'login_api.dart';
class OpenPosSession{
  openPosSession()async{
   String sessionUrl="$basicUrl/Store/POS/OpenPOSSeassion";
   LoginData res = LoginData();
   String auth1 = "Bearer ${loginapi.token}";
   try {
     var url = Uri.parse(sessionUrl);
     var response = await http.post(url,
         headers: {
           HttpHeaders.authorizationHeader: auth1,
           HttpHeaders.contentTypeHeader: 'application/json'
         },);
     var jsonResponse = convert.jsonDecode(response.body);
     res.result = jsonResponse['result'];
     res.errorMassageAr = jsonResponse['errorMessageAr'];
     res.errorMassageEn = jsonResponse['errorMessageEn'];
   } catch (e) {
     res.socketError=e.toString();
     print(e.toString());
   }
   return res ;
  }
}
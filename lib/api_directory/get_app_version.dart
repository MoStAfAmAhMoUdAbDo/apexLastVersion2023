
import 'dart:io';

import 'package:apex/costants/api_url.dart';
import 'package:apex/models/login_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../screens/loginpagearabe.dart';
class GetAppNewVersion{

  checkForAppNewVersion() async{
    AppVersionInfo appVersionInfo=AppVersionInfo();
    try{

      String url="${appVersionUrl}/GetMobileAppVersion";
      var uri=Uri.parse(url);
      var response=await http.get(uri,headers: {
        HttpHeaders.contentTypeHeader:'application/json'
      });
      var jsonResponse = convert.jsonDecode(response.body);
      appVersionInfo.result = jsonResponse['result'];
      //appVersionInfo=AppVersionInfo.fromJson(jsonResponse['data']);
      appVersionInfo.VersionNumber=jsonResponse['data']['versionNumber'];
      appVersionInfo.AppStoreUrl=jsonResponse['data']['iOSPath'];
      appVersionInfo.PlayStoreUrl=jsonResponse['data']['androidPath'];
    }catch(e){
     // res.socketError=e.toString();
      showSnack(e.toString());
      print(e.toString());
    }
    return appVersionInfo;
  }
}
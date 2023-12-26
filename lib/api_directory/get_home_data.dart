import 'dart:io';
import 'package:apex/api_directory/login_api.dart';
import 'package:apex/costants/api_url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../models/items.dart';
import '../screens/loginpagearabe.dart';

class getHomeData {
  //int pageSize = 50;

  Future<List<Item>> getCategoryData(int pageNumber,int lastIndex,
      [String itemSearchName = "", int categoryId = 0 ,pageSize =50] ) async {
    //print("the page size is $pageSize");
    List<Item> dataM = [];
    String url =  "$basicUrl/Store/POSTouch/getItemsOfPOSIOS";
    String auth1 = "Bearer ${loginapi.token}";
    Map<String, dynamic> queryParameter = {
      "pageSize": pageSize.toString(),
      "PageNumber": pageNumber.toString(),
      "categoryId": categoryId.toString(),
      "itemName": itemSearchName.toString(),
      "lastId" : lastIndex.toString()
    };
    String queryString = Uri(queryParameters: queryParameter).query;
    String requestUrl ="$url?$queryString"; //url + '?' + queryString;      i use this before
    try {

      var response = await http.get(Uri.parse(requestUrl), headers: {
        HttpHeaders.authorizationHeader: auth1,
        HttpHeaders.contentTypeHeader: 'application/json'
      });
      //print("the status code of the get data of the home is ${response.statusCode}");
      var jsonResponse = convert.jsonDecode(response.body);
     // print("the result in else of home api is ${jsonResponse['result']}");
      if (response.statusCode == 200) {
        for (var c in jsonResponse['data']) {
          dataM.add(Item.fromJson(c));
        }
      } else {
       // print("the result in else of home api is ${jsonResponse['result']}");
       print("data failed to get home data ");
      }
    } catch (e) {
      showSnack(e.toString());
      print('Unknown exception: $e');
    }
    return dataM;
  }
}

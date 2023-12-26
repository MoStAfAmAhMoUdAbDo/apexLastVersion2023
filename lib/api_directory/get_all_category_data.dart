import 'package:apex/api_directory/login_api.dart';
import 'package:apex/models/category_data..dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:io';

import '../costants/api_url.dart';
import '../screens/loginpagearabe.dart';

class GetAllGategoryData {
  Future<List<CategoryData>> getAllCat() async {
    String url = "$basicUrl/Store/POSTouch/getCategoriesOfPOS";
    List<CategoryData> dataOfCategory = [];
    String authorization = "Bearer ${loginapi.token}";//authorization
    try {
      var response = await http.get(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader: authorization,
        HttpHeaders.contentTypeHeader: 'application/json'
      });
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        for (var c in jsonResponse['data']) {
          dataOfCategory.add(CategoryData.fromJson(c));
        }
      } else {
        print("data failed to get all category ");
      }
    } catch (e) {
      showSnack(e.toString());
      print("there is error is  ${e.toString()}");
    }
    return dataOfCategory;
  }
}

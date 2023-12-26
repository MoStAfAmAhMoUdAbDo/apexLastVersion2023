import 'dart:io';
//import 'dart:js';
import 'package:apex/api_directory/login_api.dart';
import 'package:apex/costants/api_url.dart';
import 'package:apex/models/login_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../models/items.dart';
import '../screens/loginpagearabe.dart';


class getBarcodeData {
  var result;
  Future<LoginData> searchBarcode(String barCode) async {
    LoginData barcodeItem =LoginData();
    var data;
    //print("the barcode result api is ${barCode}");
    var barcodeApi =  "$basicUrl/Store/POSTouch/FillItemForPOSIOS";
    String auth1 = "Bearer ${loginapi.token}";

    try {
      var url = Uri.parse(barcodeApi);
      var response = await http.post(url,
          headers: {
            HttpHeaders.authorizationHeader: auth1,
            HttpHeaders.contentTypeHeader: 'application/json'
          },
          body: convert.jsonEncode({
            'ItemCode':barCode,
            'InvoiceTypeId': "11",
            "PersonId": "2",
            "storeId": "1",
            "ParentInvoiceType": "",
            "invoiceId": "0",
            "InvoiceDate": DateTime.now().toString(),
            "oldData": [],
            "serialRemovedInEdit": false,
            "invoiceType": ""
          }));
      //print("the status code in barcode is ${response.statusCode}");
      data = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        // data = convert.jsonDecode(response.body);
        barcodeItem.result = data['result'];
        if (barcodeItem.result == 1) {
          barcodeItem.item = Item.fromBarCodeJson(data['data']);
        }
        else{
         // barcodeItem.result=data['result'];
          barcodeItem.errorMassageAr =data['errorMessageAr'];
          barcodeItem.errorMassageEn= data['errorMessageEn'];
        }
      }
      else{
        barcodeItem.result=data['result'];
        barcodeItem.errorMassageAr =data['errorMessageAr'];
        barcodeItem.errorMassageEn= data['errorMessageEn'];
      }
    } catch (e) {
      showSnack(e.toString());
      print(e.toString());
      barcodeItem.socketError=e.toString();

    }
    return barcodeItem;
  }
}

import 'dart:io';

import 'package:apex/customer/customer_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Getapi {
  Future<List<customer>> Get_data() async {
    List<customer> dataM = [];
    String mostafa =
        "http://192.168.1.253:8091/api/Store/Categories/GetListOfCategories?PageSize=5&PageNumber=1&Status=0&name=";

    String auth =
        " Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImN0eSI6IkpXVCJ9.eyJSb2xlRGV0YWlscyI6IkorT0ZWUlJGVVhIWXNNb1I3VU1ubXc9PSIsIkRCbmFtZSI6ImRzbGVzaHRRaGFFWFRXMlkzTFFwQ3VjalZVd3BXMm5OVVRGQXJSNGZuc0p0VTkwS1B3eXBtMHJIcWY2bk5PWVMiLCJ1c2VySUQiOiJHUHo5YUUwUEJ3cmJmMUJrNVI2SWN3PT0iLCJFbmRQZXJpb2RPbkVuZFBlcmlvZE9uIjoiMjcvMDMvMjAyNCAxMjowMDowMCDYtSIsImVtcGxveWVlSWQiOiJHUHo5YUUwUEJ3cmJmMUJrNVI2SWN3PT0iLCJDTCI6IjlMUVl0SUdoTUJtTVJja3cxYzFMT3c9PSIsImlzUE9TRGVza3RvcCI6IjAiLCJleHAiOjE2ODQ3Njc5ODEsImlzcyI6Imh0dHA6Ly93d3cuVGVzdC5jb20iLCJhdWQiOiJodHRwOi8vd3d3LlRlc3QuY29tIn0.UXozGpDe2TXi4W9EkRQMdKiBfxTOtwlFLRK8ifBSMq0";
    try {
      var url = Uri.parse(mostafa);
      // Await the http get response, then decode the json-formatted response.
      var response =
          await http.get(url, headers: {HttpHeaders.authorizationHeader: auth});

      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        for (var c in jsonResponse['data']) {
          dataM.add(customer.fromjson(c));
        }
      } else {
        print("data failed ");
      }
    } catch (e) {
      print('Unknown exception: $e');
    }
    return dataM;
  }
}

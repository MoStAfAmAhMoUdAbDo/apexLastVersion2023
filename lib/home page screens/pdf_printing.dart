import 'dart:io';
import 'dart:typed_data';
import 'package:apex/costants/api_url.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../api_directory/login_api.dart';
import 'new_preview_for_pdf.dart';
import 'new_print.dart';
//import 'new_screen.dart';

//import 'package:html/parser.dart' as parser;

class pdf_printing extends StatefulWidget {
  const pdf_printing({Key? key}) : super(key: key);

  @override
  State<pdf_printing> createState() => _pdf_printingState();
}

class _pdf_printingState extends State<pdf_printing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: print_pdf_network,
                    child:const  Text("print pdf"),
                  ),
                  ElevatedButton(
                    onPressed: share_pdf_network,
                    child:const  Text("share pdf"),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //         builder: (context) => const pdf_vew_sync()));
                  //   },
                  //   child:const  Text("new pdf view test"),
                  // ),
                  ElevatedButton(onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PDFPreview()));
                  },
                      child: Text("new View and Print method ")),
                  ElevatedButton(onPressed: printHtml, child: Text("print HTML file")),
                  ElevatedButton(onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PrintPage()));
                  }, child: Text("newprint method"))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> get_pdf() async {
    String url =
        "http://192.168.1.253:8091/api/Store/reportsOfMainData/ItemsPricesReportForIOSAndroid";
    String auth =
        "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImN0eSI6IkpXVCJ9.eyJSb2xlRGV0YWlscyI6IkorT0ZWUlJGVVhIWXNNb1I3VU1ubXc9PSIsIkRCbmFtZSI6Ink4Y29XQ0lTQ3dpa0dRdTViRHc4WlhKNUZvTFZabVVSRy9GSzN3OGVSVHdoYk95MG1MM2pNZnh6WWpsR0ZkRWciLCJ1c2VySUQiOiJVT1FUeGFraVNWWTdhbEE0VlNjUDRRPT0iLCJFbmRQZXJpb2RPbkVuZFBlcmlvZE9uIjoiMTAvMDgvMjAyMyAxMjowMDowMCDYtSIsImVtcGxveWVlSWQiOiJVT1FUeGFraVNWWTdhbEE0VlNjUDRRPT0iLCJDTCI6InFtb3VhU3gzMjNVSEdjMlR6U3lZbUE9PSIsImlzUE9TRGVza3RvcCI6IjAiLCJpc1BlcmlvZEVuZGVkIjoiRmFsc2UiLCJleHAiOjE2ODY5MzI3NTIsImlzcyI6Imh0dHA6Ly93d3cuVGVzdC5jb20iLCJhdWQiOiJodHRwOi8vd3d3LlRlc3QuY29tIn0.RBkT6yEHimHa0vMqjE93pcbbSHkTNaZG25y39-eWyJA";
    Map<String, dynamic> queryParameter = {
      "exportType": "1",
      "isArabic": "true",
      "pageSize": "100",
      "pageNumber": "1",
      "itemId": "0",
      "statues": "0",
      "itemTypes": "0",
      "catId": "0"
    };
    String queryString = Uri(queryParameters: queryParameter).query;
    String requestUrl = url + '?' + queryString;
    var response = await http.get(Uri.parse(requestUrl), headers: {
      HttpHeaders.authorizationHeader: auth,
      HttpHeaders.contentTypeHeader: 'application/json'
    });
    //print("status code${response.statusCode}");
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      // print("the url in get is ${jsonResponse["result"]["fileURL"]}");
      return jsonResponse["result"]["fileURL"];
    } else {
      print("data faild ");
    }
  }

//http.Response response = await http.get(Uri.parse('http://www.africau.edu/images/default/sample.pdf'));
  void print_pdf_network() async {
    //String path= await get_pdf();
    //print("on function print");
    String authorization = "Bearer ${loginapi.token}";
    // http.Response response = await http.get(Uri.parse(path.toString()));


    var response = await http.get(Uri.parse(
        "$basicUrl/InvioceReport/InvoiceReport?invoiceTypeId=38&invoiceId=20&isArabic=true&screenId=110&invoiceCode=1-OP-436&exportType=1&unique_id=3wgebyr6zbp"
    ) ,headers: {
    HttpHeaders.authorizationHeader: authorization,
    HttpHeaders.contentTypeHeader: 'application/json'
    },);
    // var jsonResponse = convert.jsonDecode(response.body);
    // response = await http.get(Uri.parse(
    //     "$basicUrl/InvioceReport/InvoiceReport?invoiceTypeId=38&invoiceId=20&isArabic=true&screenId=110&invoiceCode=1-OP-436&exportType=1&unique_id=3wgebyr6zbp"
    // ) ,headers: {
    //   HttpHeaders.authorizationHeader: authorization,
    //   HttpHeaders.contentTypeHeader: 'application/json'
    // },);
    // var response = await http.get(Uri.parse(
    //     "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf"));
    //print("after print request");
    var pdfData = response.bodyBytes;
    final printers = await Printing.listPrinters();
    //print("status code is ${response.statusCode}");
    if (response.statusCode == 200) {
     // print("in statuse code 200");
      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdfData);
      // await Printing.directPrintPdf (
      //     printer: Printer(url: 'name of your device(printer name)'
      //     ),
      //     onLayout: (format) async=> pdfData );


    } else {
      print("has no data and return false");
    }

    // direct print with fixed printer
    // await Printing.directPrintPdf (
    //     printer: Printer(url: 'name of your device(printer name)'
    //     ),
    //     onLayout: (format) async=> pdfData );
  }

  void createpdf() async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Text("wefqer"),
            );
          }),
    );
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  void share_pdf_network() async {
    //String path= await get_pdf();
    //var data = await http.get(Uri.parse(path.toString()));
    var data = await http.get(Uri.parse(
        "http://192.168.1.253:1001/files/ItemsPrices-15062023122609%D9%85.pdf"));
    if (data.statusCode == 200) {
      Printing.sharePdf(bytes: data.bodyBytes, filename: "document.pdf");
    } else {
      print("data faild to share");
    }
  }

  ///PdfPreview(
//           build: (format) => _generatePdf(format, title),
//         ),
Widget viewPdf(){
    print("in pdf preview ");
    return PdfPreview(
        build: (format) => getPdf(),
            //_generatePdf(format,"jhhk"),
      allowPrinting: true,
      allowSharing: true,
    );
}
Future<Uint8List>getPdf()async{

  //print("in get data pdf ");
  var data = await http.get(Uri.parse(
    "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf"));

    return data.bodyBytes;
}

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(
                width: double.infinity,
                child: pw.FittedBox(
                  child: pw.Text(title, style: pw.TextStyle(font: font)),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Flexible(child: pw.FlutterLogo())
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  void printHtml() async{
    //final printerIp = _ipController.text;
//http://192.168.1.253:55/files/11-08102023031713%D9%85.html
    String authorization = "Bearer ${loginapi.token}";
    var response = await http.get(Uri.parse(
        "$basicUrl/InvioceReport/InvoiceReport?invoiceTypeId=38&invoiceId=20&isArabic=true&screenId=110&invoiceCode=1-OP-436&exportType=1&unique_id=3wgebyr6zbp"
    ) ,headers: {
      HttpHeaders.authorizationHeader: authorization,
      HttpHeaders.contentTypeHeader: 'application/json'
    },);
    var jsonResponse = convert.jsonDecode(response.body);
    //var url =jso
  var data =await http.get(Uri.parse("http://192.168.1.253:55/files/test2.pdf"),);
  //final printers = await Printing.listPrinters();

  // final printerPort = 9100;
  //      final printerAddress = InternetAddress("192.168.1.54");
  //       final socket = await Socket.connect(printerAddress, printerPort);
  //      socket.add(data.bodyBytes);
  //      await socket.close();
//print("object");
  await Printing.directPrintPdf(
      onLayout: (PdfPageFormat format) async => data.bodyBytes,
    dynamicLayout: false,
    usePrinterSettings: false, printer: Printer(url: "192.168.1.84"),
    
  );
print("kml,l");



///  final printerIp = _ipController.text;
//
//     try {
//       final printerPort = 9100;
//       final printerAddress = InternetAddress(printerIp);
//
//       final pdfDoc = createPDF();
//       final data = pdfDoc.save();
//
//       final socket = await Socket.connect(printerAddress, printerPort);
//       socket.add(data);
//       await socket.close();
  // var myPrinter = await Printing.pickPrinter(context: context);
  // print("the printer is ");
  // print(myPrinter);
    // await Printing.directPrintPdf (
    //     printer: printers.first,
    //     onLayout: (format) async=> data.bodyBytes );

  // await Printing.layoutPdf(
  //     onLayout: (PdfPageFormat format) async => data.bodyBytes);
// pw.Document document =
//     await Printing.layoutPdf(
//         onLayout: (PdfPageFormat format) async => await Printing.convertHtml(
//           format: format,
//           html: data.body,
//         ));
  }
}




import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
//import 'dart:convert' as convert;
// import '../api_directory/login_api.dart';
// import 'new_screen.dart';
// import 'dart:io';
// import 'package:apex/costants/api_url.dart';
//import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;

class PDFPreview extends StatefulWidget {
  const PDFPreview({super.key});

  @override
  State<PDFPreview> createState() => _PDFPreviewState();
}


class _PDFPreviewState extends State<PDFPreview> {
  var data;

  @override
  void initState() {
    // TODO: implement initState
    data= getPdf();
    super.initState();
  }
  Future<Uint8List>getPdf()async{

    // final printer =Printing.listPrinters();
    // print("the printer available is ");
    // print(printer);
    //http://192.168.1.253:8091/api/InvioceReport/InvoiceReport?invoiceTypeId=11&invoiceId=6709&isArabic=true&screenId=72&invoiceCode=11
    //print("in get data pdf ");
    var data = await http.get(Uri.parse(
        "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf"));
    return data.bodyBytes;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:data ==null ? CircularProgressIndicator():
      PdfPreview(build: (format)=>data
      ),
    );
  }

}

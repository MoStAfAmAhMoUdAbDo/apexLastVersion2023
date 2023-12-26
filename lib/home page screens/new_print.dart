import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:apex/costants/api_url.dart';
// import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
// import 'dart:convert' as convert;
// import '../api_directory/login_api.dart';
// import 'new_preview_for_pdf.dart';
// import 'new_print.dart';
// import 'new_screen.dart';

class PrintPage extends StatefulWidget {
  @override
  _PrintPageState createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  final _ipController = TextEditingController();
  String _message = '';

  pdfWidgets.Document createPDF() {
    final pdf = pdfWidgets.Document();

    pdf.addPage(
      pdfWidgets.Page(
        build: (pdfWidgets.Context context) => pdfWidgets.Center(
          child: pdfWidgets.Text("Hello World", style: pdfWidgets.TextStyle(fontSize: 40)),
        ),
      ),
    );

    return pdf;
  }

  Future<void> printToNetworkPrinter() async {
    final printerIp = _ipController.text;

    try {
      final printerPort = 9100;
      final printerAddress = InternetAddress(printerIp);

      final pdfDoc = createPDF();
      final data =await pdfDoc.save();

      final socket = await Socket.connect(printerAddress, printerPort);
      socket.add(data);
      await socket.close();

      setState(() {
        _message = 'Sent to printer!';
      });
    } catch (e) {
      setState(() {
        _message = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Print to IP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _ipController,
              decoration: InputDecoration(labelText: 'Printer IP Address'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:()async{
                await printPdfDirectly("http://192.168.1.253:55/files/test2.pdf", '192.168.1.84',515 );//9100
              } ,
              child: Text('Print'),
            ),
            SizedBox(height: 20),
            Text(_message),
          ],
        ),
      ),
    );
  }
}

Future<void> printPdfDirectly(String url, String printerIp, int printerPort) async {
  try {
    // 1. Download the PDF
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final pdfData = response.bodyBytes;

      // 2. Send PDF data to the printer
      final printerAddress = InternetAddress(printerIp,
          type: InternetAddressType.IPv4
      );
      final socket = await Socket.connect(printerAddress, printerPort);

      socket.add(pdfData);
      socket.write("nnnnnn");
      socket.write("object");
      await socket.flush();
      await socket.close();

      // final printer = await Printer.connect('192.168.1.100', port: 9100);
      // printer.println('welcome',
      //     styles: PosStyles(
      //       height: PosTextSize.size2,
      //       width: PosTextSize.size2,
      //     ));
      //
      // printer.cut();
      // printer.disconnect();
     // print('PDF sent to printer successfully.');
    } else {
      print('Failed to fetch the PDF data. HTTP Status: ${response.statusCode}');
    }
  } on SocketException catch (e) {
    print('Socket Exception: $e');
  } on HttpException catch (e) {
    print('HTTP Exception: $e');
  } on Exception catch (e) {
    print('General Exception: $e');
  }
}

// Future<void> _printReceipt() async {
//   final profile = await CapabilityProfile.load();
//   final printer = NetworkPrinter(PaperSize.mm80, profile);
//
//   const String printerIp = '192.168.1.100'; // Replace with the IP address of your network printer
//   const int printerPort = 9100; // Replace with the port number of your network printer
//
//   final PosPrintResult res = await printer.connect(printerIp, printerPort);
//
//   if (res != PosPrintResult.success) {
//     print('Failed to connect to the printer. Error: $res');
//     return;
//   }
//
//   printer.setStyles(PosStyles(align: PosAlign.left, bold: true));
//
//   printer.text('Hello, World!');
//   printer.feed(2);
//   printer.cut();
//
//   printer.disconnect();
// }
// }
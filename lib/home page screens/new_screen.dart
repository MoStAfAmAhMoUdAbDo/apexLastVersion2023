// import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:http/http.dart' as http;
// //import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
//
// class pdf_vew_sync extends StatefulWidget {
//   const pdf_vew_sync({super.key});
//
//   @override
//   State<pdf_vew_sync> createState() => _pdf_vew_syncState();
// }
//
// class _pdf_vew_syncState extends State<pdf_vew_sync> {
//   // late PdfViewerController _pdfViewerController;
//   // final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     _pdfViewerController = PdfViewerController();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:const  Text("PDF View"),
//         actions: [
//           IconButton(
//               onPressed: share_pdf_network, icon:const  Icon(Icons.share_rounded)),
//           IconButton(onPressed: print_pdf_network, icon:const  Icon(Icons.print)),
//         ],
//       ),
//       body: SfPdfViewer.network(
//         "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
//         controller: _pdfViewerController,
//         key: _pdfViewerKey,
//       ),
//       bottomSheet: Container(
//         width: double.infinity,
//         color: Colors.grey,
//         height: 60,
//         child: Row(
//           children: [
//             IconButton(
//                 onPressed: share_pdf_network, icon:const  Icon(Icons.share_rounded)),
//             IconButton(onPressed: print_pdf_network, icon:const  Icon(Icons.print)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void print_pdf_network() async {
//     //String path= await get_pdf();
//     print("on function print");
//     // http.Response response = await http.get(Uri.parse(path.toString()));
//     var response = await http.get(Uri.parse(
//         "http://192.168.1.253:1001/files/ItemsPrices-15062023122609%D9%85.pdf"));
//     var pdfData = response.bodyBytes;
//     if (response.statusCode == 200) {
//       await Printing.layoutPdf(
//           onLayout: (PdfPageFormat format) async => pdfData);
//     } else {
//       print("has no data and return false");
//     }
//   }
//
//   void createpdf() async {
//     final doc = pw.Document();
//     doc.addPage(
//       pw.Page(
//           pageFormat: PdfPageFormat.a4,
//           build: (pw.Context context) {
//             return pw.Center(
//               child: pw.Text("wefqer"),
//             );
//           }),
//     );
//     await Printing.layoutPdf(
//         onLayout: (PdfPageFormat format) async => doc.save());
//   }
//
//   void share_pdf_network() async {
//     //String path= await get_pdf();
//     //var data = await http.get(Uri.parse(path.toString()));
//     var data = await http.get(Uri.parse(
//         "http://192.168.1.253:1001/files/ItemsPrices-15062023122609%D9%85.pdf"));
//     if (data.statusCode == 200) {
//       Printing.sharePdf(bytes: data.bodyBytes, filename: "document.pdf");
//     } else {
//       print("data faild to share");
//     }
//   }
// }

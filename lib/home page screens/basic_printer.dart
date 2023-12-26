
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import '../api_directory/print_api.dart';
import '../models/printing_model.dart';
import 'massage_toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrintingInvoices{
  printingInvoice(int invoiceId ,String invoiceCode , bool isArabic ,FToast fToast, BuildContext context )async{
   PrintModel printingModel= await PrintingApi().printInvoices(invoiceId, invoiceCode, isArabic);
   if(printingModel.result==1){
     // var data =await http.get(Uri.parse(printingModel.fileUrl!),);
     // await Printing.layoutPdf(
     //   onLayout: (PdfPageFormat format) async => data.bodyBytes,);
    await printingFun(printingModel.fileUrl!);
   }
   else if(printingModel.result ==0){
     MassageForToast().massageForAlert(AppLocalizations.of(context)!.notSaved, false, fToast);
   }
   else if(printingModel.result ==30){
     MassageForToast().massageForAlert(AppLocalizations.of(context)!.noPermissionPrint, false, fToast);
   }

  }
  printingFun(String fileUrl)async{
    var data =await http.get(Uri.parse(fileUrl),);
     Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => data.bodyBytes,);
  }
}
import 'package:pdf/widgets.dart';

class AllInvoiceData {
  double? discount;
  String? invoiceDate;
  int? invoiceId;
  int? invoiceSubTypesId;
  String? invoiceType;
  int? invoiceTypeId;
  int? paymentType;
  String? personNameAr;
  String? personNameEn;
  double? totalPrice;

  AllInvoiceData(
      {this.discount,//done
      this.invoiceId,//done
      this.invoiceDate,//done
      this.totalPrice,//done
      this.invoiceSubTypesId,//done
      this.invoiceType,//done
      this.invoiceTypeId,//done
      this.paymentType,
      this.personNameAr, //done
      this.personNameEn //don
      });
  factory AllInvoiceData.fromJson(Map<String,dynamic>json){
    AllInvoiceData allInvoiceData=AllInvoiceData();
    allInvoiceData.personNameAr=json['personNameAr']; //done
    allInvoiceData.paymentType=json['paymentType'];//done
    allInvoiceData.invoiceTypeId=json['invoiceTypeId'];//done
    allInvoiceData.invoiceSubTypesId=json['invoiceSubTypesId'];//done
    allInvoiceData.totalPrice=json['totalPrice'];//done
    allInvoiceData.invoiceDate=json['invoiceDate'];//done
    allInvoiceData.invoiceId=json['invoiceId'];//done
    allInvoiceData.discount=json['discount']; //done
    allInvoiceData.personNameEn=json['personNameEn'];//done
    allInvoiceData.invoiceType=json['invoiceType'];//done
    return allInvoiceData;
  }
}

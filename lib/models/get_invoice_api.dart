import 'all_invoice_data.dart';

class DataFromApi{
  int? result;
  String? errorMassageAr;
  String? errorMassageEn;
  String? socketError;
  List<dynamic>? data=[];
  DataFromApi([this.result,this.errorMassageAr,this.errorMassageEn,this.socketError,this.data]);
}

class PersonInvoiceDropDown{
  int? id;
  String? arabicName;
  String? latinName;
  PersonInvoiceDropDown({this.latinName,this.id,this.arabicName});
  factory PersonInvoiceDropDown.fromJson(Map<String,dynamic>json){
    print("in person fro json");
    PersonInvoiceDropDown personInvoiceDropDown=PersonInvoiceDropDown();
    personInvoiceDropDown.arabicName=json["arabicName"];
    personInvoiceDropDown.id=json["id"];
    personInvoiceDropDown.latinName=json["latinName"];
    return personInvoiceDropDown;
  }
  void  dataparameter(int idd ,String arabname,String latenName){
    this.latinName=latenName;
    this.arabicName=arabname;
    this.id=idd;
  }
}
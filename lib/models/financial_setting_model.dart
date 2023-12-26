
class FinancialSettingModel{
  String? arabicName;
  String? latinName;
  int? id;
  int? linkingMethodId ;
  FinancialSettingModel({this.latinName,this.arabicName,this.id});
  factory FinancialSettingModel.formJson(Map<String,dynamic>json){
    FinancialSettingModel financialSettingModel=FinancialSettingModel();
    financialSettingModel.id=json["id"];
    financialSettingModel.arabicName=json["arabicName"];
    financialSettingModel.latinName=json["latinName"];
    return financialSettingModel;
  }

}
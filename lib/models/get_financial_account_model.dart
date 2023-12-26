
class GetFinancialAccountDropDownModel{
  String? arabicName;
  String? latinName;
  String? code;
  int?fA_Nature;
  int? id;
  GetFinancialAccountDropDownModel();
  factory GetFinancialAccountDropDownModel.fromJson(Map<String,dynamic>json){
    GetFinancialAccountDropDownModel getFinancialAccountDropDownModel=GetFinancialAccountDropDownModel();
    getFinancialAccountDropDownModel.arabicName=json["arabicName"];
    getFinancialAccountDropDownModel.latinName=json["latinName"];
    getFinancialAccountDropDownModel.id=json["id"];
    getFinancialAccountDropDownModel.code=json["code"];
    getFinancialAccountDropDownModel.fA_Nature=json["fA_Nature"];
    return getFinancialAccountDropDownModel;
  }
}
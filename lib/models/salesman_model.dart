class SalesManModel{
  String? arabicName;
  String? latinName;
  int?code;
  int?id;
  SalesManModel({this.id,this.arabicName,this.latinName,this.code});
  factory SalesManModel.fromJson(Map<String,dynamic> json){
    SalesManModel salesManModel=SalesManModel();
    salesManModel.id= json["id"];
    salesManModel.code =json["code"];
    salesManModel.arabicName=json["arabicName"];
    salesManModel.latinName=json["latinName"];
    return salesManModel;
  }
}
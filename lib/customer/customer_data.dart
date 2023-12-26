class customer {
  int? id;
  int? code;
  String? ArabName;
  String? LatinName;
  double? vatValue;
  int? status;
  int? usdInSales;
  String? imageurl;
  customer(
      {this.id,
      this.ArabName,
      this.code,
      this.imageurl,
      this.LatinName,
      this.status,
      this.usdInSales,
      this.vatValue});

  customer.fromjson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.vatValue = json['vatValue'];
    this.usdInSales = json['usedInSales'];
    this.status = json['status'];
    this.LatinName = json['latinName'];
    this.imageurl = json['imagePath'];
    this.code = json['code'];
    this.ArabName = json['arabicName'];
  }
}

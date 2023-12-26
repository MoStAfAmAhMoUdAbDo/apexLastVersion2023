class CategoryData {
  int? catId;
  String? arabicName;
  String? latinName;
  String? imageUrl;
  CategoryData(this.catId, this.arabicName, this.imageUrl, this.latinName);
  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
        json["id"], json["arabicName"], json["imagePath"], json["latinName"]);
  }
}

class Item {
  bool isEdite=false;
  String? arabName;
  String? latinName;
  String? imageUrl;
  int? id;
  bool? applyVAT;
  bool? applyVATEdite;
  double? vatRatio;
  double vatValue = 0;
  String? itemCode;
  List<Unit> units=[];
  int dropDownIndex = 0;
  double itemDisccount = 0.0;
  String itemDisccountType = "fixed";
  String? expiryItemDate;
  List<String>? existedSerials ;
  List<String> selectedSerialItems=[];
  int? invoiceId;
  double qty = 1;
  bool canDelete=false;
  String? balanceBarcode;
  bool isBalanceBarcode =false;
  double? conversionFactor;
  int? indexOfItem;
  bool? get applyVate{
    var vatG;
    if(isEdite==false ){
      vatG= applyVAT == null && applyVATEdite !=null ? applyVATEdite : applyVAT;
    }
    else{
      vatG=applyVATEdite;
    }
    return  vatG;
      //(isEdite==false  ? applyVAT : applyVATEdite);
  }
  double get discountValue {
    double price=priceGenrel;
    if (itemDisccountType == "fixed") {
      return itemDisccount;
    } else {
      return (itemDisccount / 100) * (price * qty);
    }
  }

  double get price {
    return (oldPrice == 0
        ? (dropDownValue == null
            ? units[0].salePrice1!
            : dropDownValue!.salePrice1!)
        : updatePrice);
  }
  double get discountRatio {
    double price=priceGenrel;
    double discount = 0;
    if(price==0)
      return 0;
    if (itemDisccountType == "fixed") {
      discount = (itemDisccount / (price * qty)) * 100;
    } else {
      discount = itemDisccount;
    }
    return discount;
  }
  double get priceGenrel {
    if(oldPrice == 0){
      if(isEdite==false){
        if(dropDownValue == null){
         return units[0].salePrice1!;
        }
        else{
          return dropDownValue!.salePrice1!;
        }
      }
      else{
        return itemPriceEdit!;
      }
    }
    else{
      return updatePrice ;
    }

  }
  double? get vatRatioe{
    var vatG;
    if(isEdite==false ){
      vatG= vatRatio == null && vatRatioEdit !=null ? vatRatioEdit : vatRatio;
    }
    else{
      vatG=vatRatioEdit;
    }
    return  vatG;
    //return (isEdite==false  ? vatRatio :vatRatioEdit );
  }
  double? get vatval{
    var vatG;
    if(isEdite==false ){
      vatG= vatValue == null && vatValueEdit !=null ? vatValueEdit : vatValue;
    }
    else{
      vatG=vatValueEdit;
    }
    return  vatG;
    //return (isEdite==false  ? vatValue :vatValueEdit );
  }

  double? discountRatioEdite;
  double? discountValueEdite;
  double? splitedDiscountRatioEdit;
  double? splitedDiscountValueEdit;
  double? vatRatioEdit;
  double? vatValueEdit;
  int?unitId;
  double? itemPriceEdit;



  // double discountRatio= (discountAmount / get_total_price())*100;
  double oldPrice = 0;
  double updatePrice = 0;
  Unit? dropDownValue;
  int? itemTypeId;
 List <ExpiryDate> expiryDate=[];
  double splitValue = 0;


  Item.a();
  Item(this.latinName, this.arabName, this.id, this.applyVAT, this.imageUrl,
      this.itemCode, this.vatRatio, this.units, this.itemTypeId,this.expiryDate ,this.existedSerials);
  Item copyWith({int? id, String? arabName ,String? latinName,String? imageUrl,
    bool? applyVAT ,double? vatRatio ,double? vatValue ,String? itemCode,List<Unit>? units,
    int? itemTypeId,List <ExpiryDate>? expiryDate ,List<String>?  existedSerials
  })
  {
    return Item(
        latinName ?? this.latinName,
        arabName ?? this.arabName, id??this.id, applyVAT?? this.applyVAT ,
        imageUrl?? this.imageUrl, itemCode?? this.itemCode,vatRatio??this.vatRatio,
        units??this.units ,itemTypeId??this.itemTypeId , expiryDate??this.expiryDate, existedSerials??this.existedSerials

    );
  }
  factory Item.fromJson(Map<String, dynamic> json) {
    List<Unit> unitList = [];
    List <ExpiryDate> expiry=[];
    List<String> serialList=[];
    for (var c in json['units']) {
      unitList.add(Unit.fromjson(c));
    }
    if(json['expiaryData']!=null){
      for (var c in json['expiaryData']) {
        expiry.add(ExpiryDate.fromjson(c));
      }
    }
    if(json['existedSerials']!=null){
      for (var c in json['existedSerials']) {
        serialList.add(c);
      }
    }

    return Item(
      json["latinName"],
      json["arabicName"],
      json["id"],
      json["applyVAT"],
      json["imagePath"],
      json["itemCode"],
      json["vatRatio"],
      unitList,
      json["itemTypeId"],
      expiry,
      serialList
    );
  }
  factory Item.fromBarCodeJson(Map<String, dynamic> json) {
    List<Unit> unitList = [];
    List <ExpiryDate> expiry=[];
    List<String> serialList=[];
    for (var c in json['units']) {
      unitList.add(Unit.fromjson(c));
    }
    if(json['expiaryData']!=null){
      for (var c in json['expiaryData']) {
        expiry.add(ExpiryDate.fromjson(c));
      }
    }
    if(json['existedSerials']!=null){
      for (var c in json['existedSerials']) {
        serialList.add(c);
      }
    }
    Item item=Item.a();
    item.latinName=json["latinName"];
    item.arabName=json["arabicName"];
    item.itemCode=json["itemCode"];
    item.itemTypeId=json["itemTypeId"];
    item.applyVAT=json["applyVAT"];
    item.imageUrl=json["imagePath"];
    item.vatRatio=json["vatRatio"];
    item.expiryDate=expiry;
    item.existedSerials=serialList;
    item.balanceBarcode=json["balanceBarcode"];
    item.isBalanceBarcode=json["isBalanceBarcode"] == null ? false : json["isBalanceBarcode"] ;
    item.id=json["id"];
    item.qty=json["itemQuantity"];
    item.units = unitList;
    //item.price=json["price"];
    return item;
  }
}


class Unit {
  int? unitId;
  String? arabName;
  String? latinName;
  double? conversionFactor;
  double? salePrice1;
  int? itemId; // new some changes here
  Unit(this.arabName, this.conversionFactor, this.latinName, this.salePrice1,
      this.unitId ,this.itemId);

  factory Unit.fromjson(Map<String, dynamic> json) {
    return Unit(
      json["arabicName"],
      json["conversionFactor"],
      json["latinName"],
      json["salePrice1"],
      json["unitId"],
      json["itemId"] //new some changes here
    );
  }
}

class ExpiryDate
{
 String? expiryInvoice ;
 double? qtyDate;
 ExpiryDate([this.expiryInvoice ,this.qtyDate]);
 factory ExpiryDate.fromjson(Map<String,dynamic> json){
   return ExpiryDate(
     json["expiaryOfInvoice"],
     json["quantityOfDate"]
   );
 }
}

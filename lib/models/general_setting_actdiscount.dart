class GeneralSettingActiveDis {
  bool priceIncludeVat;
  bool activeDiscount ;
  bool popModifyPrice;
  GeneralSettingActiveDis(this.activeDiscount,this.priceIncludeVat,this.popModifyPrice);
  factory GeneralSettingActiveDis.fromJson(Map<String,dynamic>json){
    return GeneralSettingActiveDis(json["pos_ActiveDiscount"] , json["pos_PriceIncludeVat"] , json["pos_ModifyPrices"]);
  }
}
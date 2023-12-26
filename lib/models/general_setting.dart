class GeneralSetting {
   bool vatActive;
   double vatDefaultValue ;
  GeneralSetting(this.vatActive,this.vatDefaultValue);
  factory GeneralSetting.fromJson(Map<String, dynamic> json) {
    return GeneralSetting(
        json["vat_Active"], json["vat_DefaultValue"]);
  }
}